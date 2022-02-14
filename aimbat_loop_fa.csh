#!/bin/csh
set prem_list = /home/yin/Data/prem_list

foreach phase( p s )
#foreach phase( p )
    echo $phase
    cd $phase

    foreach dir(`cat $prem_list`)
        set sac_dir = $dir

        echo $sac_dir
        cd $sac_dir
        conda activate conda_yin
        aimbat-sac2pkl -s *T.SAC.mark -o sta_t.pkl
        aimbat-ttpick -p $phase sta_t.pkl 
#        aimbat-qttpick -p $phase sta_t.pkl
        conda deactivate
        cd ../
    
    end #sac_dir

    cd ../
end  # phase
