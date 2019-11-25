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
