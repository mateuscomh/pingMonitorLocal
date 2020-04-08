#!/bin/bash
#============================================================================================
#       ARQUIVO:  PingMonitorLocal.sh
#       DESCRICAO: Monitorar e reportar com a ferramenta de ping os hosts da rede e
#       através da estatíscas informa se houveram ou não perdas
#       REQUISITOS: 
#       - Host com conexão a internet
#       - Avaliar a possibidade de incluir os logs dentro de um rotate
#       * HOMOLOGADO:  Em distribuições CentOS 6.x 
#       VERSAO:  0.2
#       CRIADO:  02/03/2020
#       AUTOR: Matheus Martins
#       REVISAO:  ---
#       CHANGELOG:
#       02/03/2020 10:00 
#       - Criação de script de acordo com demanda
#       03/03/2020 10:00
#       - Adicionado caminho de log e implementado em produção
#=============================================================================================

HOSTS="192.168.0.1 192.168.0.146" #Inserir listagem de hosts a serem monitorados
LOG="/var/log/CUSTOM/pingmonitor.log"
COUNT=8

for i in $HOSTS
do
  count=$(ping -c $COUNT $i | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
  if [ $count -eq 0 ]; then
    # 100% falha 
    echo "Host: $i is down (ping failed) em $(date)" >> $LOG
    else if [ $count -lt $COUNT ]; then
        # < 100% perda
        echo "Host: $i com $count de perda em $COUNT tentativas $(date)" >> $LOG
    else
        echo "Host: $i ping OK em $(date):" >> $LOG;
    fi
  fi
done
