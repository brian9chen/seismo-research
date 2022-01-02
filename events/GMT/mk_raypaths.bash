# Script to make text input files for GMT to draw raypaths
# Changes for new run: 
# 1. Name of the text file on the first 'rm' and last three 'echo', and after the 'done'
# 2. The list of station files for the 'read' at start of the loop, and after 'stlo' and 'stla'
# 3. If for a different event, change 'evlo' and 'evla'.

rm Raypaths.txt

while read stn_Canada
do 
	stlo=$(echo $stn_Canada | awk -F ' ' '{print $1}')
	stla=$(echo $stn_Canada | awk -F ' ' '{print $2}')
	Zval=$(echo $stn_Canada | awk -F ' ' '{print $3}')

	evlo=$(echo -112.780) 
	evla=$(echo 49.310)

    echo "> > -Z$Zval" >> Raypaths.txt
	echo "$evlo $evla" >> Raypaths.txt
	echo "$stlo $stla" >> Raypaths.txt


done<stn_Canada.txt 