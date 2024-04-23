#!/bin/bash
# Program: VTSTech-1CMD.sh
# Version: 0.0.5 Revision 05
# Operating System: Kali Linux
# Description: Bash script to run dnsrecon, nmap, sslscan, wpscan, urlscan in 1 command. Output saved per tool/target.
# Author: Written by Veritas//VTSTech (veritas@vts-tech.org)
# GitHub: https://github.com/VTSTech
# Homepage: www.VTS-Tech.org
# Dependencies: dnsrecon, nmap, sslscan, wpscan, urlscan, wget, amass, proxychains4, tor
# apt-get install dnsrecon nmap wget wpscan sslscan urlscan amass tor proxychains4


v=0.0.5-r05
echo " _    _________________________________  __";
echo "| |  / /_  __/ ___/_  __/ ____/ ____/ / / /";
echo "| | / / / /  \__ \ / / / __/ / /   / /_/ / ";
echo "| |/ / / /  ___/ // / / /___/ /___/ __  /  ";
echo "|___/ /_/  /____//_/ /_____/\____/_/ /_/   ";
echo "                                           ";
echo "VTSTech-1CMD v$v Written by Veritas (veritas@vts-tech.org)"
banner="VTSTech-1CMD v$v\nWritten by Veritas (veritas@vts-tech.org)\n"
banner+="Homepage: www.VTS-Tech.org\nRequires: dnsrecon, nmap, wget, wpscan, sslscan, urlscan\n"
banner+="================================\nUsage: ./VTSTech-1CMD target.com\n\nOptions:\n\n"
banner+="-d Use dnsrecon\n"
banner+="-n Use nmap (all stages)\n"
banner+="-n# Use nmap (stage # 1-5)\n"
banner+="-s Use sslscan\n"
banner+="-wp Use wpscan\n"
banner+="-wg Use wget\n"
banner+="-u Use urlscan\n"
banner+="-a Use amass\n"
banner+="-h Use httpx\n"
banner+="-f Use list of targets\n"
banner+="-tor Use Tor\n\n"
#Config
#Missing required tools? Try this: apt-get install dnsrecon nmap wget wpscan sslscan urlscan
list="/usr/share/dnsrecon/namelist.txt" #You might want to change this
ns="1.1.1.1,8.8.8.8,9.9.9.9" #set nameserver here
#8.8.8.8, 8.8.4.4 (Google DNS)
#208.67.222.222,208.67.220.220 (OpenDNS)
#37.235.1.174,37.235.1.177 (FreeDNS)
#1.1.1.1,1.0.0.1 (CloudFlare)
#9.9.9.9,149.112.112.112 (Quad9)
#94.140.14.14,94.140.15.15 (AdGuard)
dns=0  #set to 0 to skip dnsrecon or use -d
nmap=0 #set to 0 to skip nmap or use -n
n1=0 #set to 0 to skip nmap stage 1 or use -n1
n2=0 #set to 0 to skip nmap stage 2 or use -n2
n3=0 #set to 0 to skip nmap stage 3 or use -n3
n4=0 #set to 0 to skip nmap stage 4 or use -n4
n5=0 #set to 0 to skip nmap stage 5 or use -n5
wp=0   #set to 0 to skip wpscan or use -wp
wg=0   #set to 0 to skip wget or use -wg
ssl=0  #set to 0 to skip sslscan or use -s
url=0  #set to 0 to skip urlscan or use -u
tor=0  #set to 1 to use tor or use -tor
ama=0 #set to 0 to skip amass or use -a
ht=0 #Set to 0 to skip httpx or use -h
ua='Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:125.0) Gecko/20100101 Firefox/125.0'
targets=""
#EndConfig

if [ $# -eq 0 ]; then
  echo -e $banner
  echo "Usage: $0 [-d] [-n] [-n1] [-n2] [-n3] [-n4] [-n5] [-wp] [-wg] [-s] [-u] [-tor] [-a] [-h] [-f targets_file]"
  exit 1
fi

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -d) dns=1 ;;
        -n) nmap=1 ;;
        -n1) n1=1 ;;
        -n2) n2=1 ;;
        -n3) n3=1 ;;
        -n4) n4=1 ;;
        -n5) n5=1 ;;
        -wp) wp=1 ;;
        -wg) wg=1 ;;
        -s) ssl=1 ;;
        -u) url=1 ;;
        -tor) tor=1 ;;
        -a) ama=1 ;;
        -h) ht=1 ;;
        -f) targets="$2"; shift ;;
        *) echo "Invalid option: $1" >&2; exit 1 ;;
    esac
    shift
done
function 3cmd {
#local target=$1
if [ $tor -eq 1 ]
then
	dnscmd="proxychains4 dnsrecon -t std,zonewalk,crt -n $ns -D $list -z -f --iw --threads 2 --lifetime 12 --xml $HOME/Scans/dnsrecon-$target.xml -d $target"
	nmap1="sudo nmap -n --dns-servers=$ns --proxies=http://127.0.0.1:8118/ -Pn --open -T2  --top-ports 25 -vv -sTV -oN $HOME/Scans/nmap1-$target.txt $target"
	nmap2="sudo proxychains4 nmap  -Pn --open -T2 --top-ports 50 -vv -sTV  -oN $HOME/Scans/nmap2-$target.txt $target"
	nmap3="sudo proxychains4 nmap -Pn --open -T2 --top-ports 100 -vv -sTV -O -oN $HOME/Scans/nmap3-$target.txt $target"
	nmap4="sudo proxychains4 nmap -Pn --open -T2 --top-ports 250 -vv -sTV -OA -oN $HOME/Scans/nmap4-$target.txt--script default  $target"
	nmap5="sudo proxychains4 nmap -Pn --open -T2 --top-ports 500 -vv -sTUV -OA -oN $HOME/Scans/nmap5-$target.txt --script=discovery,vuln $target"
	sslcmd="proxychains4 sslscan --verbose --no-colour --show-certificate --xml=$HOME/Scans/sslscan-$target.xml $target"
	wpcmd="wpscan --proxy socks5://127.0.0.1:9050 -e p,t,tt,u1-20 -t 2 -v -f cli-no-color -o $HOME/Scans/wpscan-$target.txt --url $target"
	wgetcmd="proxychains4 wget -t 4 --content-on-error -O $HOME/Scans/wget-$target.txt https://$target/"
	urlcmd="proxychains4 urlscan -c -n $HOME/Scans/wget-$target.txt"
	#urlcmd2="sudo uniq -u $HOME/Scans/urlscan-$target.txt | sudo tee $HOME/Scans/urlscan-$target.txt"
	amacmd="proxychains4 amass enum -d $target -o $HOME/Scans/amass-$target.txt -df /usr/share/dnsrecon/namelist.txt -v -p 80,443 -tr $ns -active --nocolor -norecursive"
	htcmd="httpx https://$target --proxy socks5://127.0.0.1:9050 -h User-Agent $ua --download $HOME/Scans/httpx-$target.txt"
else
	dnscmd="sudo dnsrecon -v -t std,zonewalk,crt -n $ns -D $list -z -f --iw --threads 2 --lifetime 12 --xml $HOME/Scans/dnsrecon-$target.xml -d $target"
	#nmapcmd="sudo nmap -sSV --script fingerprint-strings,ftp-anon,ftp-syst,http-affiliate-id,http-apache-negotiation,http-apache-server-status,http-bigip-cookie,http-comments-displayer,http-default-accounts,http-enum,http-errors,http-feed,http-generator,http-internal-ip-disclosure,http-passwd,http-robots.txt,https-redirect -T2 -O -A -vv -F -n -oN $HOME/Scans/nmap-$target.txt -Pn --fuzzy --osscan-guess --open $target"
	nmap1="sudo nmap -Pn --open -T2 --top-ports 25 -vv -sSV -oN $HOME/Scans/nmap1-$target.txt $target"
	nmap2="sudo nmap -Pn --open -T2 --top-ports 50 -vv -sSV-oN $HOME/Scans/nmap2-$target.txt $target"
	nmap3="sudo nmap -Pn --open -T2 --top-ports 100 -vv -sSV -O -oN $HOME/Scans/nmap3-$target.txt $target"
	nmap4="sudo nmap -Pn --open -T2 --top-ports 250 -vv -sSV -O -oN $HOME/Scans/nmap4-$target.xml --script default $target"
	nmap5="sudo nmap -Pn --open -T2 --top-ports 500 -vv -sSUV -O -oN $HOME/Scans/nmap5-$target.xml --script=discovery,vuln $target"
	sslcmd="sudo sslscan --verbose --no-colour --show-certificate --xml=$HOME/Scans/sslscan-$target.xml $target"
	wpcmd="sudo wpscan -e p,t,tt,u1-20 -t 2 -v -f cli-no-color -o $HOME/Scans/wpscan-$target.txt --url $target"
	wgetcmd="sudo wget -t 4 --content-on-error https://$target/ -O $HOME/Scans/wget-$target.txt"
	urlcmd="sudo urlscan -c -n $HOME/Scans/wget-$target.txt"
	#urlcmd2="sudo uniq -u $HOME/Scans/urlscan-$target.txt | tee $HOME/Scans/urlscan-$target.txt"
	amacmd="sudo  amass enum -d $target -o $HOME/Scans/amass-$target.txt -df /usr/share/dnsrecon/namelist.txt -v -p 80,443 -tr $ns -active --nocolor -norecursive"
	htcmd="httpx https://$target -h User-Agent $ua --download $HOME/Scans/httpx-$target.txt"
fi
}

function 2cmd {
    #local target=$1
    echo -e "\n\n[*] Processing target: $target\n" 
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
	  echo "Debug $n1"
	  if [ $nmap -eq 1 ] || [ $n1 -eq 1 ] || [ $n2 -eq 1 ] || [ $n3 -eq 1 ] || [ $n4 -eq 1 ] || [ $n5 -eq 1 ]; then
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
	  if [ $ama -eq 1 ]
	  then
		echo -en "[+] Running amass. Output: $HOME/Scans/amass-$target.txt\n\n";
	  echo -e "[+] cmdline: $amacmd\n\n";
	  $amacmd
	  echo -e "[+] amass complete.\n\n";
		fi
	  if [ $ama -eq 0 ]
	  then
	    echo -en "[-] Skipping amass.\n\n";
	  fi
	  if [ $ht -eq 1 ]
	  then
		echo -en "[+] Running httpx. Output: $HOME/Scans/httpx-$target.txt\n\n";
	  echo -e "[+] cmdline: $htcmd\n\n";
	  $htcmd
	  echo -e "[+] httpx complete.\n\n";
		fi
	  if [ $ht -eq 0 ]
	  then
	    echo -en "[-] Skipping httpx.\n\n";
	  fi  
}

mkdir -p "$HOME/Scans"

if [ -n "$targets" ]; then
  echo "Debug: Targets file set to $targets"
  if [ -f "$targets" ]; then
    while IFS= read -r target; do
      3cmd "$target"
      2cmd "$target"
    done < "$targets"
  else
    echo "Error: Targets file '$targets' not found."
  fi
else
  echo "Error: No targets file specified using -f option."
fi

echo -e "\n\n[*] All Operations completed!\n"
