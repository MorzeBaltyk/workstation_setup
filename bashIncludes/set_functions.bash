# Define additional dirs in the PATH
function addpath () {
  [ $# -eq 0 ] && return 1
  case ":${PATH}:" in
    *:"$1":*)
     ;;
    *)
    if [ -d "$1" ]; then
       if [ "$2" = "after" ] ; then
           PATH=$PATH:$1
       else
           PATH=$1:$PATH
       fi
    fi
     ;;
  esac
}

function setproxy() {
# Those Var are defined in .privInclude
# Set by default in .bashrc for only local station
#proxy_server=" "
#proxy_port=" "
#proxy_username=
#proxy_password=
export {http,https,ftp}_proxy=https://${proxy_username}:${proxy_password}@${proxy_server}:${proxy_port}
}

function unsetproxy() {
    unset {http,https,ftp}_proxy
}

