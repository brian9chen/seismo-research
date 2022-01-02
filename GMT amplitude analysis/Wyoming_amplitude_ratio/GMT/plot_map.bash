gmt gmtset PS_PAGE_ORIENTATION portrait
gmt set PS_MEDIA A4
gmt set MAP_FRAME_TYPE plain
gmt set MAP_ANNOT_OBLIQUE 4

# set the font sizes
gmt set FONT_ANNOT_PRIMARY 12p,Helvetica
gmt set FONT_LABEL 12p,Helvetica
gmt set FONT_TITLE 14p,Helvetica-Bold
### input directory
cdir=$(pwd)
echo $cdir

### File name
ps=Wyoming.ps

#Get the opend window's process id
pid_num=`ps aux | egrep -i axel | egrep -i preview | egrep -v grep | awk '{print $2}'`
#Close the opened Preview window
kill $pid_num
#Remove the .ps file from previous trys
rm $ps

########## ONLY Modify in between dashed lines #################
#--------------------------------------------------------------------------------------------------------

### The range for the small map

lon_min=-125
lon_max=-95
lat_min=32
lat_max=50


### Plot the focal mechanism
# gmt psmeca -R-109.2/-109.1/42.9/43 -Jm4c -Sc0.4 -h1 << END > test.ps
# lon lat depth str dip slip st dip slip mant exp plon plat
# 239.384 34.556 12. 180 18 -88 0 72 -90 5.5 0 0 0
# END
# gmt psmeca -R239/240/34/35.2 -Jm4c -Sc0.4 -h1 << END > test.ps
# lon lat depth str dip slip st dip slip mant exp plon plat
# 239.384 34.556 12. 180 18 -88 0 72 -90 5.5 0 0 0
# END

### Plot the local coastlines
gmt pscoast -R$lon_min/$lon_max/$lat_min/$lat_max -JM6i -Df -P -K -Ba -G -N2 -W1/0.25p > $ps

### Poor Sn zone (boundary)
#gmt psxy poor_sn_zone.txt -R -J -O -K -Ggrey -W1p,black -V >> $ps

### Earthquake
gmt psxy evt_Wyoming_deep.txt -R -J -O -K -Sa0.3i -Gblue -W1p,blue -V >> $ps

gmt psxy evt_Wyoming_shallow.txt -R -J -O -K -Sa0.3i -Gred -W1p,blue -V >> $ps

### Stations
gmt psxy stn_Wyoming.txt -R -J -O -K -St0.3i -CWyoming_LgSn.cpt -W1p,black -V >> $ps



### Raypaths
# Similar 
gmt psxy Raypaths.txt -R -J -O -K -CWyoming_LgSn.cpt -W1p,black -V >> $ps

### Comparison Earthquake
#gmt psxy evt_C17.txt -R -J -O -K -Sa0.1i -Gred -W1p,red -V >> $ps

### Legends
# Poor Sn zone
#gmt pstext -R -J -O -K -V <<END>>$ps
#90 33.5 10 0 16 5 Poor Sn zone
#END
# EQ
#gmt pstext -R -J -O -K -V <<END>>$ps
#90.3 30.3 10 0 13 5 H104
#END
# Comparison EQ
#gmt pstext -R -J -O -K -V <<END>>$ps
#88 30 10 0 13 5 C17
#END

# Plot CPT Color Scale
gmt psscale -Dx0i/7i+w6i/0.3i+h -B0.1 -B+l"Max Amplitude (Deep/Shallow Ratio)" -CWyoming_LgSn.cpt -O -K >> $ps 

### Title
gmt pstext -R -J -O -K -V -N <<END>>$ps
-124 53.5 20 0 17 5 Wyoming ratio max Amplitudes:1-2Hz

END


#--------------------------------------------------------------------------------------------------------
# Open the new document
open $ps