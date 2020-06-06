#!/bin/bash

WELCOME="The playlist will be generated with the same name of the currently dir.\nUsage: ./gen-playlist.sh path/to/playlistdir path/to/core"

#Verifica se o primeiro e segundo argumentos sao vazios. -e interpreta \n
if [ "$1" == "" ] || [ "$2" == "" ]; then
echo -e $WELCOME
exit 1
fi



COUNTER=0

#Precisa das aspas se nao ele nao pega o path qndo tem espaços
ROMLIST=("$PWD"/*)
PLAYLISTNAME=$(basename $PWD)
PLAYLISTPATH=($(realpath $1)/"$PLAYLISTNAME".lpl)
PATHTOCORE=$(realpath $2)

#Verifica se playlist existe, se existir apaga
if [ -f $PLAYLISTPATH ];then
rm $PLAYLISTPATH
echo Existent playlist removed.
fi

#LOOP PARA CRIAR AS ENTRADAS NO ARQUIVO
for i in "${ROMLIST[@]}"; do
if [[ "${i}" =~ .zip ]]; then
echo "${i}" >> "$PLAYLISTPATH"
ROMNAME=$(basename "${i}")
echo ${ROMNAME%.*} >> "$PLAYLISTPATH"
echo $PATHTOCORE >> "$PLAYLISTPATH"
echo DETECT >> "$PLAYLISTPATH"
echo DETECT >> "$PLAYLISTPATH"
echo "$PLAYLISTNAME".lpl >> "$PLAYLISTPATH"
COUNTER=$(( $COUNTER + 1 ))
fi 
done
echo "$COUNTER roms (.zip) found."
