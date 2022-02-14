#!/bin/csh
#set event = 20190312_20
#set origin = PREM_2s_${event}_Y80 
set prem_list = /home/yin/Data/prem_list 

foreach phase ( p s )
#foreach phase ( s )
    echo $phase
    cd $phase
    foreach dir (`cat $prem_list`)
        set sac_dir = $dir
        echo $sac_dir
        cd $sac_dir 
    
        foreach sta_sac (`ls *T.SAC.mark`)
            set tend = `saclst t0 f $sta_sac | awk '{print $2+5 }'`
    
            sac << END
            r  $sta_sac
            mtw 0 $tend
            markptp to t6
            w append .new
            q
END
    
        end  #sta_sac
    
        saclst stlo stla user0 f *T.SAC.mark.new > amp_$dir
    
        cd ../
    end  #dir
    
    #\cp sac_$origin/amp_$origin amp_origin 
    #foreach dir (`cat $prem_list`)
    #    \cp amp_origin sac_$dir
    #end  #dir2

    cd ../
end # phase 
echo 'Finish marking max & min amplitude.'

