#Usefull for the function sr to check which OS before
function getOS ()
{ 
        no_more_than_one $@ || return 1
        validatehost $@ || return 1
        myOS=$(ssh $@ "uname") 
}

function get_host_records ()
{
    check_input $@ || return 1
    no_more_than_one $@ || return 1
    H=$1
    DOMAIN=.opoce.cec.eu.int
    HOST=${H}${DOMAIN}
    ADDR=`dig ${HOST} +short | sed 's/\.$//'`
    if [ -n "$ADDR" ]; then
        if [ `dig $HOST | grep "^$HOST" | awk '{print $4}'` == "A" ]; then
            REVERSE=`dig -x $ADDR | awk '/'$HOST'/{print $1}'| sed 's/\.$//'`
            printf "%-40s %-12s %s\n" $HOST "A" $ADDR $REVERSE "PTR" $HOST
        else
            if [ `dig $HOST | grep "^$HOST" | awk '{print $4}'` == "CNAME" ]; then
                printf "%-40s %-12s %-40s %s\n" $HOST "CNAME" $ADDR
            fi
        fi
    fi

}

function get_host_records_list () 
{
	BKP=""
	for h in $@; do get_host_records $h; done
}
