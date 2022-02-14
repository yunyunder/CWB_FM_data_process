#!/bin/python
# modify by set_tmark.csh
# read CWB mseed and pzfile
# rotate to rtz, lowpass to 1 hz, remove instrument response
# write taup p, s arrival time in new .mark file 
# store at p/events s/events directorys. 2021/06/28 Yin 

import os
import glob
import numpy as np
from obspy import read, Stream, UTCDateTime, Trace
from obspy.io.sac import SACTrace
from obspy.io.sac.sacpz import attach_paz

from obspy.taup import TauPyModel
from obspy.geodetics import locations2degrees
from obspy.geodetics.base import gps2dist_azimuth
import matplotlib.pyplot as plt
from matplotlib.transforms import blended_transform_factory

# Read sta info (mseed has no sta lat lon info)
sta_data = np.genfromtxt('nsta24.dat', skip_header=6, dtype=str)
sta_name = sta_data[:,0]
sta_lon, sta_lat =sta_data[:,1].astype(float), sta_data[:,2].astype(float)
dict_sta_info = {}
for i in range(len(sta_name)):
    if ( sta_lat[i] < 24.5 ):
        continue
    dict_sta_info[sta_name[i]] = sta_lon[i], sta_lat[i]

# Read events info
data = np.genfromtxt('events_lat_lon_dep', dtype=str, encoding='utf-8')
day, time  = data[:,1], data[:,2]
elat, elon, edep = data[:,3].astype(float), data[:,4].astype(float),data[:,5].astype(float)

#os.rmdir('p')
#os.rmdir('s')
os.mkdir('p')
os.mkdir('s')


# Read pz file into dict_pz
dict_pz = {}
sta_all  = os.listdir('/home/seismograms/TWseismograms/PZ/')
#print(sta_all)

for sta in dict_sta_info:
    PZs = glob.glob('/home/seismograms/TWseismograms/PZ/%s/*.HHZ.CWB*'%(sta))
    if (PZs == []):
        #print(sta)
        continue
    #print(PZs[-1])
    #for pzfile in PZs :
    #print(pzfile)
    #station_name = pzfile.split('_')[]
    #if (station_name in dict_pz ):
    #    continue
        
    tr = Trace()
    attach_paz(tr, PZs[-1], tovel=True, torad=True) 
    dict_pz[sta] = tr  #save into dict



model = TauPyModel(model='prem')
for i in range(len(day)) :
#for i in np.arange(1) :

    starttime = UTCDateTime(day[i]+time[i])
    #20190312_201915
    event_dir = starttime.strftime('%Y%m%d_%H%M%S') 
    os.mkdir('p/%s'%(event_dir))
    os.mkdir('s/%s'%(event_dir)) 

    #sac_bh = glob.glob('%s/*BHE.SAC'%(event_dir))
    st_all = Stream()


    #for sacfile in sac_bh:
    for sta in dict_pz :

        #sta = sacfile.split('.')[1]
        st = Stream()
        st_sta = Stream()
        mseedpath = ('/home/seismograms/TWseismograms/Continuous/%s/%s')%(starttime.strftime('%Y'), sta)
        if not os.path.exists(mseedpath) : 
            continue
        if glob.glob('%s/*HH*.%s.mseed'%(mseedpath, starttime.strftime('%j'))) == [] :
            continue
        st = read('%s/*HH*.%s.mseed'%(mseedpath, starttime.strftime('%j')))
        print(st)
        print('')

        st_sta = st.copy()
        st_sta.trim(starttime=starttime-50, endtime=starttime+120)

        paz_sts2 = {'poles': dict_pz[sta].stats.paz['poles'],
                    'zeros': dict_pz[sta].stats.paz['zeros'],
                    'gain': dict_pz[sta].stats.paz['gain'],
                    'sensitivity': dict_pz[sta].stats.paz['sensitivity'] }
        st_sta.simulate(paz_remove = paz_sts2)

        slon, slat = dict_sta_info[sta]
        #if ( slat < 24.5 ):
        #    continue

        dis_m, az, baz = gps2dist_azimuth(elat[i], elon[i], slat, slon)
        epi_dis = locations2degrees(elat[i], elon[i], slat, slon)
        arr_time = model.get_travel_times(source_depth_in_km = edep[i],
                                          distance_in_degree = epi_dis,
                                          phase_list = ['p','s'])
        st_sta.rotate(method='NE->RT', back_azimuth=baz)
        st_sta.filter('bandpass',freqmax=1, freqmin=0.1, corners=2, zerophase = True)
        st_sta.detrend(type='demean')

        st_all += st_sta

        for tr in st_sta :
            sac = SACTrace.from_obspy_trace(tr)

            tr.stats.distance = dis_m 
            sac.evla = elat[i]
            sac.evlo = elon[i]
            sac.evdp = edep[i]
            sac.stla = slat
            sac.stlo = slon
            sac.stdp = 0.
            sac.stel = 0.
            sac.o = starttime
            sac.iztype = 'io' 
            sac.lcalda = True 
    
            for phase in ['p', 's']:
                if (phase == 'p'):
                    sac.t0 = arr_time[0].time
                    sac.t2 = arr_time[0].time
                    sac.kt0 = arr_time[0].name
                elif (phase == 's') :
                    sac.t0 = arr_time[1].time
                    sac.t2 = arr_time[1].time
                    sac.kt0 = arr_time[1].name
                name = ('%s/CWB.%s.%s.SAC')%(event_dir, tr.stats.station, tr.stats.channel)
                sac.write('%s/%s.mark'%(phase, name))

    
#    fig = plt.figure()
#    st_z = st_all.select(component="Z")
#    st_z.trim(starttime, starttime+50)
#    st_z.plot(type='section',fig=fig)
#
#    ax = fig.axes[0]
#    transform = blended_transform_factory(ax.transData, ax.transAxes)
#    for tr in st_z:
#        ax.text(tr.stats.distance / 1e3, 1.0, tr.stats.station, rotation=270,
#                va="bottom", ha="center", transform=transform, zorder=10)
#    plt.savefig('section_%s.png'%(event_dir), dpi=300)

    print('%s done'%(event_dir))

