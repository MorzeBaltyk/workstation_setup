#Usefull for the function sr to check which OS before
function getOS ()
{ 
        no_more_than_one $@ || return 1
        validatehost $@ || return 1
        myOS=$(ssh $@ "uname") 
}

function get_host_records ()
{
    check_input $@ || return 1;
    OneHOST=`echo "$1" | tr '[:upper:]' '[:lower:]'`;

}

function test () 
{
myOS=$(getOS $1)
echo $?
#if [[ "$(getOS $1)" != 0 ]]; then msg_ok "OK"; else msg_error "NOK"; fi
}

