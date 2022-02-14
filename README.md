# CWB_FM_data_process  
CWB and Formosa array data processing, aimbat and plot code  
## Data processing
### Check data path and stored format in following script   
FA/fa_processing.ipynb  
CWB_BATS/cut_cwb_continu_tmark.py  
CWB_BATS/bats_conti_tmark.py  
```
python ascii_sac.py  
```
P and S arrival need to be aimbated seperately  
create p and s directory and cut data and mark t0 t2  
FM.CT15 & FM.WU18 not used! (only with Z comp)  
## AIMBAT
https://aimbat.readthedocs.io/en/latest/installation.html  
Follow steps to install conda envs
```
conda activate your_env
./aimbat_loop.csh  
```
use aimbat to line up  

## Plot  
```
./set_max_amp.csh
```
user0 would be max amp value  
```
./plot_mccc_yy.csh or ./plot_mccc.csh  
```
plot mccc, ccf and  amp_ratio map  
```
./plot_delay_ratio.csh  
python check_delay_plot.py  
```
For detail delay info  
```
./plot_aimbat_delay_ps_map.csh  
```
plot p s delay on map  
modify work in sh_loop_events.csh  

## Select station (only process Formosa array)  
```
./sh_create_both_ps_great_ccf.csh 
cd Both_Great_ccf
vi sh_loop_events.csh
```
Create Both_Great_ccf directory where ccf of p & s > 0.5  
```
./sh_create_target_stations.csh  
```
Create Target_sta directory with stations in target_fa_stations.txt  
