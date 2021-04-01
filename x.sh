#! /usr/bin /env bash

# colors #
RESTORE='\033[0m'
CYAN='\033[00;36m'
WHITE='\033[01;37m'

script_name=$(basename "${0}")
script_version="1.0.0"
script_name=$(basename "${0}")
script_version="1.0.0"

#check if whois or jwhois is installed
if hash whois &> /dev/null; then
    echo "whois is installed"
elif hash jwhois &> /dev/null; then
    echo "jwhois is installed"
else
    echo -e "${CYAN}[ Info ] -> ${WHITE}Nu am gasit addons instalate, incepem instalarea!"${RESTORE}
    sudo apt install whois jwhois -y
    sudo yum install whois jwhois -y
    # no sudo #
    apt install whois jwhois -y
    yum install whois jwhois -y
    clear
    echo -e "${CYAN}[ Info ] -> ${WHITE}Am terminat instalarea!"${RESTORE}
fi

ans_file="asn.txt"
echo -e "${CYAN}[ Ranger ] -> ${WHITE}Pregatim resursele!"${RESTORE}
if [ -f "$file" ] 
    then
        echo -e "${CYAN}[ Info ] -> ${WHITE}Am gasit fisierul cu clase de tip ASN!"${RESTORE}
    else
        echo -e "${CYAN}[ Info ] -> ${WHITE}Nu am gasit fisierul cu clase de tip ASN, nano asn.txt si adauga clasele!"${RESTORE}
fi

# aici se intampla magia #
while read asn; do
	whois -h whois.radb.net -- "-i origin ${1:-$asn}" | grep -Eo "([0-9.]+){4}/[0-9]+" >> ranges.lst
	echo -e "[ Ranger ] -> ASN:${WHITE}$asn - L-am adaugat in lista!"${RESTORE}
done < asn.txt

# finish #
echo -e ""
echo -e "${CYAN}[ Ranger ] -> ${WHITE}Am terminat, wc -l asn.txt pentru a vedea cate linii!"${RESTORE}
./masscan -iL ranges.lst -p$1 --rate 1000000000 --output-format list --output-filename bios.txt
rm -rf vuln.txt
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" bios.txt >> vuln.txt
 echo -e "${CYAN}[ Info ] -> ${WHITE}Vuln salvat in vuln.txt!"${RESTORE}
