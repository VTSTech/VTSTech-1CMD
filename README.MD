<img src="https://i.gyazo.com/e9fdf08cfe1249bb7ccc6c319552732b.png">
<pre>
# Program: VTSTech-1CMD.sh
# Version: 0.0.4-r25
# Operating System: Kali Linux
# Description: Bash script to run dnsrecon, nmap, sslscan, wpscan and then wget on index and urlscan on result. Output saved per tool/target.
# Author: Written by Veritas//VTSTech (veritas@vts-tech.org)
# GitHub: https://github.com/Veritas83
# Homepage: www.VTS-Tech.org
# Dependencies: dnsrecon, nmap, sslscan, wpscan, urlscan, wget
# apt-get install dnsrecon nmap wget wpscan sslscan urlscan

VTSTech-1CMD
Expects at least 1 parameter: domain,subdomain or ip.

Optional Parameters:

-d Skip dnsrecon
-n Skip nmap
-s Skip sslscan
-wp Skip wpscan
-wg Skip wget
-u Skip urlscan

specify nameserver on Line 25 (Default is 8.8.8.8)

Default toggles for scans in config on Line 26-31
</pre>