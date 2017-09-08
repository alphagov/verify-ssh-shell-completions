#!/usr/bin/env bash

SEDPAT='/^\[/d;'              # Remove lines starting with [
SEDPAT="$SEDPAT /ansible/d;"  # Remove lines containing ansible
SEDPAT="$SEDPAT /#/d;"        # Remove lines containing #
SEDPAT="$SEDPAT /^\s*$/d;"    # Remove lines containing whitespace only
SEDPAT="$SEDPAT /^[0-9]/d;"   # Remove lines starting with a number
SEDPAT="$SEDPAT /^[^\.]*$/d;" # Remove lines not containing a dot (.)

_complete-ssh () {
  local cur hostnames inventory
  inventory=$(awk -F= '/inventory/ {gsub(/ /, "", $2); gsub(/~/, "'$HOME'", $2); print $2}' "${VERIFY_ANSIBLE_DIR}/ansible.cfg")
  cur=${COMP_WORDS[COMP_CWORD]}

  if [ -d $inventory ]; then
    hostnames=$(sed "$SEDPAT" "${inventory}"* | sort -u | paste -sd "$IFS" -)

  elif [ -x $inventory ]; then
    hostnames=$($inventory --cache-only | jq -r '.[].hosts[]?' | sort -u | paste -sd "$IFS" -)

  elif [ -f $inventory ]; then
    hostnames=$(sed "$SEDPAT" ${inventory} | sort -u | paste -sd "$IFS" -)

  else
    >&2 echo
    >&2 echo "Could not find inventory file $inventory. Make sure $VERIFY_ANSIBLE_DIR/ansible.cfg has an absolute path to its hosts file."
  fi

  COMPREPLY=( $( compgen -W  "$hostnames" -- "$cur" ) )
}

if [ -z "$VERIFY_ANSIBLE_DIR" ]
then
  >&2 echo 'Error: VERIFY_ANSIBLE_DIR must be set'
else
  complete -F _complete-ssh ssh
fi
