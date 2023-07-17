#!/bin/bash
export USER=khagukhagu2
# 4- Vérifier si une clé SSH est présente sur la VM, sinon en créer une
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
fi

source ~/.ssh/id_rsa.pub
export $(cut -d= -f1 id_rsa.pub)