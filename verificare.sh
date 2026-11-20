#!/bin/bash
printf "Student: Adrian\n"

verifica_ip() {
    host="$1"
    ip="$2"
    dns_server="$3"

    dns_ip=$(nslookup "$host" "$dns_server" 2>/dev/null | awk '/^Name:/{found=1; next} found && /^Address:/{print $2; exit}')

    if [[ -n "$dns_ip" && "$ip" != "$dns_ip" ]]; then
        echo "Bogus IP for $host in /etc/hosts!"
    fi
}

dns_server="192.168.217.2"

cat /etc/hosts | while read ip host rest
do
    if [[ -z "$ip" || "$ip" == \#* ]]; then
        continue
    fi

    if [[ -z "$host" ]]; then
        continue
    fi

    verifica_ip "$host" "$ip" "$dns_server"
done
