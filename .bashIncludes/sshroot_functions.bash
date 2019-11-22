function sr ()
{
# getOS use check_input and validatehost
myOS=$(getOS $1)

case $myOS in 
  Linux*)
	  if [ $# -gt 1 ]
	  then
		  ssh_root_linux_exec $@
	  else 
		  ssh_root_linux $1 
	  fi
	  ;;
	
  SunOS*)
	  if [ $# -gt 1 ]
	  then
		  ssh_root_solaris_exec_filtered $@
	  else 
		  ssh_root_solaris $1 
	  fi
	  ;;

  *)
	  msg_error "Functions was not set for this OS" && return 1
	  ;;
esac
}

function sre ()
{
# getOS use check_input and validatehost
myOS=$(getOS $1)

case $myOS in
  Linux*)
          ssh_root_linux_exec $@
          ;;

  SunOS*)
          ssh_root_solaris_exec_filtered $@
          ;;

  *)
          msg_error "Functions was not set for this OS" && return 1
          ;;
esac
}

function ssh_root_solaris ()
{
# connect to remote host as root
validatehost $1 || return 1
ssh_opsys_ux.ex $@ 
}

function ssh_root_solaris_exec ()
{
# execute cmd on remote host as root
validatehost $1 || return 1
ssh_opsys_ux_exit.ex $@
}

function ssh_root_solaris_exec_filtered ()
{
# execute sre cmd and remove first 5 lines as well as the last 2 lines of the output
validatehost $1 || return 1
ssh_root_solaris_exec $@ | sed '1,5d;$d'|sed '$d'
}

function ssh_root_linux ()
{
[ -z "$mypasswd" ] && definemypasswd
# connect to remote host as root
validatehost $1 || return 1
ssh_sudo_i.ex $@
}

function ssh_root_linux_exec ()
{
[ -z "$mypasswd" ] && definemypasswd
# execute cmd on remote host as root
validatehost $1 || return 1
ssh_sudo_i_exec_cmd.ex $@ | sed '1d;$d' | sed '$d'
}

function definemypasswd ()
{
echo -n "password for carochr: "; stty -echo; read mypasswd; export mypasswd; stty echo; echo
}

