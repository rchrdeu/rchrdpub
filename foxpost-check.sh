#!/bin/bash

# working in actual directory where you download it. I suggest to create a foxpost folder, then this script can work there. 
# packet list here: 
csomagszam_list=("CLFOX169677511361839" "CLFOX169685051885433" "CLFOX169687541879937")

for csomagszam in "${csomagszam_list[@]}"
do
    wget https://foxpost.hu/csomagkovetes/?code=$csomagszam
    oldsite=foxpost_old_$csomagszam
    site=foxpost_act_$csomagszam

# if you have old state file...
    if [[ -f $oldsite ]]; then
            # grep to item date line and export to actual state file
        grep -i -A3 "parcel-status-items__list-item-date" *index.html?code=$csomagszam* > $site
            differences=$(diff -u "$oldsite" "$site")
        # if no diff, type it in to logs, old state file remove, new to old, send notif to slack webhook
        if [ -z "$differences" ]; then
            logger foxpost checker: No changes with this package: $csomagszam
            rm $oldsite
            mv $site $oldsite
             ################## change webhook address!!! #################           
            curl -X POST -H 'Content-type: application/json' --data '{"text":"No changes with this foxpost package: https://foxpost.hu/csomagkovetes/?code='$csomagszam'"}' PUT YOUR SLACK WEBHOOK ADDRESS HERE 
        else
            # else, send update if there are differences
            logger foxpost checker: New updates, sent via slack webhook. $csomagszam
            ################## change webhook address!!! #################
            curl -X POST -H 'Content-type: application/json' --data '{"text":"New changes with the package: https://foxpost.hu/csomagkovetes/?code='$csomagszam'"}' PUT YOUR SLACK WEBHOOK ADDRESS HERE
        fi

    else
        grep -i -A3 "parcel-status-items__list-item-date" *index.html?code=$csomagszam* > $oldsite
    fi

    rm *index.html?code=$csomagszam*
done