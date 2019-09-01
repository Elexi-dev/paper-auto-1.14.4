#!/bin/bash
#Check for Updates
#https://github.com/Elexi-dev/paper-auto-1.14.4
git checkout master
git stash
git pull
git stash pop --quiet
#Start Server
java -Xms128M -Xmx${SERVER_MEMORY}M -Dterminal.jline=false -Dterminal.ansi=true -jar paper.jar
