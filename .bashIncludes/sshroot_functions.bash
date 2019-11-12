function sr ()
{
# connect to remote host as root
validatehost $1 || return 1
ssh_opsys_ux.ex $@ 
}

function sre ()
{
# execute cmd on remote host as root
validatehost $1 || return 1
ssh_opsys_ux_exit.ex $@
}

function sref ()
{
# execute sre cmd and remove first 5 lines as well as the last 2 lines of the output
validatehost $1 || return 1
sre $@ | sed '1,5d;$d'|sed '$d'
}

function srl ()
{
[ -z "$mypasswd" ] && definemypasswd
# connect to remote host as root
validatehost $1 || return 1
ssh_sudo_i.ex $@
}

function srle ()
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

