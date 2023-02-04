#!/bin/bash
# Program: VTSTech-1CMD.sh
# Version: 0.0.5 Revision 03
# Operating System: Kali Linux
# Description: Bash script to run dnsrecon, nmap, sslscan, wpscan, urlscan in 1 command. Output saved per tool/target.
# Author: Written by Veritas//VTSTech (veritas@vts-tech.org)
# GitHub: https://github.com/Veritas83
# Homepage: www.VTS-Tech.org
# Dependencies: dnsrecon, nmap, sslscan, wpscan, urlscan, wget
# apt-get install dnsrecon nmap wget wpscan sslscan urlscan


v=0.0.5-r03
echo " _    _________________________________  __";
echo "| |  / /_  __/ ___/_  __/ ____/ ____/ / / /";
echo "| | / / / /  \__ \ / / / __/ / /   / /_/ / ";
echo "| |/ / / /  ___/ // / / /___/ /___/ __  /  ";
echo "|___/ /_/  /____//_/ /_____/\____/_/ /_/   ";
echo "                                           ";
banner="VTSTech-1CMD v$v\nWritten by Veritas (veritas@vts-tech.org)\n"
banner+="Homepage: www.VTS-Tech.org\nRequires: dnsrecon, nmap, wget, wpscan, sslscan, urlscan\n"
banner+="================================\nUsage: ./VTSTech-1CMD target.com\n\nOptions:\n\n"
banner+="-d Use dnsrecon\n"
banner+="-n Use nmap (all stages)\n"
banner+="-n# Use nmap (stage # 1-5)\n"
banner+="-s Use sslscan\n"
banner+="-wp Use wpscan\n"
banner+="-wg Use wget\n"
banner+="-u Use urlscan\n\n"

#Config
#Missing required tools? Try this: apt-get install dnsrecon nmap wget wpscan sslscan urlscan
list="/usr/share/dnsrecon/namelist.txt" #You might want to change this
ns="8.8.8.8" #set nameserver here, other popular options: 8.8.4.4 (Google DNS), 208.67.222.222 (OpenDNS), 208.67.220.220 (OpenDNS)
dns="0"  #set to 0 to skip dnsrecon or use -d
nmap="0" #set to 0 to skip nmap or use -n
n1="0" #set to 0 to skip nmap stage 1 or use -n1
n2="0" #set to 0 to skip nmap stage 2 or use -n2
n3="0" #set to 0 to skip nmap stage 3 or use -n3
n4="0" #set to 0 to skip nmap stage 4 or use -n4
n5="0" #set to 0 to skip nmap stage 5 or use -n5
wp="0"   #set to 0 to skip wpscan or use -wp
wg="0"   #set to 0 to skip wget or use -wg
ssl="0"  #set to 0 to skip sslscan or use -s
url="0"  #set to 0 to skip urlscan or use -u
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
    	    dns=1;
        fi
    	  if [ $i == "-n" ]
    	  then
    	    nmap=1;
    	  fi
    	  if [ $i == "-n1" ]
    	  then
    	    n1=1;
    	  fi
    	  if [ $i == "-n2" ]
    	  then
    	    n2=1;
    	  fi
    	  if [ $i == "-n3" ]
    	  then
    	    n3=1;
    	  fi
    	  if [ $i == "-n4" ]
    	  then
    	    n4=1;
    	  fi
    	  if [ $i == "-n5" ]
    	  then
    	    n5=1;
    	  fi    	      	      	  
    	  if [ $i == "-wp" ]
    	  then
    	    wp=1;
    	  fi
    	  if [ $i == "-wg" ]
    	  then
    	    wg=1;
    	  fi
    	  if [ $i == "-s" ]
    	  then
    	    ssl=1;
    	  fi
    	  if [ $i == "-u" ]
    	  then
    	    url=1;
    	  fi
    	  if [ "-n" != $i ] && [ "-d" != $i ] && [ "-u" != $i ] && [ "-s" != $i ] && [ "-wg" != $i ] && [ "-wp" != $i ] && [ "-n1" != $i ] && [ "-n2" != $i ] && [ "-n3" != $i ] && [ "-n4" != $i ] && [ "-n5" != $i ]
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

dnscmd="sudo dnsrecon -t std,srv,zonewalk,brt -n $ns -D $list -z -f --iw --threads 2 --lifetime 10 --xml $HOME/Scans/dnsrecon-$target.xml -d $target"
nmapcmd="sudo nmap -sSV --script fingerprint-strings,ftp-anon,ftp-syst,http-affiliate-id,http-apache-negotiation,http-apache-server-status,http-bigip-cookie,http-comments-displayer,http-default-accounts,http-enum,http-errors,http-feed,http-generator,http-internal-ip-disclosure,http-passwd,http-robots.txt,https-redirect -T3 -O -A -vv -F -n -oX $HOME/Scans/nmap-$target.xml --stylesheet https://svn.nmap.org/nmap/docs/nmap.xsl -Pn --fuzzy --osscan-guess --reason $target"
nmap1="sudo nmap -Pn --reason -T4 --top-ports 100 -vv -oX $HOME/Scans/nmap1-$target.xml --stylesheet https://svn.nmap.org/nmap/docs/nmap.xsl $target"
nmap2="sudo nmap -Pn --reason -T4 --top-ports 250 -vv -sS -oX $HOME/Scans/nmap2-$target.xml --stylesheet https://svn.nmap.org/nmap/docs/nmap.xsl $target"
nmap3="sudo nmap -Pn --reason -T4 --top-ports 500 -vv -sS -O -oX $HOME/Scans/nmap3-$target.xml --stylesheet https://svn.nmap.org/nmap/docs/nmap.xsl $target"
nmap4="sudo nmap -Pn --reason -T4 --top-ports 750 -vv -sS -O -oX $HOME/Scans/nmap4-$target.xml --script default --stylesheet https://svn.nmap.org/nmap/docs/nmap.xsl $target"
nmap5="sudo nmap -Pn --reason -T4 --top-ports 1000 -vv -sSU -O -oX $HOME/Scans/nmap5-$target.xml --script=discovery,vuln --stylesheet https://svn.nmap.org/nmap/docs/nmap.xsl $target"
sslcmd="sudo sslscan --verbose --no-colour --show-certificate --xml=$HOME/Scans/sslscan-$target.xml $target"
wpcmd="sudo wpscan -e p,t,tt,u1-20 -t 2 -v -f cli-no-color -o $HOME/Scans/wpscan-$target.txt --url $target"
wgetcmd="sudo wget -t 4 --content-on-error https://$target/ -O $HOME/Scans/wget-$target.txt"
urlcmd="sudo urlscan -c -n $HOME/Scans/wget-$target.txt"


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
  if [ $nmap -eq 1 ] || [ "-n1" != $i ] || [ "-n2" != $i ] || [ "-n3" != $i ] || [ "-n4" != $i ] || [ "-n5" != $i ]
  then
    echo -en "[+] Running nmap...\n\n";
		  if [ $n1 -eq 1 ] || [ $nmap -eq 1 ]
		  then
		    nst="1"
		    echo -en "[+] Running nmap stage $nst...\nOutput: $HOME/Scans/nmap$nst-$target.xml\n\n";
		    echo -e  "[+] cmdline: $nmap1\n\n";
		    $nmap1
		    echo -en "[+] nmap stage $nst complete.\n\n";
		  fi
		  if [ $n2 -eq 1 ] || [ $nmap -eq 1 ]
		  then
		    nst="2"
		    echo -en "[+] Running nmap stage $nst...\nOutput: $HOME/Scans/nmap$nst-$target.xml\n\n";
		    echo -e  "[+] cmdline: $nmap2\n\n";
		    $nmap2
		    echo -en "[+] nmap stage $nst complete.\n\n";
		  fi
		  if [ $n3 -eq 1 ] || [ $nmap -eq 1 ]
		  then
		    nst="3"
		    echo -en "[+] Running nmap stage $nst...\nOutput: $HOME/Scans/nmap$nst-$target.xml\n\n";
		    echo -e  "[+] cmdline: $nmap3\n\n";
		    $nmap3
		    echo -en "[+] nmap stage $nst complete.\n\n";
		  fi
		  if [ $n4 -eq 1 ] || [ $nmap -eq 1 ]
		  then
		    nst="4"
		    echo -en "[+] Running nmap stage $nst...\nOutput: $HOME/Scans/nmap$nst-$target.xml\n\n";
		    echo -e  "[+] cmdline: $nmap4\n\n";
		    $nmap4
		    echo -en "[+] nmap stage $nst complete.\n\n";
		  fi
		  if [ $n5 -eq 1 ] || [ $nmap -eq 1 ]
		  then
		    nst="5"
		    echo -en "[+] Running nmap stage $nst...\nOutput: $HOME/Scans/nmap$nst-$target.xml\n\n";
		    echo -e  "[+] cmdline: $nmap5\n\n";
		    $nmap5
		    echo -en "[+] nmap stage $nst complete.\n\n";
		  fi		  		  		  
    #echo -e  "[+] cmdline: $nmapcmd\n\n";
    #$nmapcmd
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
		echo -en "[+] Running wpscan.\nOutput: $HOME/Scans/wpscan-$target.txt\n";
	  echo -e "[+] cmdline: $wpcmd\n\n";
    $wpcmd
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
