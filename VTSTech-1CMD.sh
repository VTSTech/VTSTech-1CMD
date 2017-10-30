#!/bin/bash
# Program: VTSTech-1CMD.sh
# Version: 0.0.4-r20
# Operating System: Kali Linux
# Description: Bash script to run dnsrecon, nmap, sslscan, wpscan, urlscan in 1 command. Output saved per tool/target.
# Author: Written by Veritas//VTSTech (veritas@vts-tech.org)
# GitHub: https://github.com/Veritas83
# Homepage: www.VTS-Tech.org
# Dependencies: dnsrecon, nmap, sslscan, wpscan, urlscan, wget
# apt-get install dnsrecon nmap wget wpscan sslscan urlscan


v=v0.0.4-r20
echo " _    _________________________________  __";
echo "| |  / /_  __/ ___/_  __/ ____/ ____/ / / /";
echo "| | / / / /  \__ \ / / / __/ / /   / /_/ / ";
echo "| |/ / / /  ___/ // / / /___/ /___/ __  /  ";
echo "|___/ /_/  /____//_/ /_____/\____/_/ /_/   ";
echo "                                           ";
banner="VTSTech-1CMD $v\nWritten by Veritas (veritas@vts-tech.org)\nHomepage: www.VTS-Tech.org\nRequires: dnsrecon, nmap, wget, wpscan, sslscan, urlscan\n================================\nUsage: ./VTSTech-1CMD target.com\n\nOptions:\n\n-d Skip dnsrecon\n-n Skip nmap\n\n"

#Config
#Missing required tools? Try this: apt-get install dnsrecon nmap wget wpscan sslscan urlscan
list="/usr/share/dnsrecon/namelist.txt" #You might want to change this
ns="8.8.8.8" #set nameserver here, other popular options: 8.8.4.4 (Google DNS), 208.67.222.222 (OpenDNS), 208.67.220.220 (OpenDNS)
dns="1"  #set to 0 to skip dnsrecon or use -d
nmap="1" #set to 0 to skip nmap or use -n
#EndConfig

if [ $# -eq 0 ]
then
	echo -e $banner
else
	echo -e $banner
	if [ $# -gt 1 ]
	then
  	for i in $@
  	  do
    	  if [ $i == "-d" ]
    	  then
    	    dns=0;
        fi
    	  if [ $i == "-n" ]
    	  then
    	    nmap=0;
    	  fi
    	  if [ "-n" != $i ] && [ "-d" != $i ]
    	  then
    	    target=$i;
    	    echo "Target set to $i";
    	  fi
    done
	else
	target=$1;
  fi
fi

dnscmd="dnsrecon -t std,srv,zonewalk,brt -n $ns -D $list -z -f --threads 1 --lifetime 10 --xml dnsrecon-$target.xml -d $target"
nmapcmd="nmap -sSUV -T3 -O -A -vv -n -oX nmap-$target.xml -Pn -F --fuzzy --osscan-guess --reason --script banner,ftp-anon,ftp-proftpd-backdoor,ftp-vsftpd-backdoor,http-dlink-backdoor,http-headers,http-internal-ip-disclosure,http-robots.txt,http-shellshock,ms-sql-info,mysql-info,nbstat,ntp-info,realvnc-auth-bypass,resolveall,smb-os-discovery,smb-system-info,ssl-heartbleed,upnp-info,vnc-info --script-args http-shellshock.cmd=ls,newtargets,resolveall.hosts=$target,vulns.showall=2 --version-intensity 4 $target"
sslcmd="sslscan --verbose --no-colour --show-certificate --xml=sslscan-$target.xml $target"
wpcmd="wpscan -e vt,vp,tt,u[1-20] -t 2 -v --no-color --batch --url $target > wpscan-$target.txt"
wpcmd2="wpscan -e vt,vp,tt,u[1-20] -t 2 -v --no-color --batch --url https://$target > wpscan-https.$target.txt"
wgetcmd="wget -t 4 --content-on-error http://$target/ -O wget-$target.txt"
urlcmd="urlscan -c -n wget-$target.txt > urlscan-$target.txt"


function 1cmd {
  if [ $dns -eq 1 ]
  then
    echo -en "Running dnsrecon.\nOutput: dnsrecon-$target.xml\n";
    echo -e "cmdline: $dnscmd\n";
    $dnscmd
  fi
  if [ $dns -eq 0 ] 
  then
    echo -en "Skipping dnsrecon.\n";
  fi
  if [ $nmap -eq 1 ]
  then
    echo -en "Running nmap (w\ Shellshock+Heartbleed+ProFTP,VSFTP,DLink,RealVNC Backdoors. MySQL/MSSQL/UPnP/SMB/NTP/VNC Info).\nOutput: $HOME/Scans/nmap-$target.xml\n";
    echo -e "cmdline: $nmapcmd\n";
    $nmapcmd
    echo -en "nmap complete.\n\nRunning sslscan.\nOutput: sslscan-$target.xml\n";
  fi
  if [ $nmap -eq 0 ]
  then
    echo -en "Skipping nmap.\n";
  fi
  echo -e "cmdline: $sslcmd\n";
  $sslcmd
  echo -en "sslscan complete.\n\nRunning wpscan.\nOutput: wpscan-$target.txt & wpscan-https.$target.txt\n";
  echo -e "cmdline: $wpcmd\n";
  wpscan -e vt,vp,tt,u[1-20] -t 2 -v --no-color --batch --url $target > wpscan-$target.txt
  echo -e "cmdline: $wpcmd2\n";
  wpscan -e vt,vp,tt,u[1-20] -t 2 -v --no-color --batch --url https://$target > wpscan-https.$target.txt
  echo -e "wpscan complete.\n\nRunning wget. Output: wget-$target.txt\n";
  echo -e "cmdline: $wgetcmd\n";
  $wgetcmd
  echo -e "wget complete.\n\nRunning urlscan. Output: urlscan-$target.txt\n";
  echo -e "cmdline: $urlcmd\n";
  urlscan -c -n wget-$target.txt > urlscan-$target.txt
  echo -e "\n\nAll Operations completed!\n";
}

if [ $# -gt 0 ]
then
  1cmd
fi