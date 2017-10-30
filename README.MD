<img src="https://i.gyazo.com/56ad18ab862b48b4b400a09804667137.png">

# Program: VTSTech-1CMD.sh
# Version: 0.0.4-r20
# Operating System: Kali Linux
# Description: Bash script to run dnsrecon, nmap, sslscan, wpscan and then wget on index and urlscan on result. Output saved per tool/target.
# Author: Written by Veritas//VTSTech (veritas@vts-tech.org)
# GitHub: https://github.com/Veritas83
# Homepage: www.VTS-Tech.org
# Dependencies: dnsrecon, nmap, sslscan, wpscan, urlscan, wget
# apt-get install dnsrecon nmap wget wpscan sslscan urlscan

VTSTech-1CMD

Expects at lest 1 parameter: domain,subdomain or ip.

Optional Parameters:

-d skip dnsrecon
-n skip nmap

specify nameserver on Line 25 (Default is 8.8.8.8)

nmap & dnsrecon hardcoded toggle in config on Line 26/27 (default is on)
