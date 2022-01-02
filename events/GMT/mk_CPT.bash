# Generate CPT files for GMT mapping #

cptnm=Canada_LgSn.cpt
cpt=polar

# z_min=0.2
# z_max=2.5
# z_inc=0.1
# T=$z_min/$z_max/$z_inc

z_min=-0.6
z_max=0.6
z_inc=0.1
T=$z_min/$z_max/$z_inc

# T=-.69897,-.52288,-.3979,-.30103,-.2218,-.1549,-.09691,-.045757,0,.04139,.07918,.1139,.1461,.17609,.20412,.23045,.25527,.301,.3222,.3424,.3617,.3802,.39794



# T=-1,0,1

gmt makecpt -C$cpt -T$T -D >$cptnm

