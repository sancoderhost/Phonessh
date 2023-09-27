# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
#export ANDROID_SDK_ROOT=$HOME/Android/Sdk
#export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
#export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
shopt -s extglob
alias clip='xclip -sel clip '
alias reboot='systemctl reboot'
alias snap4='/home/sanbotbtrfs/grubwork/snap4.sh'
alias vcs='/home/sanbotbtrfs/vcs.sh'
alias share='/home/sanbotbtrfs/share2.sh'
alias share2='/home/sanbotbtrfs/share3.sh'
export LD_LIBRARY_PATH=/usr/local/lib
export urlregex='https?:\/\/(?:www\.)?([-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b)*(\/[\/\d\w\.-]*)*(?:[\?])*(.+)*'
export ipregex='([0-9]{1,3}\.){3}[0-9]{1,3}'
[[ -z $SSH_TTY  ]] || export DISPLAY=:0 
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
alias loglink='~/sshfs.sh  && ( pkill pcmanfm ;  vim ~/Desktop/phonefuse/syncnotes/links.txt )'

alias journal='~/sshfs.sh  && ( pkill -9 pcmanfm ;  vim ~/Desktop/phonefuse/syncnotes/journal.md )'
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
alias ll='ls -l'
alias c+='compile_run.sh'
alias c_run='c_run2.sh'
if [ -f /etc/bash_completion ] ;
 then 
 	. /etc/bash_completion
 fi
alias vi=vim 
#alias kodi='export DISPLAY=:0 ; flatpak run tv.kodi.Kodi 2>/dev/null &'
export PATH=$PATH:/home/sanbotbtrfs/.local/bin:/home/sanbotbtrfs/python/cpp/:/home/sanbotbtrfs/grubwork/:/home/sanbotbtrfs/bin/
wifi_rescan()
{
	nmcli d wifi rescan 
}
wifi_connect()
{
nmcli d wifi connect Redmi\ Note\ 7\ Pro_2717
}
phone_ssh()
{

        idkey='/home/sanbotbtrfs/phoneid'
		checkflag=0
        ping -c 1 phone.local >/dev/null 2>&1
        if [[ $? -ne 0 ]] 
        then
                if host=$(ip neigh  | awk   '/([0-9]{1,3}\.){3}[0-9]{1,3}/ {print $1}' |nmap -p 1111  --open   -iL   -  |grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' )
                then

                        echo 'mdns failed ,bruteforce fallback'
			ssh -i $idkey -p 1111  $host /data/data/com.termux/files/home/mdns.sh
                else
                        echo 'no server'
						#exit 1
						checkflag=1
                fi
        else
                echo 'mdns ,  phone.local  detected'
                host='phone.local'
				if !  nmap -p 1111 --open $host | grep -ow 1111  >/dev/null  2>&1 
				then
						checkflag=1
                        echo 'no server'
				fi 
        fi

		if [[ $checkflag -eq  0 ]]
		then
				printf "select =>\n 1>ssh \n 2>sftp \n 3>sshfs \n ==> "
				read choice
        	if [[ $choice -eq 1  ]]
        	then
        	        ssh -i $idkey -o StrictHostkeychecking=no  -p 1111 $host
        	elif [[ $choice -eq 2  ]]
        	then
        	        sftp -i $idkey -o StrictHostkeychecking=no  -P 1111 $host
        	elif (( choice == 3  ))
        	then
        	        if [[ ! -d ~/Desktop/phonefuse/ ]]
        	        then
        	                mkdir ~/Desktop/phonefuse
        	        fi
        	        sshfs -o IdentityFile=/home/sanbotbtrfs/phoneid  -o StrictHostkeychecking=no  -p 1111 $host:/sdcard/  ~/Desktop/phonefuse/
        	        pcmanfm ~/Desktop/phonefuse/ &
        	else
        	        echo "wrong choice!"
        	fi
		else
				echo 'exiting..'
		fi
}

 security_update()
 {
     sudo apt update;
 echo "======================Security_updates============================="
 apt list --upgradable 2>/dev/null |awk -F / '/stable-security/ {print $1}' |tee /tmp/securityupdate ;
  echo '===================================================================\nwant to update (y/n) and for changelogs press c ' ;
  read -r  yes ;
  if [ "$yes" = 'y' ];
  then
    xargs   sudo apt -y install </tmp/securityupdate;
 elif [ "$yes" = 'c' ];

 then
       xargs   sudo apt -y changelog  </tmp/securityupdate;

  echo '===================================================================\nwant to update (y/n)  ' ;
  read -r yess ;
  if [ "$yess" = 'y'  ]
  then
       xargs   sudo apt -y install </tmp/securityupdate;
  fi
 else
      echo 'abort';
  fi
 }


. "$HOME/.cargo/env"
