function check_input () 
{
if [ $# -eq 0 ];then
   msg_error "Please Provide Arguments"
   return 1
fi
} 

function no_more_than_one ()
{
if [ $# -gt 1 ];then
   msg_error "Please, Only One Argument"
   return 1	
fi
}

function check_file ()
{
if [ ! -f "$1" ]; then
   msg_error "File "$1" not found, EXIT"
   return 1
fi
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


############ Confirmation #############
function confirm_execution ()
{
  local MSG
  MSG=${@:-"Confirm execution"}
  read -p "$(msg_warning) ${MSG} [yes no]: " ans
  c=`echo $ans | awk '{print substr(tolower($0),0,1)}'`
  if [ "$c" != "y" ]; then
      msg_error "Execution cancelled"
      return 1
  fi
}

