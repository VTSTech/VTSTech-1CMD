<img src="https://i.gyazo.com/f17798fc02b3d14af9a3c60a3a10f7d1.png">

# Program: VTSTech-1CMD.sh
# Version: 0.0.4-r18
# Operating System: Kali Linux
# Description: Bash script to run dnsrecon, nmap, sslscan, wpscan and then wget on index and urlscan on result. Output saved per tool/target.
# Author: Written by Veritas//VTSTech (veritas@vts-tech.org)
# GitHub: https://github.com/Veritas83
# Homepage: www.VTS-Tech.org
# Dependencies: dnsrecon, nmap, sslscan, wpscan, urlscan, wget
# apt-get install dnsrecon nmap wget wpscan sslscan urlscan

VTSTech-1CMD

Expects 1 parameter: domain,subdomain or ip.

specify nameserver on Line 26 (Defaults is 8.8.8.8)

dnsrecon toggle in config on Line 27
