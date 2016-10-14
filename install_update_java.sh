#!/bin/bash
# INSTALL JDK, FOR EXAMPLE jdk-7u79-linux-x64.tar.gz

#
#	to use this script :
#
#	 -> to install new JDK, choose the first option (1) download the JDK (should be in this form : jdk-XuXX-linux[-x64].tar.gz) 
#	   	and pass it as parameter to the command like this :
#		\>./install_update_java.sh jdk-XuXX-linux[-x64].tar.gz
#
#	 -> to update alternatives : choose the second option (2), just run the command as follow :
#		\>./install_update_java.sh
#

JDK_NAME=$1
readonly JDK_NAME
JAVA_INSTALL_FOLDER_PATH=/usr/local/java/

#Check the installation or the update
CheckInstallOrUpdate () {
	echo ""
	echo ""
	echo "--- CHECK THE INSTALL ---"
	echo "JAVA_HOME = $JAVA_HOME"

	echo ""
	echo "______java__version______"
	echo ""
	java -version
}

#function to install new JDK
InstallNewJDK () { 
   	echo "Starting Oracle Java JDK Installation..."
	sudo mkdir $JAVA_INSTALL_FOLDER_PATH
	sudo cp $JDK_NAME $JAVA_INSTALL_FOLDER_PATH

	cd $JAVA_INSTALL_FOLDER_PATH

	echo "Unpacking java files in $JAVA_INSTALL_FOLDER_PATH..."

	sudo tar xzf $JDK_NAME

	sudo rm $JDK_NAME
	sleep 1s

	echo ""
	echo "--------------/USR/LOCAL/JAVA FOLDER CONTENT--------------"
	ls

	echo ""
	echo -n "Enter the name of extracted folder > "
	read -e JDK_FOLDER_NAME

	#check if the last char of JDK_FOLDER_NAME is "/" or not
	if [[ "${JDK_FOLDER_NAME:${#JDK_FOLDER_NAME}-1}" != "/" ]];
	then
		JDK_FOLDER_NAME="${JDK_FOLDER_NAME}/"
	fi

	export JAVA_HOME=/usr/local/java/$JDK_FOLDER_NAME
	export PATH=$JAVA_HOME/bin:$PATH
	export PATH=$PATH:$JAVA_HOME/bin

	PATH="$JAVA_INSTALL_FOLDER_PATH$JDK_FOLDER_NAME"
	JAVA_PATH="bin/java"
	JAVAC_PATH="bin/javac"
	JAVAWS_PATH="bin/javaws"

	#this command notifies the system that Oracle Java JRE is available for use
	update-alternatives --install "/usr/bin/java" "java" "$PATH$JAVA_PATH" 1
	#this command notifies the system that Oracle Java JDK is available for use
	update-alternatives --install "/usr/bin/javac" "javac" "$PATH$JAVAC_PATH" 1
	#this command notifies the system that Oracle Java Web start is available for use
	update-alternatives --install "/usr/bin/javaws" "javaws" "$PATH$JAVAWS_PATH" 1

	#this command will set the java runtime environment for the system
	update-alternatives --set java "$PATH$JAVA_PATH"
	#this command will set the javac compiler for the system
	update-alternatives --set javac "$PATH$JAVAC_PATH"
	#this command will set Java Web start for the system
	update-alternatives --set javaws "$PATH$JAVAWS_PATH"

	echo "THE ULTIMATE PATH = $PATH$JAVA_PATH"
	echo "THE ULTIMATE PATH = $PATH$JAVAC_PATH"
	echo "THE ULTIMATE PATH = $PATH$JAVAWS_PATH"

	#echo "export JAVA_HOME=$JAVA_INSTALL_FOLDER_PATH$JDK_FOLDER_NAME" >> ~/.bashrc
	#echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
	#echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc

	. ~/.bashrc

	CheckInstallOrUpdate
}

#function to update Java alternatives
UpdateJavaAlternative () {

	sudo update-alternatives --config java
	. ~/.bashrc

	CheckInstallOrUpdate
}

# clear the screen
tput clear

# Set a foreground colour using ANSI escape
tput cup 3 8
tput setaf 3
echo "INSTALL OR UPDATE JAVA ON YOUR SYSTEM"
tput sgr0
echo ""
echo "____________________________________________________"
echo ""
echo "  Choose an option : "
echo "     1 > Install new JDK"
echo "     2 > Update Java alternatives"
echo "____________________________________________________"
echo ""
echo -n "Your choice (1|2) : "
read CHOICE


if [ $CHOICE -eq 1 ] 
then
	InstallNewJDK
else
	UpdateJavaAlternative
fi
