#!/bin/bash

# packet list here:
csomagszam_list=("CLFOX169718710******" "CLFOX169718710******" "CLFOX169718710******" "CLFOX169718710******")

for csomagszam in "${csomagszam_list[@]}"
do
    wget https://foxpost.hu/csomagkovetes/?code=$csomagszam
    oldsite=foxpost_old_$csomagszam
    site=foxpost_act_$csomagszam

# if you have old state file...
    if [[ -f $oldsite ]]; then
            # grep to item date line and export to actual state file
        grep -i -A3 "parcel-status-items__list-item-date" *index.html?code=$csomagszam* > $site
        sleep 5
            differences=$(diff -u "$oldsite" "$site")
            sleep 5
        # if no diff, type it in to logs, old state file remove, new to old, send notif to slack webhook
        if [ -z "$differences" ]; then
                sleep 5
            logger foxpost-checker: No changes with this package: $csomagszam
            sleep 5
            rm $oldsite --force
            sleep 5
            mv $site $oldsite
            sleep 5
            # slack webhook notif here: curl -X POST -H 'Content-type: application/json' --data '{"text":"No changes with this foxpost package: https://foxpost.hu/csomagkovetes/?code='$csomagszam'"}' *** webhook here ***
        else
            # else, send update if there are differences
            logger foxpost-checker: New updates, sent via slack webhook. $csomagszam
            sleep 5
            # slack webhook! curl -X POST -H 'Content-type: application/json' --data '{"text":"New changes with the package: https://foxpost.hu/csomagkovetes/?code='$csomagszam'"}' ***webhook here***
        fi

    else
        grep -i -A3 "parcel-status-items__list-item-date" *index.html?code=$csomagszam* > $oldsite
    fi
        sleep 5
    rm *index.html?code=$csomagszam* --force
done
