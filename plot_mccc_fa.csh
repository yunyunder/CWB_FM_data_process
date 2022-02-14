#!/bin/csh -f
#gmt6 
#demean mccc

set prem_list = /home/yin/Data/prem_list 

set xymccc = lon_lat_mccc


set bin = WNes
set CPT   = /home/yin/Loop_aimbat/SAC_S_PHASE/region.cpt
set CPT1  = /home/yin/Loop_aimbat/SAC_S_PHASE/ccf.cpt
set CPT10 = /home/yin/Loop_aimbat/SAC_S_PHASE/ampratio.cpt
set binbar = -Ba0.5f0.25
set binbar1 = -Ba0.5f0.25
set binbar10 = -Ba50f25
gmt makecpt -Cpolar -D -T-1/1/0.05 > $CPT
gmt makecpt -Cgray -D -T0/1/0.05 > $CPT1
gmt makecpt -Cpolar -D -T0.2/1.8/0.05 > $CPT10


foreach phase ( p s )
#foreach phase ( p )
    echo $phase
    cd $phase

    foreach dir (`cat $prem_list` )
        cd $dir
        echo sac_$dir
    
        set title = ${phase}_${dir}    
        #set title = `echo $dir | awk -F'_' '{if($6>0) print "Radius_"$6"_Depth_"$8"_"$10"/"$12; else print "No_magma"}'`
        #set title = no_magma
        echo $title	
        gmt set MAP_FRAME_TYPE plain 
        gmt set FORMAT_GEO_MAP .x
        gmt set FONT 12p

        set sta_all =  sta_info
        saclst KSTNM KNETWK stla stlo f *T.SAC.mark.new > $sta_all
 
        #set axi_path = /home/yin/axisem/SOLVER/${dir}
        #set sta_all = ${axi_path}/STATIONS
        set mccc_file = 20*.mc${phase}
        set sta_num = `cat $sta_all | wc -l`
        #echo $mccc_file, $sta_num
    
        rm -f $xymccc
        #### prepare data for plot ####
        foreach num(`seq 1 $sta_num`)
            #echo $num
            set sta  = `sed -n "${num}p" $sta_all | awk '{print $2}'`
            set net  = `sed -n "${num}p" $sta_all | awk '{print $3}'`
            set slat = `sed -n "${num}p" $sta_all | awk '{print $4}'`
            set slon = `sed -n "${num}p" $sta_all | awk '{print $5}'`
            #echo $sta, $slat, $slon
            set mccc = `grep $net.$sta $mccc_file | awk '{print $9}'`
            set ccf = `grep $net.$sta $mccc_file | awk '{print $4}'`
            #echo $sta, $mccc
            echo $slon $slat $mccc $ccf $sta $net >> $xymccc
        end

        cat  $xymccc > tmp
        #awk '{if ($6 == "YY") print $0 }' $xymccc > tmp
        set sta_num = `cat tmp | wc -l`
        set MCCC_SUM = `awk '{sum += $3} END {print sum}' tmp`
        
        echo $sta_num, $MCCC_SUM
        \rm -f $xymccc
        \cp tmp ${xymccc}_origin
        cat tmp | awk '{print $1, $2, $3-sum/num, $4, $5, $6}' sum=$MCCC_SUM num=$sta_num > $xymccc
    
        set rangeCS = 121/122.42/24.5/25.5
        set binx = -Bxa1f0.5
        set biny = -Bya0.5f0.2
        set PS = mccc_${phase}_${dir}
    
    
        gmt begin $PS png
            ### Fig 1  MCCC map
            gmt coast -R$rangeCS -JM3i $binx $biny -B$bin+t$title  -W0.3p -Y9i 
            echo 121.623 25.21 45 10 10   | gmt plot -SE -Gred  
            #echo 122.2613 25.1883 | gmt plot -Sa8p -Gyellow -W0.3p 
            cat $xymccc | gmt psxy -Sc5p -C$CPT -W0.3p
            #cat $xymccc | awk '{if ($5 =="Y000") print $0 }' | gmt plot -Sa8p -Gyellow -W0.3p
            #cat $xymccc | awk '{if ($6 =="YY") print $0 }' | gmt plot -Sc8p -C$CPT  -W0.3p
            gmt colorbar  -C$CPT $binbar  -DjBC+w6c/0.25c+h 
    
            ### Fig 2 CCF
            gmt coast -R$rangeCS -JM3i $binx $biny -B$bin+t'CCF'  -W0.3p -Y-3i
            cat $xymccc | awk '{print $1, $2, $4}' | gmt psxy -Sc5p -C$CPT1 -W0.3p
            #cat $xymccc | awk '{if ($6 =="YY") print $1,$2,$4 }' | gmt plot -Sc8p -C$CPT1  -W0.3p
            gmt colorbar  -C$CPT1 $binbar1  -DjBC+w6c/0.25c+h
    
            ### Fig 3 AMP ratio 
            #gmt coast -R$rangeCS -JM3i $binx $biny -B$bin+t'Amplitude ratio (magma/without)' -W0.3p -Y-3i
            #paste amp_origin amp_$dir > amp_tmp
            #cat amp_tmp | awk '{print $2, $3, $8/$4}' | gmt psxy -Sc5p -C$CPT10 -W0.3p
            #awk -F'.' '{if ($2=="YY") print $0}' amp_tmp | awk '{print $2, $3, $8/$4}' | gmt psxy -Sc8p -C$CPT10 -W0.3p
            #gmt colorbar  -C$CPT10 $binbar  -DjBC+w6c/0.25c+h  
    
        gmt end
    
        ##eog *png
        cd ../
    
    end #dir


    cd ../

    \cp $phase/*/*png .
end #phase
#eog *.png




