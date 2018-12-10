#!/usr/bin/bash
lf=known.dat
touch $lf
links=$(cat $1|grep -v "^#")
for i in $links
do
        (
        wget -q $i -O $i
        if [ "$?" != 0 ]
        then 
                echo $i FAIL 1>&2
        else
                if [ "$(grep $i $lf)" == "" ]
                then
                        echo $i INIT
                        md5sum $i >> known.dat
                elif [ "$(grep $(md5sum $i) $lf)" == "" ]
                then
                        echo $i
                        cat $lf |grep -v $i > temp
                        mv temp $lf
                        md5sum $i >> known.dat
                fi
        fi
        if [ -f "$i" ]
        then 
                rm $i
        fi
        ) &
done
