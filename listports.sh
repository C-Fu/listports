#!/bin/bash
#                                               #
# Script author: C-Fu @ HomeLAB.my              #
# Note: If url doesn't work, maybe it's https?  #
#                                               #
#################################################


BOLD=$(printf '\e[1m')
UNBOLD=$(printf '\e[0m')
# printf "${BOLD}This text is also bold${UNBOLD}\nBut this is not"

# Get just the first IP based off of hostname -I command
SERVER_IP=$(hostname -I | cut -d' ' -f1)

# Get the hostname
SERVER_NAME=$(hostname)

# date format to append to the end of the output filename, eg listports-yyyy-mm-dd-231259.md
OUTPUT_DATE=$(date +"%Y-%m-%d_%H%M%S")

# output filename
OUTPUT_FILE="$SERVER_NAME""_ports_""$OUTPUT_DATE"".md"

# date format to append the output filename, eg listports-yyyy-mm-dd-231259.md
OUTPUT_DATE=$(date +"%Y-%m-%d_%H%M%S")

# Markdown-format cat
cat > "$OUTPUT_FILE" <<EOF
############################################################
#
# List all currently using ports
# List generated on $(date +"%A, %d %B %Y at %I:%M:%S %p.")
#
############################################################


- **$SERVER_NAME:$SERVER_IP**
EOF

# Main code, based from docker ps formatting
docker ps --format "{{.Names}}" | while read -r SERVICE_NAME; do
    # docker inspect with formatting
    PORTS=$(docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{if $conf}}{{$p}} -> {{(index $conf 0).HostPort}}{{"\n"}}{{end}}{{end}}' "$SERVICE_NAME")

    # Layout style
    if [[ -n "$PORTS" ]]; then
        echo "  - **$SERVICE_NAME**" >> "$OUTPUT_FILE"

        # Var init
        TEMP_PORT_FILE=$(mktemp)

        # Port Mapping
        echo "$PORTS" | while read -r PORT_MAPPING; do
            if [[ "$PORT_MAPPING" == *"->"* ]]; then
                HOST_PORT=$(echo "$PORT_MAPPING" | awk -F'-> ' '{print $2}')

                if [[ -n "$HOST_PORT" ]]; then
                    echo "    - [**$SERVER_NAME:$HOST_PORT**](http://$SERVER_IP:$HOST_PORT)" >> "$TEMP_PORT_FILE"
                fi
            fi
        done

        # Save to output file
        sort -u "$TEMP_PORT_FILE" >> "$OUTPUT_FILE"
        rm -f "$TEMP_PORT_FILE"
    fi
done


# Endgame
cat $OUTPUT_FILE
printf "\n\n${BOLD}##################################################################################\n${UNBOLD}Listed docker ports saved to ${BOLD}$OUTPUT_FILE\n##################################################################################\n${UNBOLD}"
