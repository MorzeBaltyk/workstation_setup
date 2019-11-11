TERM=xterm 
key='r'
while [[ $key == 'r' ]]
do

# Commented because of Homedir shared through NFS.
#	if $(echo $1 | grep -vq '\-sc')
#	then
#	        scp -q ~/bash_profile.tmp ~/.privIncludes/*.bash.tmp root@$1:/tmp/ 2>/dev/null
#	fi

	/usr/bin/ssh $* || echo ''; read -n1 -r -p "Press 'r' to restart connection or any other key to close this screen tab: " key
	echo ''

done

