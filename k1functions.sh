#!/bin/bash
# Run a python http server but list the files with the link, defining the interface
function k1simplehttplist () {
    interface="$1"
    if [ -z "$1" ]
    then
        echo 'Usage: simplehttplist <interface>. ex: simplehttplist eth0'
        return
    fi
    address=$(ifconfig "$interface" 2> /dev/null | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
    for file in *
    do
        echo http://"$address":8080/"$file"
    done
    python -m SimpleHTTPServer 8080
}

# List interfaces and their IP
function k1getifaces () {
    for iface in $(ip a | grep "state UP" | cut -d ' ' -f 2 | tr -d ':')  
    do
        IP=$(ip addr show dev "$iface" | grep inet | cut -d ' ' -f 6) 2> /dev/null
        if [[ -n "$IP" ]]
        then       
            echo "$iface"
            echo "$IP"
            echo '············'
        fi
    done
}

# Show your cheats!
function k1cheats () {
    cat ~/.cheats
}

# Edit your cheats
function k1editcheats () {
    if [[ -z $(which editor | grep found) ]]
    then
        editor ~/.cheats
    elif [[ -z $(which vim | grep found) ]]
    then
        vim ~/.cheats
    elif [[ -z $(which nano | grep found) ]]
    then
        nano ~/.cheats
    fi
    echo 'aHR0cHM6Ly93d3cueW91dHViZS5jb20vd2F0Y2hcP3ZcPWRRdzR3OVdnWGNRCg=='
    echo "You cheater!, at least share your cheats!"
    echo 'You can change the default editor with "sudo update-alternatives --config editor"'
}

# Upgrade your debian based or arch based distro **QUICK**
function k1upgrade () {
    if [[ -z $(which apt | grep found) ]]
    then 
        sudo apt update
        sudo apt upgrade -y
        sudo apt dist-upgrade -y
        sudo apt full-upgrade -y
    elif [[ -z $(which pacman | grep found) ]]
    then
        if [[ -n $(which reflector | grep found) ]]
        then
            sudo pacman -S reflector
        fi
        sudo reflector --verbose --country='Spain' --country='Germany'  --country='France'  -l 10 -p http --sort rate --save /etc/pacman.d/mirrorlist
        sudo pacman -Sc --noconfirm
        sudo pacman -Syu --noconfirm
        if [[ -z $(which paru | grep found) ]]
        then
            sudo rm -rf ~/.cache/paru
            paru -Syu --aur --noconfirm
        elif [[ -z $(which yay | grep found) ]]
        then
            sudo rm -rf ~/.cache/yay
            yay -Syu --aur --noconfirm
        fi
    fi
}

# Set target function "A-la-metasploit" 
function k1targetset () {
    echo "$1" > ~/target.txt
    TARGET="$1"
    URLTARGET="http://$TARGET/"   
    echo 'Now you can use $TARGET as a shortcut of' "$TARGET"
}
TARGET=$(cat ~/target.txt)
URLTARGET="http://$TARGET/"

# Flag in md5 format
function k1md5flagger () {
    echo "$(date +"%d/%m/%Y %T")" "$1" flag\{"$(printf "$1"|md5sum|cut -f1 -d " ")"\} >> /home/"$(whoami)"/flags.log
    cat /home/"$(whoami)"/flags.log | tail
    echo "Flag was stored on /home/$(whoami)/flags.log"
}

# Flag in plaintext
function k1flagger () {
    echo "$(date +"%d/%m/%Y %T")" flag\{"$(printf "$1")"\} >> /home/"$(whoami)"/flags.log
    cat /home/"$(whoami)"/flags.log | tail
    echo "Flag was stored on /home/$(whoami)/flags.log"
}

# Does disk smart for each disk
function k1diskcheck () {
    disks=($(lsblk -l | grep disk | grep -v SWAP | tr -sC 1 | cut -d " " -f 1))
    for i in "${disks[@]}"
    do
        sudo smartctl -a "/dev/$i" | grep -i "result"
    done
}

# Indexes a folder, only filenames.
function k1index () {
    find $(pwd) -not -path "*/?snapshot/*" -not -path "*/?recycle/*" -not -path "*/@eaDir/*" | sort > Index.txt
}

# Copies the specified file or folder adding .bak to the name
function k1bak () {
    cp -r $1 $1.bak
}

# Recovers the specified file from its .bak backup
function k1rec () {
    cp -r $1.bak $1
}

function k1location () {
    echo '───────────────────────────────────── ─ ─ ─ ─ ┄ ┄ · 
    k1functions: **L O A D E D**'" from $(pwd)"'
    ───────────────────────────────────── ─ ─ ─ ─ ┄ ┄ · 
    '
}

#k1location
