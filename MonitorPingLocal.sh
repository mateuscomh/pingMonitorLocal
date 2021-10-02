#!/bin/bash
#============================================================================================
#       ARQUIVO:  PingMonitorLocal.sh
#       DESCRICAO: Monitorar e reportar com a ferramenta de ping os hosts da rede e
#       através da estatíscas informa se houveram ou não perdas
#       SUGESTAO DE APLICABILIDADE: Adicionar script via CRON para melhor monitoramento
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

HOSTS="172.16.102.99" #Inserir listagem de hosts a serem monitorados
LOG="/scripts/Output/monitor.log"
COUNT=8

for i in $HOSTS
do
  count=$(ping -c $COUNT $i | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
  if [ "$count" -eq 0 ]; then
    # 100% falha 
    echo "Host: $i is down (ping failed) em $(date)" >> $LOG
    elif [ "$count" -lt $COUNT ]; then
        # < 100% perda
        echo "Host: $i com $count de perda em $COUNT tentativas $(date)" >> $LOG
    else
        echo "Host: $i ping OK em $(date):" >> $LOG;
    fi
done
