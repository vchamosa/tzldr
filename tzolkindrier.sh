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

#calculate Tzolk'in
tzolkin_nms=("Imix" "Ik'" "Ak'b'al" "K'an" "Chikchan" "Kimi" "Manik'" "Lamat" "Muluk" "Ok" "Chuwen" "Eb'" "B'en" "Ix" "Men" "Kib'" "Kab'an" "Etz'nab'" "Kawak" "Ajaw")
tzolkin_no=$((($sinced0+4)%13))
tzolkin_nm=$(($sinced0%20))
tzolkin_nm=${tzolkin_nms[(tzolkin_nm-1)]}

#calculate Haab'
haab_nms=("Pop" "Yax" "Wo'" "Sak'" "Sip" "Keh" "Sotz'" "Mak" "Sek" "K'ank'in" "Xul" "Muwan" "Yaxk'in" "Pax" "Mol" "K'ayab" "Ch'en" "Kumk'u" "Wayeb")
haab_nm=$((((($sinced0-17)%365)+1)/20))
haab_nm=${haab_nms[(haab_nm-1)]}
haab_no=$(((($sinced0-17)%365)%20))


echo $baktun"."$katun"."$tun"."$uinal"."$kin"  "$tzolkin_no" "$tzolkin_nm"  "$haab_no" "$haab_nm


