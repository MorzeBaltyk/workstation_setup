# Bashrc should be only for local Desktop,
# HomeDir shared with NFS, so a double check is necessary
if [ ${HOSTNAME%%.*} == " " ]
then
  export PRIV_DESKTOP=""
  #Change this to the account you use to login to other hosts if your not your local username (e.g. root)
  export SERV_ACC="" 
  shopt -q login_shell || source ~/.bash_profile  #We don't want to end up in an infinite loop
  [[ -r ~/.bash_completion ]] && source ~/.bash_completion  #If you have a bash_completion source, put it here
  [[ -f /usr/bin/exa ]] && alias ls='exa --git'  #Uncomment to use exa instead of ls
  [[ -f /usr/bin/exa ]] && alias ll='exa --git -larsold'  #Uncomment to use exa instead of ls
  #alias cd='pushd >/dev/null'  #Uncomment to use popd instead of cd
  [[ -f /usr/bin/prettyping ]] && alias ping='prettyping'
  [[ -f /usr/bin/vimdiff ]] && alias diff='vimdiff'
  #alias top='htop'  #Commented in .bashrc if you're not using screenFunctions.bash
  alias rsync='rsync --info=progress2'
  [[ -f /usr/bin/bat ]] && alias cat='bat -p'

  [[ -f ~/.privIncludes/setproxy.bash ]] && setproxy
fi
