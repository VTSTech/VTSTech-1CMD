#!/bin/bash
# Program: VTSTech-1CMD.sh
# Version: 0.0.4-r19
# Operating System: Kali Linux
# Description: Bash script to run dnsrecon, nmap, sslscan, wpscan, urlscan in 1 command. Output saved per tool/target.
# Author: Written by Veritas//VTSTech (veritas@vts-tech.org)
# GitHub: https://github.com/Veritas83
# Homepage: www.VTS-Tech.org
# Dependencies: dnsrecon, nmap, sslscan, wpscan, urlscan, wget
# apt-get install dnsrecon nmap wget wpscan sslscan urlscan

v=v0.0.4-r19
banner="VTSTech-1CMD $v\nWritten by Veritas (veritas@vts-tech.org)\nHomepage: www.VTS-Tech.org\nRequires: dnsrecon, nmap, wget, wpscan, sslscan, urlscan\n================================\nUsage: ./VTSTech-1CMD target.com\n\n"

if [ $# -eq 0 ]
then
	echo -e $banner
else
	echo -e $banner
	target=$1
fi

#Config
#Missing required tools? Try this: apt-get install dnsrecon nmap wget wpscan sslscan urlscan
list=/usr/share/dnsrecon/namelist.txt #You might want to change this
ns=8.8.8.8 #set nameserver here, other popular options: 8.8.4.4 (Google DNS), 208.67.222.222 (OpenDNS), 208.67.220.220 (OpenDNS)
dns=1 #set to 0 to skip dnsrecon
dnscmd="dnsrecon -t std,srv,zonewalk,brt -n $ns -D $list -z -f --threads 1 --lifetime 10 -d $target > dnsrecon-$target.txt" #59!
nmapcmd="nmap -sSUV -T3 -O -A -vv -n -oN nmap-$target.txt -Pn -F --fuzzy --osscan-guess --reason --script banner,ftp-anon,ftp-proftpd-backdoor,ftp-vsftpd-backdoor,http-dlink-backdoor,http-headers,http-internal-ip-disclosure,http-robots.txt,http-shellshock,ms-sql-info,mysql-info,nbstat,ntp-info,realvnc-auth-bypass,resolveall,smb-os-discovery,smb-system-info,ssl-heartbleed,upnp-info,vnc-info --script-args http-shellshock.cmd=ls,newtargets,resolveall.hosts=$target,vulns.showall=2 --version-intensity 4 $target"
sslcmd="sslscan --verbose --no-colour --show-certificate $target > sslscan-$target.txt"
wpcmd="wpscan -e up -t 1 -v --no-color --batch --url $target > wpscan-$target.txt"
wgetcmd="wget -t 4 --content-on-error http://$target/ -O wget-$target.txt"
urlcmd="urlscan -c -n wget-$target.txt > urlscan-$target.txt"
#EndConfig

function 1cmd {
	echo -e "cmdline: $nmapcmd\n"
	$nmapcmd
	echo -en "nmap complete.\n\nRunning sslscan.\nOutput: sslscan-$target.txt\n"
	echo -e "cmdline: $sslcmd\n"
	sslscan --verbose --no-colour --show-certificate $target > sslscan-$target.txt
	echo -en "sslscan complete.\n\nRunning wpscan.\nOutput: wpscan-$target.txt\n"
	echo -e "cmdline: $wpcmd\n"
	wpscan -e up -t 1 -v --no-color --batch --url $target > wpscan-$target.txt
	echo -e "wpscan complete.\n\nRunning wget. Output: wget-$target.txt\n"	
	echo -e "cmdline: $wgetcmd\n"
	$wgetcmd
	echo -e "wget complete.\n\nRunning urlscan. Output: urlscan-$target.txt\n"	
	echo -e "cmdline: $urlcmd\n"
	urlscan -c -n wget-$target.txt > urlscan-$target.txt
	echo -e "\n\nAll Operations completed!\n"
}
if [ $# -eq 1 ]
then
if [ $dns -eq 1 ]
then
	echo -en "Running dnsrecon.\nOutput: dnsrecon-$target.txt\n"
	echo -e "cmdline: $dnscmd\n"
	dnsrecon -t std,srv,zonewalk,brt -n $ns -D $list -z -f --threads 1 --lifetime 10 -d $target > dnsrecon-$target.txt
	echo -en "dnsrecon complete.\n\nRunning nmap (w\ Shellshock+Heartbleed+ProFTP,VSFTP,DLink,RealVNC Backdoors. MySQL/MSSQL/UPnP/SMB/NTP/VNC Info).\nOutput: $HOME/Scans/nmap-$target.txt\n"
	1cmd
else
	echo -en "Skipping dnsrecon. Running nmap (w\ Shellshock+Heartbleed+ProFTP,VSFTP,DLink,RealVNC Backdoors. MySQL/MSSQL/UPnP/SMB/NTP/VNC Info).\nOutput: $HOME/Scans/nmap-$target.txt\n"
	1cmd
fi
fi