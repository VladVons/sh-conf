#!/bin/bash
#--- VladVons@gmail.com


source $DIR_ADMIN/conf/script/system.sh

#IntNetBase=$(echo $gIntNet | sed -r 's|.0/24||gI')
#echo "IntNet: $gIntNet, IntNetBase: $IntNetBase, IntIf: $gIntIf, ExtIf: $gExtIf, VpnIf: $gVpnIf"


RulesExecute()
# http://crm.vpscheap.net/knowledgebase.php?action=displayarticle&id=29
# http://ubuntuforums.org/showthread.php?t=159661
#
# cPort scanner
# http://www.ipfingerprints.com/cPortscan.php 
{
  Log "$0->$FUNCNAME"

  p_rdp=3389
  p_squid=3128
  p_ssh=22
  p_vnc=5900

  IntNetBase=$(echo $gIntNet | sed -r 's|.0/24||gI')

  echo
  echo "IntNet: $gIntNet, IntNetBase: $IntNetBase, IntIf: $gIntIf, ExtIf: $gExtIf, VpnIf: $gVpnIf"

  ## redirect from external sip.oster.com.ua:8100 to Dinstar web admin
  #iptables -t nat -A PREROUTING -i $gExtIf -p tcp --dport $ExtPort80 -j DNAT --to ${HostVoip}:$p_www
  ##iptables -t nat -A PREROUTING -p tcp --dport $ExtPort80 -j DNAT --to ${HostVoip}:$p_www
  #iptables -t nat -A POSTROUTING -p tcp -d ${HostVoip} --dport $p_www -j MASQUERADE

  # ???
  #cPortsExtInTcp="domain,auth,http,https,ftp,ftp-data"
  #cPortsExtInUdp="domain,http,https"
  #iptables --append INPUT --protocol tcp -m tcp -m multicPort ! --dports $cPortsExtInTcp --jump DROP
  #iptables --append INPUT --protocol udp -m udp -m multicPort ! --dports $cPortsExtInUdp --jump DROP


  # SSH guard cPkgName
  #iptables  -N sshguard
  #ip6tables -N sshguard
  #iptables  -A INPUT --in-interface $gExtIf -j sshguard
  #ip6tables -A INPUT --in-interface $gExtIf -j sshguard

  # SSH brut force protection
  #iptables -A INPUT -p tcp -m tcp --dport 22 -m state --state NEW -m hashlimit --hashlimit 1/hour --hashlimit-burst 2 --hashlimit-mode srcip --hashlimit-name SSH --hashlimit-htable-expire 60000 -j ACCEPT 
  #iptables -A INPUT -p tcp -m tcp --dport 22 --tcp-flags SYN,RST,ACK SYN -j DROP 
  #iptables -A RH-Firewall-1-INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT 
 

  # allow tcp
  #iptables --append INPUT --protocol tcp --dport 1024:65535 --jump ACCEPT
  #iptables --append INPUT --protocol tcp --dport ssh      --jump ACCEPT
  #iptables --append INPUT --protocol tcp --dport domain   --jump ACCEPT
  #iptables --append INPUT --protocol tcp --dport http     --jump ACCEPT
  #iptables --append INPUT --protocol tcp --dport https    --jump ACCEPT
  #iptables --append INPUT --protocol tcp --dport auth     --jump ACCEPT
  #iptables --append INPUT --protocol tcp --dport openvpn  --jump ACCEPT
  #iptables --append INPUT --protocol tcp --dport $p_rdp   --jump ACCEPT
  #iptables --append INPUT --protocol tcp --dport $p_vnc   --jump ACCEPT
  # allow udp DNS
  #iptables --append INPUT --protocol udp -m udp --dport domain  -j ACCEPT
  #iptables --append INPUT --protocol udp -m udp --dport openvpn -j ACCEPT


  # FTP
  #iptables -A INPUT  -p tcp --dport ftp -m state --state NEW,ESTABLISHED -j ACCEPT
  #iptables -A OUTPUT -p tcp --sport ftp -m state --state ESTABLISHED -j ACCEPT
  #iptables -A INPUT  -p tcp --dport ftp-data -m state --state ESTABLISHED,RELATED -j ACCEPT
  #iptables -A OUTPUT -p tcp --sport ftp-data -m state --state ESTABLISHED -j ACCEPT


  # close external Port if not set "iptables -P INPUT DROP"
  iptables --append INPUT --in-interface $gExtIf --protocol tcp --dport smtp       --jump DROP
  iptables --append INPUT --in-interface $gExtIf --protocol tcp --dport telnet       --jump DROP
  iptables --append INPUT --in-interface $gExtIf --protocol tcp --dport mysql        --jump DROP
  #iptables --append INPUT --in-interface $gExtIf --protocol tcp --dport postgresql   --jump DROP
  #iptables --append INPUT --in-interface $gExtIf --protocol tcp --dport netbios-ssn  --jump DROP
  #iptables --append INPUT --in-interface $gExtIf --protocol udp --dport netbios-ns   --jump DROP
  #iptables --append INPUT --in-interface $gExtIf --protocol udp --dport netbios-dgm  --jump DROP
  #iptables --append INPUT --in-interface $gExtIf --protocol tcp --dport microsoft-ds --jump DROP
  #iptables --append INPUT --in-interface $gExtIf --protocol tcp --dport sip          --jump DROP
  #iptables --append INPUT --in-interface $gExtIf --protocol udp --dport sip          --jump DROP
  #iptables --append INPUT --in-interface $gExtIf --protocol tcp --dport sip-tls      --jump DROP
  #iptables --append INPUT --in-interface $gExtIf --protocol udp --dport sip-tls      --jump DROP


  # cPort redirections for tech purposes
  #iptables --table nat --append PREROUTING --protocol tcp --in-interface $gExtIf --dport 10031 --jump DNAT --to ${IntNetBase}.131:$p_ssh
  #iptables --table nat --append PREROUTING --protocol tcp --in-interface $gExtIf --dport 10032 --jump DNAT --to ${IntNetBase}.132:$p_rdp
  #iptables --table nat --append PREROUTING --protocol tcp --in-interface $gExtIf --dport 10033 --jump DNAT --to ${IntNetBase}.3:$p_rdp


  # cPort redirections for VM. See /admin/conf/pkg/cService/bind9/in/host.conf, ip_rev.conf
  #iptables --table nat --append PREROUTING --protocol tcp --in-interface $gExtIf --dport 10000 --jump DNAT --to ${IntNetBase}.200:$p_rdp
  #iptables --table nat --append PREROUTING --protocol tcp --in-interface $gExtIf --dport 10001 --jump DNAT --to ${IntNetBase}.201:$p_rdp
  #iptables --table nat --append PREROUTING --protocol tcp --in-interface $gExtIf --dport 10002 --jump DNAT --to ${IntNetBase}.202:$p_rdp
  #iptables --table nat --append PREROUTING --protocol tcp --in-interface $gExtIf --dport 10010 --jump DNAT --to ${IntNetBase}.210:$p_ssh
  iptables --table nat --append PREROUTING --protocol tcp --in-interface $gExtIf --dport 10101 --jump DNAT --to ${IntNetBase}.101:$p_ssh

  # cPort redirections for VoIP
  iptables --table nat --append PREROUTING --protocol tcp --in-interface $gExtIf --dport sip --jump DNAT --to ${IntNetBase}.101
  #iptables --table nat --append PREROUTING --protocol udp --in-interface $gExtIf --dport sip --jump DNAT --to ${IntNetBase}.101
  iptables -t nat -A PREROUTING -p udp -m multiport --dport 5060,16384:16484 -j DNAT --to-destination ${IntNetBase}.101
  iptables -A FORWARD -p udp -m multiport --dport 5060,16384:16484 -d ${IntNetBase}.101 -j ACCEPT
  iptables -A FORWARD -p udp -s ${IntNetBase}.101 -j ACCEPT

  # allow localhost 
  iptables --append INPUT  --in-interface  lo --jump ACCEPT
  iptables --append OUTPUT --out-interface lo --jump ACCEPT


  # allow ping
  iptables --append INPUT --protocol icmp --icmp-type echo-request --jump ACCEPT


  # Accept packets belonging to established and related connections
  iptables --append INPUT  --match state --state ESTABLISHED,RELATED --jump ACCEPT
  iptables --append OUTPUT --match state --state ESTABLISHED,RELATED --jump ACCEPT


  # allow from internal network to external
  iptables --append FORWARD --in-interface $gIntIf --out-interface $gExtIf --jump ACCEPT


  # allow nat
  iptables --table nat --append POSTROUTING --out-interface $gExtIf -s $gIntNet --jump MASQUERADE


  # Разрешаем ответы из внешней сети
  iptables --append FORWARD --in-interface $gExtIf --match state --state ESTABLISHED,RELATED --jump ACCEPT


  # Запрещаем доступ снаружи во внутреннюю сеть (Note cPort redirection on VM) 
  #iptables --append FORWARD --in-interface $gExtIf --out-interface $gIntIf -j REJECT


  # allow on internal net (squid)
  iptables -A INPUT -s $gIntNet -j ACCEPT
  #iptables --append INPUT --protocol tcp --dport $p_squid --jump ACCEPT


  # redirect http traffic to proxy (Squid)
  #iptables --table nat --append PREROUTING -s $gIntNet --protocol tcp --dport http --jump REDIRECT --to-cPort $p_squid


  # VPN 
  iptables -A FORWARD -s $gVpnNet -j ACCEPT
  iptables -A FORWARD  -m state --state RELATED,ESTABLISHED,NEW -j ACCEPT
  iptables -t nat -A POSTROUTING -s $gVpnNet -o $gIntIf -j MASQUERADE


  # Close all input
  #iptables -P INPUT   DROP
  #iptables -P OUTPUT  ACCEPT
  #iptables -P FORWARD DROP # blocks VPN
  #iptables -P FORWARD ACCEPT

  #iptables-save > /etc/iptables/rules.v4-test
}
