#Usefull for the function sr to check which OS before
function getOS ()
{ 
        no_more_than_one $@ || return 1
        validatehost $@ || return 1
        whichOS=$(ssh $@ "uname")
        echo $whichOS 
}

function get_host_records ()
{
    check_input $@ || return 1;
    OneHOST=`echo "$1" | tr '[:upper:]' '[:lower:]'`;

}

