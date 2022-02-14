#!/bin/csh

set ccf = 0.5 

set newdir = /home/yin/Data/FA/Great_ccf
set prem_list = /home/yin/Data/prem_list


foreach phase ( p s )
#foreach phase ( p )
    cd $phase

    foreach event(`cat $prem_list`)
    #set event = 20190312_201915
        mkdir -p $newdir/$phase/$event
        #head -n1 $event/20*$phase  
        cd  $event 
grep FM 20* | awk '{if($4> ccf) print $7}' ccf=$ccf | xargs cp --target-directory=$newdir/$phase/$event/
    


        cd ../
    end #event

    cd ../
end #phase


cp aimbat_loop_fa.csh set_max_amp_fa.csh $newdir
cp plot* $newdir
 
