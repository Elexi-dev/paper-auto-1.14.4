#!/bin/bash
#https://github.com/Elexi-dev/paper-auto-1.14.4
#Check for Updates
sh updatescript/updatething.sh
#Start Server
current=`cat updatescript/currentversion.txt`
java -Xms128M -Xmx${SERVER_MEMORY}M -Dterminal.jline=false -Dterminal.ansi=true -jar paper-${current}.jar
