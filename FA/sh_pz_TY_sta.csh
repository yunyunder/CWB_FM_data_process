#!/bin/csh
# create PZs for TY-- station! 2022/01

foreach num (`seq -w 1 14`)
    echo $num
    set sta = TY${num}

    cp PZs/SAC_PZs_FM_WU19_BHZ__2018.324.00.00.00.0000_2599.365.23.59.59.99999 PZs/SAC_PZs_FM_${sta}_BHZ__2018.324.00.00.00.0000_2599.365.23.59.59.99999


    end
end
