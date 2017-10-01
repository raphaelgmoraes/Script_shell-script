#!/bin/bash
#

data=$(date +%d-%m-%Y)
dia="`date +%d-%m-%Y`"
hora=$(date +"%H:%M:%S")

Name_log="backup-mikrotik"
Dir_log="/home/zabbix/logs/mikrotik/"
Log=""$Dir_log$Name_log-$data.txt""

#Dir_bkp=/home/zabbix/backup-mikrotik/backups/dispositivos/mikrotik/"$data

echo "###############################################################################$" >> $Log
echo "#                     Script de Backup Mikrotik                                $" >> $Log
echo "#                                                                              $" >> $Log
echo "#            Empresa: RJP Consultoria Redes & Telecom                          $" >> $Log
echo "#            Script by: Raphael Gomes Moraes                                   $" >> $Log
echo "#            Email: raphael2k2moraes@gmail.com                                 $" >> $Log
echo "#            GitHub: https://github.com/raphaelgmoraes                         $" >> $Log
echo "#            Data criacao: 20 de Marco 2016 Versao: 1.0.0                      $" >> $Log
echo "#            Atualizacao: 23 de Abril 01,02 e 03 de Maio 2016                  $" >> $Log
echo "#            Melhoria no Log, Script mais didatico, IPs no Host.list           $" >> $Log
echo "#            Data criacao: 20 de Marco 2016 Versao: 1.0.1                      $" >> $Log
echo "#            Atualizacao: 13 de Janeiro 2017                                   $" >> $Log
echo "#            Adicionado o Dropbox como backup meio de backup e exportacao      $" >> $Log
echo "#            Atualizacao: 01 de Outubro 2017                                   $" >> $Log
echo "#            Adicionado o script no GitHub!                                    $" >> $Log
echo "#            Mantenham os credito por gentileza e contriuem para melhora-lo    $" >> $Log
echo "#            Assim outros como você seram beneficiados. Viva Open Source!!!    $" >> $Log
echo "#                                                                              $" >> $Log
echo "#                                                                              $" >> $Log
echo "###############################################################################$\n" >> $Log

sleep 2
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $Log
echo "Criando diretorio backups caso nao exista."  >> $Log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n" >> $Log

#mkdir -p /tmp/mikrotik/$data
mkdir -p /home/zabbix/backups/mikrotik/  >> $Log
mkdir -p /home/zabbix/backups/mikrotik/$data  >> $Log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $Log
echo "Dando permissao para usuario nao root manipular os arquivos."  >> $Log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n" >> $Log
sleep 4
chmod 777 /home/zabbix/backups/mikrotik/*
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $Log
echo "Acessando as RBs autenticadas e salvando os backups." >> $Log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n" >> $Log
for i in $(cat /home/zabbix/host-list/host.mikrotik.list) ; do  >> $Log
ssh backup@$i /system backup save name=$i.$data.backup  >> $Log
done >> $Log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $Log
echo "Acessando as RBs autenticadas e realizando o backup."  >> $Log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n" >> $Log
for i in $(cat /home/zabbix/host-list/host.mikrotik.list) ; do  >> $Log
sftp backup@$i:$i.$data.backup  >> $Log
done >> $Log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $Log
echo "Finalizado backups das RB's com os IP's configurados na host.mikrotik.list." >> $Log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n" >> $Log
sleep 2
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $Log
echo "Movendo backups realizados para o diretorio:\n"$Dir_bkp"" >> $Log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n" >> $Log
mv *.backup /home/zabbix/backups/mikrotik/$data/
sleep 2
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $Log
echo "Backups salvos no diretorio configurado com sucesso." >> $Log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n" >> $Log
sleep 2
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $Log
echo "compactando(zipando) os arquivos de backupeados." >> $Log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n" >> $Log
cd /home/zabbix/backups/mikrotik/
tar -cvzf backup-mikrotiks-$dia.tgz $data
arq_tgz="`find /home/zabbix/backups/mikrotik/ -mtime -1 -name '*.tgz'`"

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $Log
echo "Arquivos compactados com sucesso." >> $Log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n" >> $Log
sleep 2

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $Log
echo "Enviando E-mail do Backup." >> $Log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n" >> $Log

#=====================================================================================================================================================================
# Desativado E-mail pelo Sendmail, caso haja uma solução habilite-o e contribuem
#EMAIL_FROM="seu e-mail@email.com
#EMAIL_TO="paraquem@e-mail.com
#EMAIL_TO="paraquem2@e-mail.com
#SERVIDOR_SMTP="smtp.gmail.com
#SENHA='sua senha
#ASSUNTO=Backup Mikrotik - $dia as $hora"
#ANEXO=$arq_tgz"
#ANEXO2=$Dir_log$Name_log-$data.txt"

#/usr/bin/sendEmail -o tls=no -f $EMAIL_FROM -t $EMAIL_TO $EMAIL_TO2-cc -u $ASSUNTO" -o message-file=/home/zabbix/backup-mikrotik/body_email -a $ANEXO $ANEXO2 -s $SERVIDOR_SMTP:587 -xu $EMAIL_FROM -xp $SENHA >> $Log
#=====================================================================================================================================================================

# Comando para enviar o Backup para o DropBox
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $Log
echo "Realizando Upload do Backup para o Dropbox." >> $Log
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n" >> $Log
sleep 2
cd /home/zabbix/script >> $Log
./dropbox_uploader.sh upload ../backups/mikrotik/backup-mikrotiks-$dia.tgz / >> $Log
sleep 1
echo "++++++++++++++++++++++++++++++++++++++++++++++" >> $Log
echo "Backup Enviado para o Dropbox com sucesso!!!." >> $Log
echo "++++++++++++++++++++++++++++++++++++++++++++++\n" >> $Log
sleep 2
echo "+++++++++++++++++++++++++++++++++++++++++++++++++" >> $Log
echo "Listando a pasta de backup com o arquivo dentro." >> $Log
echo "+++++++++++++++++++++++++++++++++++++++++++++++++\n" >> $Log
sleep 2
echo "===========================================================================================================" >> $Log
./dropbox_uploader.sh list >> $Log
sleep 2
echo "===========================================================================================================" >> $Log
./dropbox_uploader.sh list >> $Log
echo "===========================================================================================================" >> $Log
echo "" >> $Log
sleep 2
echo "===========================================================================================================" >> $Log
echo "Script desenvolvido por Raphael Moraes Dono -  Empresa - RjP Consultoria em Redes & Telecom" >> $Log
echo "===========================================================================================================" >> $Log
echo "" >> $Log
sleep 2
echo "===========================================================================================================" >> $Log
echo "" >> $Log
sleep 2
echo "===========================================================================================================" >> $Log
echo "Realizando Upload do Log para Análise dos processos para o Dropbox, verifiquem os Logs para maiores informações." >> $Log
echo "===========================================================================================================" >> $Log
sleep 2
./dropbox_uploader.sh upload ../logs/mikrotik/$Name_log-$data.txt / >> $Log
echo "Processo Finalizado!" >>
