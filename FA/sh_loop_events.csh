#!/bin/csh
# please modify !!  Nov 8. 2021

set work = 4

# following script read /home/yin/Data/prem_list 
# for looping jobs

if ($work == 1) then
    echo 'create directory ascii2sac '
    echo 'Use jupyter script to process FM data'

else if ($work == 2 ) then
    echo 'aimbat looping  '
    echo 'pick single event once'

    conda activate conda_yin
    ./aimbat_loop_fa.csh

else if ($work == 3 ) then
    echo 'PLOT'
    conda activate conda_yin
    ./set_max_amp_fa.csh
    ./plot_mccc_fa.csh
    ./plot_delay_ratio_fa.csh

else 
    echo 'PLOT_2'
    conda activate conda_yin
    ./plot_aimbat_delay_ps_map.csh
    ./sh_create_both_ps_great_ccf.csh
endif

