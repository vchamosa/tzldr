# Tzolkindrier
#

fulldate=$(date "+%F")

year=$(echo $fulldate | cut -d "-" -f 1)
month=$(echo $fulldate | cut -d "-" -f 2)
day=$(echo $fulldate | cut -d "-" -f 3)

#calculate Julian day
julian=$(((1461*($year+4800+($month-14)/12))/4+(367*($month-2-12*(($month-14)/12)))/12-(3*(($year+4900+($month-14)/12)/100))/4+$day-32075))

#substract GMT correlation to get the raw Long Count day
sinced0=$(($julian-584283))

#calculate Long Count units
baktun=$(($sinced0/144000))
rem=$(($sinced0%144000))
katun=$(($rem/7200))
rem=$(($sinced0%7200))
tun=$(($rem/360))
rem=$(($sinced0%360))
uinal=$(($rem/20))
kin=$(($rem%20))

echo $baktun"."$katun"."$tun"."$uinal"."$kin


