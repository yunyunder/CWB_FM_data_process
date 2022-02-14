# CWB_FM_data_process
CWB and Formosa array data process, cut, aimbat and plot code

P and S arrival need to be aimbated seperately
1. ascii_sac.py
   create p and s directory
   change axisem result (xy) into sac file
CT15  WU18 not used! (only with Z comp)
1. cut data and mark t0 t2

2. aimbat_loop.csh
   use aimbat to line up (conda activate conda_yin)



--------------------------
3. set_max_amp.csh (after this step don't aimbat-sac2pkl again)
   user0 would be max amp value

4. plot_mccc_yy.csh / plot_mccc.csh
   plot mccc, ccf and  amp_ratio map

5. plot_delay_ratio.csh
6. check_delay_plot.py
   For detail delay info

7. plot_aimbat_delay_ps_map.csh
   plot p s delay on map

-----------------------------
select station

1. sh_create_both_ps_great_ccf.csh =>  Both_Great_ccf
   p & s ccf > 0.5

2. sh_create_target_stations.csh =>  Target_sta
   select target_fa_stations.txt (specific stations)
