#!/bin/csh -f
gmt set MAP_FRAME_TYPE plain
gmt set FORMAT_GEO_MAP .x
gmt set FONT 12p

foreach dir(`cat /home/yin/Data/prem_list`)
#set dir = 20190312_201915
    set PS = fig_${dir}_allfa_p_s_map
    set event = `echo $dir | cut -c 1-11`
    set cmt = /home/yin/Global/Hetero_lite_package/CMT/$event
    set elon = `grep longitude $cmt | awk '{print $2}' `
    set elat = `grep latitude $cmt | awk '{print $2}' `
    set range = 121/122.5/24.5/25.6
    set mag_rad = 10
    set CPT = delaytime.cpt
    set CPT10 = amp.cpt
    set fault = /home/yin/plot_gmt/plot_poster/fault_one.txt
    #set slab = slab_profile.txt
    
    gmt makecpt -Cpolar -D -T-1/1/0.05 > $CPT
    gmt makecpt -Chot -D -T0/1/0.1 > $CPT10
    #sed -n '1,52p' faults_Shyu_2015_TAO.txt > fault_one.txt
    
    gmt begin $PS png
        # p
        gmt grdimage /home/yin/plot_gmt/plot_poster/Taidp200m.grd -R$range -JM3i  -Cpolar  \
         -E300 -M -I -t50 

    
        gmt coast -Bxa1f0.5 -Bya0.5f0.25 -BWNrb+t"@~D@~t@-p@- of $event" -W0.3p
        #gmt coast  -W0.3p -Bxa1f0.5 -Bya0.5f0.2 -BWNrb+t'P delay time of 20190312'
        cat $fault | gmt plot -A 
    
        #    echo 121.623 25.21 0 360 | gmt plot -SW$mag_rad -Gred  -Bxa1f0.5 -Bya0.5f0.2\
        #    -BWNrb+t'P delay time of 20190312'
        #    gmt plot -Sf-$mark/0.1i+l+f -W << EOF
        #$elon $elat
        #121.2720 25.2775
        #EOF
    
        cat p/$dir/lon_lat_mccc | gmt psxy -Sc5p -C$CPT -W0.3p 
        #echo $elon $elat $event | gmt text -F+f8p+jML -D1.5/-0.4+v 
        echo $elon $elat | gmt plot -Sa11p  -Gyellow -W0.3p
        #echo 122.48 25.5 '  P delay of 20190312 ' | gmt text -F+f9p+jBR -C -Gwhite -W0.3p
        
        #### s
        gmt grdimage /home/yin/plot_gmt/plot_poster/Taidp200m.grd -R$range -JM3i  -Cpolar  \
        -X3.6i -E300 -M -I -t50
        gmt coast -W0.3p -Bxa1f0.5 -Bya0.5f0.25 -BWNrb+t"@~D@~t@-s@- of $event" 
        cat $fault | gmt plot -A
        cat s/$dir/lon_lat_mccc | gmt psxy -Sc5p -C$CPT -W0.3p
    
        #echo $elon $elat $event | gmt text -F+f8p+jML -D1.5/-0.4+v
        echo $elon $elat | gmt plot -Sa11p  -Gyellow -W0.3p
    
        gmt colorbar -C$CPT -Ba0.5f0.1+l'Delay time (s)' -DjBR+w3c/0.2c+o-0.7/0c+v

        ## tp in xy-plot
        set pfile = tmp_p
        set sfile = tmp_s
        paste p/$dir/sta_info  p/$dir/lon_lat_mccc > $pfile
        paste s/$dir/sta_info s/$dir/lon_lat_mccc > $sfile
        set xmin = `sort -k6 -n $pfile | head -n1 | awk '{print $6}'`
        set xmax = `sort -k6 -n $pfile | tail -n1 | awk '{print $6}'`
        set y = 2
        echo $xmin, $xmax
        set rang = -R$xmin/$xmax/-$y/$y
        set proj = -JX3i/1.3i
        set bin = -BWSrt
        set binx = -Bxa20f10
        set biny = -Bya1f0.5
        set fault_dist = /home/yin/Data/FA/dist_km_eq_shanchiao
        set fmin = `grep $dir $fault_dist | awk '{print $2}'`
        set fmax = `grep $dir $fault_dist | awk '{print $3}'`
        echo 'fault dist = ', $fmin, $fmax

        cat << EOF > tmp_frange 
$fmin -$y 
$fmin $y
$fmax $y
$fmax -$y
$fmin -$y
EOF

        gmt basemap $rang $proj $bin+t'@~D@~t@-p@-' $binx $biny+l'Delay time (s)' -X-3.6i -Y-1.8i
        gmt plot tmp_frange -L -Ggray -W0.3p,- 
        awk '{if ($2==$11) print $6, $9}' $pfile | gmt plot -Sc5p 
        awk '{if ($2==$11 && $4> 24.8) print $6, $9,$9}' $pfile | gmt plot -Sc5p -C$CPT -W0.3p
        
        echo 'test'
#        gmt plot -A -W0.5p,- << EOF 
#>
#$fmin -$y
#$fmin $y
#>
#$fmax -$y
#$fmax $y
#EOF

 
        # ts in xy plot 
        gmt basemap $rang $proj $bin+t'@~D@~t@-s@-' $binx $biny -X3.6i
        gmt plot tmp_frange -L -Ggray -W0.3p,- 
        awk '{if ($2==$11) print $6, $9}' $sfile | gmt plot -Sc5p  
        awk '{if ($2==$11 && $4> 24.8) print $6, $9, $9}' $sfile | gmt plot -Sc5p -C$CPT -W0.3p

        set y2 = 2.5
        cat << EOF > tmp_frange2
$fmin -$y2 
$fmin $y2
$fmax $y2
$fmax -$y2
$fmin -$y2
EOF

        #delay ratio
        paste $pfile $sfile > tmp_deratio
        gmt basemap -R$xmin/$xmax/-$y2/$y2 $proj $bin+t'@~D@~ts/@~D@~tp' \
        $binx+l'Epicentral Distance (km)' -Bya1f0.5  -X-3.6i -Y-2i
        gmt plot tmp_frange2 -L -Ggray -W0.3p,-
        awk '{if($2==$23 && sqrt($9**2)>0.05) print $6, $21/$9}' tmp_deratio | gmt plot -Sc5p
        awk '{if($9/$21 > 2.5) print $0}' tmp_deratio > tmp_check_$dir
        #awk '{if($2==$23 && $4> 24.8 && sqrt($9**2)>0.1) print $6, $21/$9}' tmp_deratio | gmt plot -Gorange -Sc5p
        
        # S ampliltude
        set maxamp = `sort -k4 -g -r s/$dir/amp_$dir | sed -n '2p' | awk '{print $4}'`
        gmt coast -R$range -JM2.5i -X3.9i -Y-0.6i -BWNrb -Bxa1f0.5 -Bya0.5f0.25 -W0.3p
        awk '{print $2, $3, $4/max}' max=$maxamp s/$dir/amp_$dir | gmt plot -Sc5p -C$CPT10 -W0.3p
        gmt colorbar -C$CPT10 -Ba0.5f0.1+l'S amplitude' -DjBR+w3c/0.2c+o-0.7/0c+v 

        #label (a)
        gmt text -N  -F+f14p << EOF
120.65 28.5   (b)
120.65 26.75  (d)
120.65 25.7  (f)
118.35  28.5  (a)
118.35  26.75 (c)
118.35  25.68  (e)
EOF


    gmt end
end #dir
#eog $PS.png
