#!/bin/bash

for step in 0.4 0.5 0.6 0.7 0.8 0.9 1 1.25 1.5 2
do
    for file in brain?_0.3.mnc
    do
    echo autocrop -isostep $step $file $(basename $file _0.3.mnc)_$step.mnc
    done
done


for moving in brain2*mnc
do
    for fixed in brain1*mnc
    do
        echo ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=8 /usr/bin/time -v ./mb_register.sh $moving $fixed output
    done
done

for moving in brain1*mnc
do
    for fixed in brain2*mnc
    do
        echo ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=8 /usr/bin/time -v ./mb_register.sh $moving $fixed output
    done
done

