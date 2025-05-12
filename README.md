# ://listports.sh for docker+markdown🐋
Bash shell script to output the list of used docker ports to a MarkDown file, using docker ps, inspect with formatting.
Executable file: `listports.sh`
Output file: `HostName_ports_YYYY-MM-DD_HHMMSS.md`

## Instructions
Either download the `listports.sh` file, or execute directly via `wget`, `curl` or alias:

With `wget`:
```bash
wget -O - https://raw.githubusercontent.com/C-Fu/listports/refs/heads/main/listports.sh | bash
```
With `curl`:
```bash
curl -L https://raw.githubusercontent.com/C-Fu/listports/refs/heads/main/listports.sh | bash
```

As an **alias**:
Edit and add an alias inside your user's existing .bashrc file at the end of the file
```bash
alias listports='curl -L https://raw.githubusercontent.com/C-Fu/listports/refs/heads/main/listports.sh'
```
Then save, and then type this in bash to reload your .bashrc file
```bash
source .bashrc
```
and then just run `listports` command
```bash
$ listports
```
