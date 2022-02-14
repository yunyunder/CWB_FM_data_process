#!/bin/csh

set prem_list = /home/yin/Data/prem_list
set ALL = ALL

rm -r -f $ALL
mkdir $ALL
cp aimbat_loop_fa.csh plot_mccc_fa.csh set_max_amp_fa.csh $ALL


foreach phase ( p s )
    mkdir $ALL/$phase

    foreach dir ( `cat $prem_list`)
        mkdir $ALL/$phase/$dir

        foreach network ( FA CWB_BATS )
            cp $network/$phase/$dir/* $ALL/$phase/$dir 
    


        end #network

    end #dir

end #phase
