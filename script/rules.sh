#!/bin/bash
#--- VladVons@gmail.com


source $DIR_ADMIN/conf/script/system.sh
source ./const.sh


RulesExecute()
{
  Log "$0->$FUNCNAME"

  #HostVoip=${IntNetBase}.100

  echo
  echo "IntNet: $gIntNet, IntNetBase: $IntNetBase, IntIf: $gIntIf, ExtIf: $gExtIf, VpnIf: $gVpnIf, HostVoip: $HostVoip"

  iptables --append PREROUTING --table nat --protocol tcp --in-interface $gExtIf --dport 10101 --jump DNAT --to ${IntNetBase}.1:$p_ssh
  iptables --append PREROUTING --table nat --protocol tcp --in-interface $gExtIf --dport 10110 --jump DNAT --to ${IntNetBase}.110:$p_rdp

  # Port redirections for VoIP.
  # switch.conf.xml: rtp-start-port, rtp-end-port
  #iptables --append PREROUTING --table nat --protocol tcp --in-interface $gExtIf --match multiport --dport 5060,5080 --jump DNAT --to $HostVoip
  #iptables --append PREROUTING --table nat --protocol udp --in-interface $gExtIf --match multiport --dport 5060,5080,16384:17384 --jump DNAT --to-destination $HostVoip
  #iptables --append FORWARD --protocol udp --match multiport --dport 5060,5080,16384:17384 --destination $HostVoip --jump ACCEPT
  #iptables --append FORWARD --protocol udp --source $HostVoip --jump ACCEPT

  # redirect from external sip.oster.com.ua:8100 to Dinstar web admin
  #iptables -t nat -A PREROUTING  -p tcp -i $gExtIf --dport 5060 -j DNAT --to ${HostVoip}
  #iptables -t nat -A POSTROUTING -p tcp -d ${HostVoip} --dport 5060 -j MASQUERADE
  #iptables -t nat -A PREROUTING  -p udp -i $gExtIf --match multiport --dport 5060,5080,16384:17384 --jump DNAT --to ${HostVoip}
  #iptables -t nat -A POSTROUTING -p udp -d ${HostVoip} --match multiport --dport 5060,5080,16384:17384 -j MASQUERADE


  # Accept packets belonging to established and related connections
  iptables --append INPUT  --match state --state ESTABLISHED,RELATED --jump ACCEPT
  iptables --append OUTPUT --match state --state ESTABLISHED,RELATED --jump ACCEPT

  # allow from internal network to external
  iptables --append FORWARD --in-interface $gIntIf --out-interface $gExtIf --jump ACCEPT

  # allow nat
  iptables --append POSTROUTING --table nat --out-interface $gExtIf --source $gIntNet --jump MASQUERADE

  # Разрешаем ответы из внешней сети
  iptables --append FORWARD --in-interface $gExtIf --match state --state ESTABLISHED,RELATED --jump ACCEPT

  # VPN 
  iptables --append FORWARD --source $gVpnNet --jump ACCEPT
  iptables --append FORWARD --match state --state RELATED,ESTABLISHED,NEW --jump ACCEPT
  iptables --append POSTROUTING --table nat --source $gVpnNet --out-interface $gIntIf --jump MASQUERADE
}
