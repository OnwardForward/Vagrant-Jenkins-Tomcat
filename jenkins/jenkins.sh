#!/bin/bash -x


#Script to setup Jenkins on centOS/RHEL 6.x and 7.x

#Author Serge  Aug 2017
#Modify: sept 2019
#Modified: Jun 2020
#Modified: sept 2021


OS_VERSION=`cat /etc/*release |grep VERSION_ID |awk -F\" '{print $2}'`
OS_TYPE=`cat /etc/*release|head -1|awk '{print $1}'`



echo -e "\n Checking if your server is connected to the network...."

sleep 4

ping google.com -c 4 

if
  [[ ${?} -ne 0 ]]
 then
 echo -e "\nPlease verify that your server is connected!!\n"
 exit 2
 fi
 
echo -e "\nChecking if system is centOS 6 or 7\n"

if 
  [[ ${OS_VERSION} -eq 7 ]] && [[ ${OS_TYPE} == CentOS ]]
 then
 echo -e "\nDetected that you are running CentOS 7 \n"

sleep 6
echo "installing Java 8 and other packages..."
sleep 3

yum install java-1.8* wget vim epel-release -y
echo "checking the java version, please wait"

echo

sleep 2

java -version

sleep 2

echo "now donloading jenkins..."

sleep 4
echo

wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
echo

echo "extracting the package..."

sleep 2

echo

sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/jenkins.repo

#rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key


echo

echo "installing jenkins..."

echo

sleep 2
yum clean all
yum install jenkins -y

echo "Start jenkins services"
sleep 3 
service jenkins start

   if [ $? -ne 0 ] 
   then 
   echo "Installation FAILED.."
   exit 1
   fi

chkconfig jenkins on

#echo -e "\n Installing ip tables package...\n"

#sleep 3
#yum install iptables-services -y 

echo "configuring the port 8080 on the firewall for jenkins server"
sleep 3
systemctl restart firewalld 
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --reload
#sed -i '/:OUTPUT ACCEPT/a \-A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT' /etc/sysconfig/iptables
#echo 
#echo "Restart iptables services "
#service iptables restart
sleep 2

echo "done"

echo
echo " Use this link to access your jenkins server. http://$(hostname -I |awk '{print $1}'):8080"
echo
exit 0

else

echo -e "\nDetected that you are running Centos 6\n"

sleep 6 
echo "installing Java8..."
sleep 3

yum install java-1.8* -y
echo "checking the java version, please wait"

echo

sleep 2

java -version

sleep 2

echo "now donloading jenkins..."

sleep 4
echo

wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
echo

echo "extracting the package..."

sleep 2

echo

sed -i 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.repos.d/jenkins.repo

#rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key

echo

echo "installing jenkins..."

echo

sleep 2

yum install jenkins -y

echo "Start jenkins services"
sleep 3 
service jenkins start
chkconfig jenkins on

echo "configuring the port 8080 on the firewall for jenkins server"
sleep 3
sed -i '/:OUTPUT ACCEPT/a \-A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT' /etc/sysconfig/iptables
echo 
echo "Restart iptables services "
service iptables restart
sleep 2

echo "done"

echo
echo " Use this link to access your jenkins server. http://$(ifconfig |grep Bcast |awk '{print $2}' |awk -F":" '{print $2}'):8080"
echo

fi

exit 0 
