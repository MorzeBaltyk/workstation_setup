# We only load our bashrc for a local session
[[ -r ~/.bashrc ]] && shopt -q login_shell && . ~/.bashrc

### Fix to load the ${SERV_ACC} profile on other systems with some setup
# On distant Server
#if [ -z "$PRIV_DESKTOP" ]
#then
#   [ $(uname | grep SunOS) ] && [[ -r .profile ]] && source .profile
#   [[ -r /tmp/corpVars.bash.tmp ]] && source /tmp/corpVars.bash.tmp
#   PATH=${PATH}:/bin:${CORPPATHS}
#   [ $(uname | grep Linux) ] && [[ -r .bash_profile ]] && source .bash_profile
#fi

case $OSTYPE in
        FreBSD*)
          SU=/usr/bin/su
          P_ID=/usr/bin/id
          BASHPATH=/usr/local/bin/bash
          E_GREP=/usr/bin/egrep
          ;;
        solaris*)
          SU=/bin/su
          P_ID=/usr/xpg4/bin/id
          BASHPATH=/usr/bin/bash
          E_GREP=/usr/xpg4/bin/egrep
          alias id='/usr/xpg4/bin/id'
          ;;
        linux*)
          SU=/bin/su
          P_ID=/usr/bin/id
          BASHPATH=/bin/bash
          E_GREP=/bin/egrep
          ;;
        darwin*)
          SU=/usr/bin/su
          P_ID=/usr/bin/id
          BASHPATH=/bin/bash
          E_GREP=/bin/egrep
          ;;
esac

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

############################################################################
#      Common vars
############################################################################
export SERV_ACC=carochr #Need to put it here as well for distant connexion
export PAGER=less
export EDITOR=vim
export MANPATH=/usr/man:/usr/openwin/share/man:/usr/dt/man:/usr/opt/SUNWmd/man:/opt/SUNWatm/man:/usr/local/man:/usr/local/teTeX/man:/usr/local/ecb-doc/man:/usr/sfw/share/man:/usr/local/rrdtool/man:/usr/cluster/man:/opt/SUNWcluster/man:/usr/share/man:
export TMP=~/tmp/

############################################################################
#      Aliases
############################################################################

alias vt=' TERM vt100 ; stty rows 24'
alias dy='date +%Y%m%d'
#alias cd="pushd >/dev/null"
alias memfree='free -m | grep Mem |  awk '\''{print $4}'\'''
alias swapfree='free -m | grep Swap |  awk '\''{print $4}'i\'''
alias pz="ps -ef|${E_GREP} -v '/usr/lib/saf/sac|/usr/lib/saf/ttymon|/usr/lib/utmpd|/usr/sbin/syslogd|/usr/cluster/lib/sc/failfastd|/usr/sbin/cron|zsched|/usr/lib/nfs/nfsmapid|/usr/lib/nfs/nfs4cbd|/usr/lib/inet/inetd|/sbin/init|/usr/lib/ldap/ldap_cachemgr|/usr/sbin/rpcbind|/usr/lib/ssh/sshd|/usr/lib/sendmail|/usr/lib/saf/ttymon|/usr/lib/autofs/automountd|/usr/sbin/nscd|/usr/lib/nfs/lockd|/usr/lib/crypto/kcfd|/usr/lib/nfs/statd|/usr/lib/krb5/ktkt_warnd|/usr/lib/autofs/automountd|/usr/cluster/lib/sc/pmmd|/lib/svc/bin/svc.startd|/lib/svc/bin/svc.configd|/usr/cluster/lib/sc/rpc.pmfd|/usr/bin/login|ps -ef|-bash|0:00 -sh|/usr/cluster/lib/|/usr/cluster/bin/cl|/usr/bin/bash|/usr/local/ecbmon/|[.*]|grep '"
alias lsf='compgen -A function'
alias vib='vim ~/.bash_profile'
alias vibr='vim ~/.bashrc'
alias lsopen='lsof +aL1'
alias win="'/usr/bin/rdesktop -d publications -x 0x80 -P  -a 32 -g 1920x1024 -u carochr opdt218'"
#Local aliases for myself.
alias path='echo $PATH'
alias pycharm='~/Tools/pycharm/latest/bin/pycharm.sh &'
alias t='task +READY' # Taskwarrior
alias td='task burndown.daily'
alias tw='task burndown.weekly'
[[ -z "$PRIV_DESKTOP" ]] && alias ll='ls -lart'


function calcspace() {
echo "scale=1; $(df -k | egrep -e '(/dev/|rpool)' | grep -v /fd | grep -v cdrom | grep -v /global/.devices | grep -v /global/mgmt | awk '{s+=$3} END {print s}') / 1014^2" | bc
}

############################################################################
#      Personal sourcing
############################################################################
## On Local Desktop ; but HomeDir Shared
#if [ ! -z "$PRIV_DESKTOP" ]; then
   #for FILE in /home/$SERV_ACC/.privIncludes/*.bash; do
   for FILE in ~/.privIncludes/*.bash; do
      source $FILE
   done
   #for FILE in /home/$SERV_ACC/.bashIncludes/*.bash; do
   for FILE in ~/.bashIncludes/*.bash; do
      source $FILE
   done
#fi

############################################################################
#	PATH
############################################################################
addpath /sbin after
addpath /home/admin/bin after
addpath ~/git/workstation_setup/bin after

############################################################################
#      PROMPT
############################################################################
pRED="\[\033[0;31m\]"
pGREEN="\[\033[0;32m\]"
pLIGHT_GREEN="\[\033[1;32m\]"
pLIGHT_RED="\[\033[1;31m\]"
pWHITE="\[\033[1;37m\]"
pCYAN="\[\033[0;36m\]"
pYELLOW="\[\033[0;33m\]"
pLIGHT_CYAN="\[\033[1;36m\]"
pLIGHT_YELLOW="\[\033[1;33m\]"
pPURPLE="\[\033[0;35m\]"
pLIGHT_PURPLE="\[\033[1;35m\]"
NO_COLOUR="\[\033[0m\]"

# COLORS Applied to root/ or Not and my desktop or not
if [ $($P_ID -u) -eq 0 ];
then
   if [ ! -z "$PRIV_DESKTOP" ]
   then
      STR_COLOUR=$pLIGHT_GREEN
   else
      if [ $(uname | grep Linux) ]
      then
         STR_COLOUR=$pRED
      else
         STR_COLOUR=$pLIGHT_PURPLE
	   fi
   fi
   ID_COLOUR=$pRED
else
   if [ ! -z "$PRIV_DESKTOP" ]
   then
      STR_COLOUR=$pGREEN
   else
      if [ $(uname | grep Linux) ]
      then
         STR_COLOUR=$pRED
      else
         STR_COLOUR=$pPURPLE
      fi
   fi
   ID_COLOUR=$pCYAN
fi

EXTRA_PROMPT_COLOUR=${STR_COLOUR}
[ `zone-where 2>/dev/null` ] && EXTRA_PROMPT=":$(zone-where)" && EXTRA_PROMPT_COLOUR=${pPURPLE} # bit of Solaris prompt magic
[ $(uname | grep Linux) ] && [ -z "$PRIV_DESKTOP" ] && EXTRA_PROMPT=":$(lsb_release -a | grep Distributor | awk '{print $3}' | cut -c 1)$(lsb_release -a | grep Release | awk '{print $2}' | cut -c 1-3)" && EXTRA_PROMPT_COLOUR=${pRED}
# Putting the RHEL version in the prompt.

if [[ ! -z "$PRIV_DESKTOP" || $(whoami) == $SERV_ACC ]]; then
   PS1="${TITLEBAR}[${ID_COLOUR}\u${NO_COLOUR}@${STR_COLOUR}\h${EXTRA_PROMPT_COLOUR}$EXTRA_PROMPT${NO_COLOUR}]"'$(git_indicator)$(task_indicator)'"${NO_COLOUR}\w\$ "
else
   PS1="${TITLEBAR}[${ID_COLOUR}\u${NO_COLOUR}@${STR_COLOUR}\h${EXTRA_PROMPT_COLOUR}$EXTRA_PROMPT${NO_COLOUR}]\w${NO_COLOUR}\$ "
fi
if [ ! -z "$PRIV_DESKTOP" ]
then
   if [ -z "$BASH" ]; then bash
   else
      #PS1="${TITLEBAR}[${ID_COLOUR}\u${NO_COLOUR}@${STR_COLOUR}\h${NO_COLOUR}]\w${NO_COLOUR}\$ "
      shopt -s histappend
      shopt -s histreedit
      shopt -s cmdhist
      shopt -s checkwinsize
      export HISTCONTROL=ignorespace:ignoredups
      export HISTIGNORE="ls:ll:pwd:clear"
      export HISTSIZE=500000
      export HISTSIZE=5000000
   fi
else # Your Business Command History setup should be hidden
   [[ -r /tmp/corpHistory.bash.tmp ]] && source /tmp/corpHistory.bash.tmp
fi

export PS1

############################################################################
#    Cleanup of my profile of business hosts I'm connecting to
############################################################################
# Copy le bash_profile when login to distant server.
# In our case of Homedir shared with NFS on all Prod, this is not necessary
#if [ -z "$PRIV_DESKTOP" ]
#then
#	rm -f /tmp/bash_profile.tmp /tmp/*.bash.tmp
#fi
