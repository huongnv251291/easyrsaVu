#!/bin/bash
PATH="$PATH:/usr/bin:/bin"

while getopts "u:" opt; do
  case "$opt" in
  u*) CLIENT="$OPTARG" ;;
  esac
done
if [ -z "$CLIENT" ]; then
  echo ""
  echo "name client can't empty"
  echo ""
  exit
fi
CLIENTEXISTS=$(tail -n +2 /etc/openvpn/easy-rsa/pki/index.txt | grep -c -E "/CN=$CLIENT\$")
if [[ $CLIENTEXISTS != '1' ]]; then
  echo ""
  echo "The specified client CN $CLIENT not found in easy-rsa"
  exit
else
  cd /etc/openvpn/easy-rsa/ || return
fi
./easyrsa --batch revoke "$CLIENT"
EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl
numberInIndex=$(grep -n "/CN=$CLIENT\$" /etc/openvpn/easy-rsa/pki/index.txt)
echo "$numberInIndex"
if [[ $numberInIndex =~ ^[[:digit:]:R] ]]; then
  rm -rf /root/"$CLIENT".ovpn
  rm -rf /etc/openvpn/easy-rsa/pki/reqs/"$CLIENT".req
  rm -rf /etc/openvpn/easy-rsa/pki/private/"$CLIENT".key
  rm -rf /etc/openvpn/easy-rsa/pki/issued/"$CLIENT".crt
  grep -v "/CN=$CLIENT\$" /etc/openvpn/easy-rsa/pki/index.txt >temp && mv temp /etc/openvpn/easy-rsa/pki/index.txt
  rm -rf /etc/openvpn/crl.pem
  cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/crl.pem
  chmod 664 /etc/openvpn/crl.pem
  sed -i "/^$CLIENT,.*/d" /etc/openvpn/ipp.txt
  # Finally, restart and enable OpenVPN
#  if [[ $OS == 'arch' || $OS == 'fedora' || $OS == 'centos' || $OS == 'oracle' ]]; then
#    systemctl stop openvpn-server@server
#    systemctl start openvpn-server@server
#  elif [[ $OS == "ubuntu" ]] && [[ $VERSION_ID == "16.04" ]]; then
#    # On Ubuntu 16.04, we use the package from the OpenVPN repo
#    # This package uses a sysvinit service
#    systemctl stop openvpn
#    systemctl start openvpn
#  else
#    systemctl stop openvpn@server
#    systemctl start openvpn@server
#  fi
  echo "revoke $CLIENT success"
else
  echo "revoke fail check profile name $CLIENT"
  exit
fi
