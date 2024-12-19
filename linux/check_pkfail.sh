#/bin/bash -e

# N.B. Now only the certificates in the PK, KEK and db UEFI variables are checked.

os_id() {
  [ -e /etc/os-release ] && awk -F '=' '/^ID=/ {id=$2; sub(/^"/,"",id); sub(/"$/,"",id); print id}' /etc/os-release
}

case `os_id` in
  debian)
    if ! command -v efi-readvar > /dev/null; then
      sudo apt install -y efitools
    fi
    ;;

  arch)
    if ! command -v efi-readvar > /dev/null; then
      sudo pacman --noconfirm -S efitools
    fi
    ;;

  *)
    echo "Unsupported Operating System"
    exit 1
    ;;
esac

var_list="PK KEK db"
for var in ${var_list}; do
  if efi-readvar -v $var | grep -qE 'DO NOT (TRUST|SHIP)'; then
    echo "Test key FOUND."
  fi
done
