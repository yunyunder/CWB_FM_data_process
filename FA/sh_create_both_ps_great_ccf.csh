#!/bin/csh

set ccf = 0.5 

set newdir = /home/yin/Data/FA/Both_Great_ccf
set prem_list = /home/yin/Data/prem_list


#foreach phase ( p s )
#foreach phase ( p )
#cd $phase

foreach event(`cat $prem_list`)
#set event = 20190312_201915
    mkdir -p $newdir/p/$event
    mkdir -p $newdir/s/$event
    paste p/$event/20* s/$event/20* > tmp
    grep FM tmp | awk '{if ($4>0.5 && $13>0.5) print $7}' > tmp_move_sac_z
    grep FM tmp | awk '{if ($4>0.5 && $13>0.5) print $16}' > tmp_move_sac_t

    cd  p/$event 
#grep FM 20* | awk '{if($4> ccf) print $7}' ccf=$ccf | xargs cp --target-directory=$newdir/$phase/$event/
cat ../../tmp_move_sac_z | xargs cp --target-directory=$newdir/p/$event

#cd s/$event
    cd ../../s/$event
cat ../../tmp_move_sac_t | xargs cp --target-directory=$newdir/s/$event        


    cd ../../
end #event

#cp aimbat_loop_fa.csh set_max_amp_fa.csh $newdir
#cp plot* $newdir
 
