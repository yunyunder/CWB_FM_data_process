#!/bin/csh
set prem_list = /home/yin/Data/prem_list

foreach phase( p s )
#foreach phase( p )
    if ($phase == 'p') then
        set comp = Z
    else if ( $phase == 's') then
        set comp = T
    endif

    echo $phase, $comp
    cd $phase

    foreach dir(`cat $prem_list`)
        set sac_dir = $dir

        echo $sac_dir
        cd $sac_dir
        conda activate conda_yin
        aimbat-sac2pkl -s *${comp}.SAC.mark -o sta_t.pkl
        aimbat-ttpick -p $phase -s dist -t -2 10  sta_t.pkl 
#        aimbat-qttpick -p $phase sta_t.pkl
        conda deactivate
        cd ../
    
    end #sac_dir

    cd ../
end  # phase
