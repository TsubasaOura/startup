#!/bin/bash
set -e

# check if iptables works (just warns)
set +e
iptables -L 2>/dev/null > /dev/null
if [[ $? -ne 0 ]]
then
  echo '# [!!] This image requires --cap-add NET_ADMIN'
  sleep 7
  # exit -1
fi
set -e

SERVER_CONF=/usr/vpnserver/vpn_server.config
CLIENT_CONF=/usr/vpnclient/vpn_client.config

if [ ! -f $SERVER_CONF ] || [ ! -s $SERVER_CONF ]; then

  /usr/bin/vpnserver start 2>&1 > /dev/null
    # initial setup
    sleep 7
    /server-setup.sh
  /usr/bin/vpnserver stop 2>&1 > /dev/null

  # while-loop to wait until server goes away
  set +e
  while [[ $(pidof vpnserver) ]] > /dev/null; do sleep 1; done
  set -e

  echo \# [initial server setup OK]

else

  echo \# [running with existing server config]

fi
set -e

if [ ! -f $CLIENT_CONF ] || [ ! -s $CLIENT_CONF ]; then

  /usr/bin/vpnclient start 2>&1 > /dev/null
    # initial setup
    sleep 7
    /client-setup.sh
  /usr/bin/vpnclient stop 2>&1 > /dev/null

  # while-loop to wait until server goes away
  set +e
  while [[ $(pidof vpnclient) ]] > /dev/null; do sleep 1; done
  set -e

  echo \# [initial client setup OK]

else

echo \# [running with existing client config]

fi

exec "$@"
