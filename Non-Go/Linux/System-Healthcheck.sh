#/bin/sh

echo "Showing all processes"
ps aux
echo "Seeing processes running as root"
ps aux | grep root
echo "Listing all logged in users."
ps au
echo "Listing current user's home directory"
ls /home
echo "Listing SSH keys for current user"
ls -l ~/.ssh
echo "Check the current user's bash history"
history
echo "Shows commands that the current user can run with Sudo"
sudo -l
echo "Looks for daily cron jobs"
ls -la /etc/cron.daily
echo "Checking for unmounted file systems or drives."
lsblk
echo "Find world-writeable directories"
find / -path /proc -prune -o -type d -perm -o+w 2>/dev/null
echo "Find world-writeable files"
find / -path /proc -prune -o -type f -perm -o+w 2>/dev/null
echo "Checking the kernal version" 
uname -a 	
echo "Check the OS version"
cat /etc/lsb-release
echo "Find binaries with the SUID bit set"
find / -user root -perm -4000 -exec ls -ldb {} \; 2>/dev/null
echo "Find binaries with the SETGID bit set"
find / -user root -perm -6000 -exec ls -ldb {} \; 2>/dev/null
echo "Check the current user's PATH variable"
echo $PATH
echo "Viewing the shared objects required by a given binary file (ls used here)"
ldd /bin/ls 	#View the shared objects required by a binary
