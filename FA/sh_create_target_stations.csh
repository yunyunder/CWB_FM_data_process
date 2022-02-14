#!/bin/csh

set ccf = 0.5 

set newdir = /home/yin/Data/FA/Target_sta
set prem_list = /home/yin/Data/prem_list
set sta = target_fa_stations.txt

#foreach phase ( p s )
#foreach phase ( p )
#cd $phase

foreach event(`cat $prem_list`)
#set event = 20190312_201915
    mkdir -p $newdir/p/$event
    mkdir -p $newdir/s/$event

    cd  p/$event 
#grep FM 20* | awk '{if($4> ccf) print $7}' ccf=$ccf | xargs cp --target-directory=$newdir/$phase/$event/
#FM.CT09.BHT.SAC.mark
awk '{print "FM."$1".BHZ.SAC.mark" }' ../../$sta | xargs cp --target-directory=$newdir/p/$event

    cd ../../s/$event
awk '{print "FM."$1".BHT.SAC.mark" }' ../../$sta | xargs cp --target-directory=$newdir/s/$event

    cd ../../
end #event

cp aimbat_loop_fa.csh sh_loop_events.csh set_max_amp_fa.csh $newdir
cp plot* $newdir
 
