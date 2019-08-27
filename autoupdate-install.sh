# Put anything else above this line!
# ----------------------------------

start(){
cd /mnt/server
echo "Starting Auto Updater Installation..."
currentvercheck(){
	if [ -f currentversion.txt ]; then
		echo "currentversion exists..."
		cd ../
		echo "creating start..."
		cat << 'EOF' > start.sh
#!/bin/bash
#Check for Updates
sh updatescript/updatething.sh
#Start Server
current=`cat updatescript/currentversion.txt`
java -Xms128M -Xmx${SERVER_MEMORY}M -Dterminal.jline=false -Dterminal.ansi=true -jar waterfall-${current}.jar
EOF
		chmod +x start.sh
		echo "Auto Updater Installation Finished"
		cd
	else
		echo "creating currentversion..."
		cat << 'EOF' > currentversion.txt
0
EOF
		currentvercheck
	fi
}
currentmc(){
	if [ -f currentmc.txt ]; then
		echo "currentmc exists..."
		currentvercheck
	else
		echo "creating currentversion..."
		cat << 'EOF' > currentmc.txt
1.14
EOF
		currentmc
	fi
}
uthingcheck(){
	if [ -f updatething.sh ]; then
		echo "updatething exists..."
		currentmc
	else
		echo "creating updatething..."
		cat << 'EOF' > updatething.sh
#!/bin/bash
cd updatescript/
currentmc=`cat currentmc.txt`
current=`cat currentversion.txt`
echo "Checking for Server Update..."
newthing=`curl -s "https://papermc.io/api/v1/waterfall/${currentmc}" | jq -r '.builds | .latest' 2>&1 | tee latestversion.txt`
echo "Latest Waterfall is on version ${newthing}"
startserver(){
  echo "Starting Server"
}
comparedemapples(){
	if [ "${newthing}" -gt "${current}" ]; then
		echo "waterfall-${newthing}.jar is a new update."
		echo "Updating to waterfall-${newthing}.jar"
		wget -nv -nc --content-disposition https://papermc.io/api/v1/waterfall/${currentmc}/${newthing}/download
		file="waterfall-${newthing}.jar"
		if [ -f "${file}" ]; then
			echo "waterfall-${newthing}.jar has been downloaded. Renaming some shit..."
			rm -R ../waterfall-${current}.jar
			mv waterfall-${newthing}.jar ../waterfall-${newthing}.jar
			echo "${newthing}" > currentversion.txt
			startserver
		else
			echo "Error 404: waterfall-${newthing}.jar could not be found."
			comparedemapples
		fi
	else
		echo "waterfall-${newthing}.jar is already installed and running."
		echo "You good on your updates my dude."
		startserver
	fi
}
comparedemapples
EOF
		chmod +x updatething.sh
		uthingcheck
	fi
}
dircheck(){
	if [ -d updatescript ]; then
		echo "updatescript dir exists..."
		cd updatescript
		uthingcheck
	else
		echo "creating dir updatescript..."
		mkdir updatescript
		dircheck
	fi
}
dircheck
}
start
