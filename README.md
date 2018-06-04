Verify Shell Completions
========================

This repository contains ssh shell completions based on Ansible's
knowledge of available hostnames. It's used by the GOV.UK Verify
team to ssh <TAB><TAB> their way onto our servers.

Requirements
------------

- jq (`brew install jq`)
- verify-ansible repository checked out, and you need to have run the `hosts`
  script in verify-ansible to generate a hosts cache file

SSH Shell Completions
---------------------

Shell completion support is implemented for both bash and zsh.

Start by cloning this repo, then activate completions for your shell as
follows.

### Bash

Add the following to your `~/.bashrc`, adjusting any paths as necessary.

```
export IDA_ANSIBLE_DIR="${HOME}/Projects/verify-ansible"
. ~/Projects/verify-ssh-shell-completions/ssh-complete.sh
```

### ZSH

Add the following to your `~/.zshrc`, adjusting paths as necessary.

```
export IDA_ANSIBLE_DIR="${HOME}/Projects/verify-ansible"
source ~/Projects/verify-ssh-shell-completions/ssh-complete.zsh

```

Usage
-----

Completions should now get the full list of hosts from the ansible inventory.

To find out more about the dynamic inventory and how to refresh it see the
[verify-ansible/README.md](https://github.digital.cabinet-office.gov.uk/gds/verify-ansible/tree/master#dynamic-inventory)

