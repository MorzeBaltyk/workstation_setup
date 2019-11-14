function check_input () 
{
        if [ $# -eq 0 ];
        then
                echo "Please Provide Arguments"
                return 1
        fi
} 

function no_more_than_one ()
{
	if [ $# -gt 1 ];
	then
		echo "Please, Only One Arguments"
	        return 1	
	fi
}

#Usefull for the function sr to check which OS before
function getOS ()
{ 
	no_more_than_one $@ || return 1
	validatehost $@ || return 1
	whichOS=$(ssh $@ "uname") 
	echo $whichOS 
}

# Check if host exist and answer to ping 
function validatehost () 
{ 
    local MYHOST;
    check_input $@ || return 1;
    MYHOST=`echo "$1" | tr '[:upper:]' '[:lower:]'`;
    GETENTINFO=`getent hosts $MYHOST`;
    if [ "$?" -eq 0 ]; then
        GETENTHOST=`echo $GETENTINFO | awk '{print $2}'| cut -d. -f1`;
        if [ "$2" == "-v" ]; then
            if [ "$MYHOST" != "$GETENTHOST" ]; then
                echo "$MYHOST is an alias for $GETENTHOST";
            fi;
            echo $GETENTHOST;
        fi;  
        if [ "`uname -s`" == "SunOS" ]; then
            :;
        else
            ping -c1 $MYHOST -w1 > /dev/null;
        fi;
        if [ $? -ne 0 ]; then
            echo "Host \"$MYHOST\" is not responding" && return 1;
        fi;
    else
        [ "$2" != "-q" ] && echo "Host \"$MYHOST\" is unknown" && return 1;
    fi
}


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

