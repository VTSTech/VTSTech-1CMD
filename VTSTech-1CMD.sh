#!/bin/bash
# Program: VTSTech-1CMD.sh
# Version: 0.0.4 Revision 26
# Operating System: Kali Linux
# Description: Bash script to run dnsrecon, nmap, sslscan, wpscan, urlscan in 1 command. Output saved per tool/target.
# Author: Written by Veritas//VTSTech (veritas@vts-tech.org)
# GitHub: https://github.com/Veritas83
# Homepage: www.VTS-Tech.org
# Dependencies: dnsrecon, nmap, sslscan, wpscan, urlscan, wget
# apt-get install dnsrecon nmap wget wpscan sslscan urlscan


v=0.0.4-r26
echo " _    _________________________________  __";
echo "| |  / /_  __/ ___/_  __/ ____/ ____/ / / /";
echo "| | / / / /  \__ \ / / / __/ / /   / /_/ / ";
echo "| |/ / / /  ___/ // / / /___/ /___/ __  /  ";
echo "|___/ /_/  /____//_/ /_____/\____/_/ /_/   ";
echo "                                           ";
banner="VTSTech-1CMD v$v\nWritten by Veritas (veritas@vts-tech.org)\nHomepage: www.VTS-Tech.org\nRequires: dnsrecon, nmap, wget, wpscan, sslscan, urlscan\n================================\nUsage: ./VTSTech-1CMD target.com\n\nOptions:\n\n-d Skip dnsrecon\n-n Skip nmap\n-s Skip sslscan\n-wp Skip wpscan\n-wg Skip wget\n-u Skip urlscan\n\n"

#Config
#Missing required tools? Try this: apt-get install dnsrecon nmap wget wpscan sslscan urlscan
list="/usr/share/dnsrecon/namelist.txt" #You might want to change this
ns="8.8.8.8" #set nameserver here, other popular options: 8.8.4.4 (Google DNS), 208.67.222.222 (OpenDNS), 208.67.220.220 (OpenDNS)
dns="1"  #set to 0 to skip dnsrecon or use -d
nmap="1" #set to 0 to skip nmap or use -n
wp="1"   #set to 0 to skip wpscan or use -wp
wg="1"   #set to 0 to skip wget or use -wg
ssl="1"  #set to 0 to skip sslscan or use -s
url="1"  #set to 0 to skip urlscan or use -u
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
    	  if [ $i == "-wp" ]
    	  then
    	    wp=0;
    	  fi
    	  if [ $i == "-wg" ]
    	  then
    	    wg=0;
    	  fi
    	  if [ $i == "-s" ]
    	  then
    	    ssl=0;
    	  fi
    	  if [ $i == "-u" ]
    	  then
    	    url=0;
    	  fi
    	  if [ "-n" != $i ] && [ "-d" != $i ] && [ "-u" != $i ] && [ "-s" != $i ] && [ "-wg" != $i ] && [ "-wp" != $i ]
    	  then
    	    target=$i;
    	    echo -e "Target set to $i\n";
    	  fi
    done
	else
	target=$1;
  echo -e "Target set to $i\n";
  fi
fi

dnscmd="dnsrecon -t std,srv,zonewalk,brt -n $ns -D $list -z -f --iw --threads 2 --lifetime 10 --xml $HOME/Scans/dnsrecon-$target.xml -d $target"
nmapcmd="sudo nmap -sSV -sC safe -T3 -O -A -vv -F -n -oX $HOME/Scans/nmap-$target.xml --stylesheet https://svn.nmap.org/nmap/docs/nmap.xsl -Pn --fuzzy --osscan-guess --reason $target"
sslcmd="sslscan --verbose --no-colour --show-certificate --xml=$HOME/Scans/sslscan-$target.xml $target"
wpcmd="wpscan -e vt,vp,tt,u[1-20] -t 2 -v --no-color --batch --log $HOME/Scans/wpscan-$target.txt --url $target"
wpcmd2="wpscan -e vt,vp,tt,u[1-20] -t 2 -v --no-color --batch --log $HOME/Scans/wpscan-https.$target.txt --url https://$target"
wgetcmd="wget -t 4 --content-on-error http://$target/ -O $HOME/Scans/wget-$target.txt"
urlcmd="urlscan -c -n $HOME/Scans/wget-$target.txt"


function 1cmd {
  mkdir $HOME/Scans;
  if [ $dns -eq 1 ]
  then
    echo -en "[+] Running dnsrecon.\nOutput: $HOME/Scans/dnsrecon-$target.xml\n\n";
    echo -e  "[+] cmdline: $dnscmd\n\n";
    $dnscmd
  fi
  if [ $dns -eq 0 ] 
  then
    echo -en "[-] Skipping dnsrecon.\n\n";
  fi
  if [ $nmap -eq 1 ]
  then
    echo -en "[+] Running nmap...\nOutput: $HOME/Scans/nmap-$target.xml\n\n";
    echo -e  "[+] cmdline: $nmapcmd\n\n";
    $nmapcmd
    echo -en "[+] nmap complete.\n\n";
  fi
  if [ $nmap -eq 0 ]
  then
    echo -en "[-] Skipping nmap.\n\n";
  fi
  if [ $ssl -eq 1 ]
  then
		echo -en "[+] Running sslscan.\nOutput: $HOME/Scans/sslscan-$target.xml\n\n";
  	echo -e  "[+] cmdline: $sslcmd\n\n";
  	$sslcmd
  	echo -en "[+] sslscan complete.\n\n";
	fi
  if [ $ssl -eq 0 ]
  then
    echo -en "[-] Skipping sslscan.\n\n";
  fi
  if [ $wp -eq 1 ]
  then
		echo -en "[+] Running wpscan.\nOutput: $HOME/Scans/wpscan-$target.txt & wpscan-https.$target.txt\n";
	  echo -e "[+] cmdline: $wpcmd\n\n";
    $wpcmd
	  echo -e "[+] cmdline: $wpcmd2\n\n";
	  $wpcmd2
	  echo -e "[+] wpscan complete.\n\n";
	fi
  if [ $wp -eq 0 ]
  then
    echo -en "[-] Skipping wpscan.\n\n";
  fi
  if [ $wg -eq 1 ]
  then
	echo -en "[+] Running wget. Output: $HOME/Scans/wget-$target.txt\n\n";
  echo -e "[+] cmdline: $wgetcmd\n\n";
  $wgetcmd
  echo -e "[+] wget complete.\n\n";
	fi
  if [ $wg -eq 0 ]
  then
    echo -en "[-] Skipping wget.\n\n";
  fi
  if [ $url -eq 1 ]
  then
	echo -en "Running urlscan. Output: $HOME/Scans/urlscan-$target.txt\n\n";
  echo -e "[+] cmdline: $urlcmd\n\n";
  $urlcmd > $HOME/Scans/urlscan-$target.txt
	fi
  if [ $url -eq 0 ]
  then
    echo -en "[-] Skipping urlscan.\n\n";
  fi

  echo -e "\n\n[*] All Operations completed!\n";
}

if [ $# -gt 0 ]
then
  1cmd
fi
