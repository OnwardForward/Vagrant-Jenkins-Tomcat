#!/bin/bash


#Script to setup Apache Tomcat on centOS/RHEL 6.x and 7.x

#Author Serge  Aug 2017
#Modify: sept 2019


echo -e "\nInstalling tomcat ..\n"

sleep 4

cd /opt

wget http://mirrors.ocf.berkeley.edu/apache/tomcat/tomcat-8/v8.5.71/bin/apache-tomcat-8.5.71.tar.gz
tar -xzvf apache-tomcat-8.5.71.tar.gz

rm -rf apa*.gz
mv apache* tomcat

chmod +x /opt/tomcat/bin/startup.sh
chmod +x /opt/tomcat/bin/shutdown.sh

ln -s /opt/tomcat/bin/startup.sh /usr/local/bin/tomcatup
ln -s /opt/tomcat/bin/shutdown.sh /usr/local/bin/tomcatdown

echo -e "\nStarting tomcat\n"
sleep 4

tomcatup

echo -e "\n Installing ip tables package...\n"

sleep 3
#yum install iptables-services -y

echo "configuring the port 8080 on the firewall for jenkins server"
sleep 3
firewall-cmd --permanent --add-port=8080/tcp
firewall --reload
#sed -i '/:OUTPUT ACCEPT/a \-A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT' /etc/sysconfig/iptables
echo
#echo "Restart iptables services "
#service iptables restart

echo
echo " Use this link to access your tomcat server. http://$(hostname -I |awk '{print $1}'):8080"
echo







