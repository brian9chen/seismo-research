# Generate CPT files for GMT mapping #

cptnm=Wyoming_LgSn.cpt
cpt=polar

z_min=0.0
z_max=0.01
z_inc=0.005
T=$z_min/$z_max/$z_inc
	
gmt makecpt -C$cpt -T$T -D >$cptnm
