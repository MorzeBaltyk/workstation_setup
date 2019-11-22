RED="\e[0;31m"
LIGHT_RED="\e[1;31m"
BKG_RED="\e[1;41m"
GREEN="\e[0;32m"
LIGHT_GREEN="\e[1;32m"
BKG_GREEN="\e[1;42m"
CYAN="\e[0;36m"
LIGHT_CYAN="\e[1;36m"
YELLOW="\e[0;33m"
LIGHT_YELLOW="\e[1;33m"
PURPLE="\e[0;35m"
LIGHT_PURPLE="\e[1;35m"
BLUE="\e[1;34m"
LIGHT_BLUE="\e[1;34m"
WHITE="\e[1;37m"
BLACK="\e[0;30m"
DARK_GREY="\e[1;30m"
LIGHT_GREY="\e[0;37m"
NC="\e[0m"

BOLD="\e[1m"

############ All in One ###############
function ls_msg ()
{
msg "Called by function : ${BOLD}msg${NC}"
msg_error "Called by function : ${BOLD}msg_error${NC}"
msg_warning "Called by function : ${BOLD}msg_warning${NC}"
msg_ok "Called by function : ${BOLD}msg_ok${NC}"
msg_help "Called by function : ${BOLD}msg_help${NC}"
msg_info "Called by function : ${BOLD}msg_info${NC}"
msg_comment "Called by function : ${BOLD}msg_comment${NC}"
msg_bandeau "Called by function : msg_bandeau"
msg_error_bandeau "Called by function : msg_error_bandeau"
msg_ok_bandeau "Called by function : msg_ok_bandeau"

echo -e "\n Called by function : ${BOLD}msg_separator${NC}"
msg_separator
}


### No check_input in those functions, sometime we need to call those Flag alone without arguments ###
function msg ()
{
    echo -e "$@"
}

function msg_error ()
{
    echo -e "[${LIGHT_RED}!${NC}]${LIGHT_RED}ERROR:${NC} $@"
}

function msg_warning ()
{
    echo -e "[${LIGHT_YELLOW}=${NC}]${LIGHT_YELLOW}WARN:${NC} $@"
}

function msg_ok ()
{
    echo -e "[${LIGHT_GREEN}v${NC}]${LIGHT_GREEN}OK:${NC} $@"
}

function msg_help ()
{
    echo -e "[${LIGHT_CYAN}?${NC}]${LIGHT_CYAN}USAGE:${NC} $@"
}

function msg_info ()
{
    echo -e "[${LIGHT_GREY}*${NC}]${LIGHT_GREY}INFO:${NC} $@"
}

function msg_comment ()
{
    echo -e "${LIGHT_BLUE}#$@${NC}"
}

############### Bandeau ###############
function msg_bandeau ()
{
	[ $# -eq 0 ] && msg_help "$FUNCNAME <message> " && return 1
	msg_line "" = c "$@"
}

function msg_error_bandeau ()
{
        [ $# -eq 0 ] && msg_help "$FUNCNAME <message> " && return 1
	MSG=$(msg_line "" = c "$@")
        echo -e "${BKG_RED}${MSG}${NC}"
}

function msg_ok_bandeau ()
{
        [ $# -eq 0 ] && msg_help "$FUNCNAME <message> " && return 1
	MSG=$(msg_line "" = c "$@")
	echo -e "${BKG_GREEN}${MSG}${NC}"
}

############## Misc ####################
msg_separator()
{
# This one uses the printf command to print an empty field with a minimum field width of 20 characters.
# The text is padded with spaces, since there is no text, you get 20 spaces. The spaces are then converted to - by the tr command.
# example: printf '%20s\n' | tr ' ' -

  local len char
  len=${1:-80}
  char=${2:-"#"}
  printf '%*s\n' $len ' ' | tr ' ' $char
}

function msg_line ()
{
  if [ $# -lt 4 ]; then 
	  msg_help "$FUNCNAME <width> <pre/suffix> <l|c> <message> "
	  msg_comment "\t \$1: line lenght"
	  msg_comment "\t \$2: line prefix/suffix (ex: +, =, !, or empty)"
	  msg_comment "\t \$3: text position [l]eft or [c]enter"
	  msg_comment "\t \$4...\$n: message to print"
	  return 
  fi

  local width width1 ws1 ws2 prefix pre_len pre post message position
  width=${1:-80}
  shift
  prefix=$1
  shift
  position=${1:-l}
  shift
  message="$@"
  if [ ${#prefix} -gt 0 ]; then
    pre_len=3
    pre=`printf "%*s>" $pre_len ''| tr ' ' $prefix`
    post=`printf "<%*s" $pre_len ''| tr ' ' $prefix`
    else
    pre="";post=""
  fi
  width1=$(($width-${#pre}-${#post}))
  if [ ${#message} -ge $width1 ]; then
    ws1=1
    ws2=1
  else
    if [ "$position" = "l" ]; then
        ws1=1
      else
        ws1=$((($width1-${#message})/2))
    fi
    ws2=$(($width1-${#message}-$ws1))
  fi
  printf "$pre%*s%s%*s$post\n" $ws1 ' ' "$message"  $ws2 ' '
}

function find_color ()
{
    # This program is free software. It comes without any warranty, to
    # the extent permitted by applicable law. You can redistribute it
    # and/or modify it under the terms of the Do What The Fuck You Want
    # To Public License, Version 2, as published by Sam Hocevar. See
    # http://sam.zoy.org/wtfpl/COPYING for more details.

    #Background
    for clbg in {40..47} {100..107} 49 ; do
    	#Foreground
    	for clfg in {30..37} {90..97} 39 ; do
    		#Formatting
    		for attr in 0 1 2 4 5 7 ; do
    			#Print the result
    			echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
    		done
    		echo #Newline
    	done
    done

#    exit 0
}
