#!/bin/csh -f 
gmt set MAP_FRAME_TYPE plain
gmt set FORMAT_GEO_MAP .x
gmt set FONT 12p

set xymccc = lon_lat_mccc
set prem_list = /home/yin/Data/prem_list
set CPT = /home/yin/Loop_aimbat/region.cpt
gmt makecpt -Cpolar -D -T-2/2/0.1 > $CPT
set binbar = -Ba1f0.25

foreach dir ( `cat $prem_list` )
    
    set sac_dir = $dir
    echo $sac_dir

    paste p/$sac_dir/$xymccc s/$sac_dir/$xymccc > tmp_ps_delay
    awk '{print $1, $2, $3/$9 }' tmp_ps_delay > tmp_ratio
    #set sta_num = `cat tmp | wc -l`
    #set MCCC_SUM = `awk '{sum += $3} END {print sum}' tmp`
    #echo $sta_num, $MCCC_SUM
    #cat tmp | awk '{print $1, $2, $3-sum/num}' sum=$MCCC_SUM num=$sta_num > tmp_ratio 


    set PS = delay_$dir
    set rangeCS = 121/122.42/24.5/25.5
    set bin = WNes
    set binx = -Bxa1f0.5
    set biny = -Bya0.5f0.2
    set title = deley_p/s_$dir
    #set title = `echo $dir | awk -F'_' '{if($6>0) print "delay_p/s_Radius_"$6"_Depth_"$8"_"$10"/"$12; else print "No_magma"}'`




    gmt begin $PS png
        gmt coast -R$rangeCS -JM3i $binx $biny -B$bin+t$title  -W0.3p
        echo 121.623 25.21 45 10 10   | gmt plot -SE -Gred
        cat tmp_ratio | gmt plot -Sc8p -C$CPT  -W0.3p
        gmt colorbar  -C$CPT $binbar  -DjBC+w6c/0.25c+h
    gmt end

    #eog $PS.png
end

