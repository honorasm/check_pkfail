#/bin/bash -e

os_id() {
  [ -e /etc/os-release ] && awk -F '=' '/^ID=/ {id=$2; sub(/^"/,"",id); sub(/"$/,"",id); print id}' /etc/os-release
}

case `os_id` in
  debian)
    echo "This is Debian."
    ;;

  *)
    echo "Unsupported Operating System"
    exit 1
    ;;
esac
