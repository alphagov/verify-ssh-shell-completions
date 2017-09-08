SEDPAT='/^\[/d;'              # Remove lines starting with [
SEDPAT="$SEDPAT /ansible/d;"  # Remove lines containing ansible
SEDPAT="$SEDPAT /#/d;"        # Remove lines containing #
SEDPAT="$SEDPAT /^\s*$/d;"    # Remove lines containing whitespace only
SEDPAT="$SEDPAT /^[0-9]/d;"   # Remove lines starting with a number
SEDPAT="$SEDPAT /^[^\.]*$/d;" # Remove lines not containing a dot (.)

_complete-ssh() {
  local hostnames inventory

  if [ -z "$VERIFY_ANSIBLE_DIR" ]
  then
      >&2 echo 'Error: VERIFY_ANSIBLE_DIR must be set'
  else
    inventory=$(awk -F= '/inventory/ {gsub(/ /, "", $2); gsub(/~/, "'$HOME'", $2); print $2}' "${VERIFY_ANSIBLE_DIR}/ansible.cfg")

    if [ -d $inventory ]; then
      hostnames=$(sed "$SEDPAT" "${inventory}"* | sort -u | paste -s -)

    elif [ -x $inventory ]; then
      hostnames=$($inventory --cache-only | jq -r '.[].hosts[]?' | sort -u | paste -sd " " -)

    elif [ -f $inventory ]; then
      hostnames=$(sed "$SEDPAT" ${inventory} | sort -u | paste -s -)

    fi

    compadd ${=hostnames}
  fi
}

compdef _complete-ssh ssh
