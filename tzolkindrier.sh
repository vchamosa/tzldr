#!usr/bin/env bash

# Tzolkindrier
#

fulldate=$(date "+%F")
#fulldate=$"1792-9-22"
#fulldate=$"1795-9-23"
#fulldate=$"2024-9-11"

year=$(echo $fulldate | cut -d "-" -f 1)
month=$(echo $fulldate | cut -d "-" -f 2)
day=$(echo $fulldate | cut -d "-" -f 3)

#calculate Julian day
julian=$(((1461*($year+4800+($month-14)/12))/4+(367*($month-2-12*(($month-14)/12)))/12-(3*(($year+4900+($month-14)/12)/100))/4+$day-32075))


# Maya calendar section
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
if [[ $tzolkin_no == 0 ]]; then
    tzolkin_no=13
fi
tzolkin_nm=$(($sinced0%20))
tzolkin_nm=${tzolkin_nms[(tzolkin_nm-1)]}

#calculate Haab'
haab_nms=("Pop" "Wo'" "Sip" "Sotz'" "Sek" "Xul" "Yaxk'in" "Mol" "Ch'en" "Yax" "Sak'" "Keh" "Mak" "K'ank'in" "Muwan" "Pax" "K'ayab" "Kumk'u")
haab_nm=$((((($sinced0-17)%365)+1)))
if [[ $haab_nm > 360 ]]; then
    haab_no=$(echo $haab_nm | cut -c 3)
    haab_nm="Wayeb"
else
    haab_nm=$(($haab_nm/20))
    haab_nm=${haab_nms[(haab_nm)]}
    haab_no=$(((($sinced0-17)%365)%20))
    if [[ $haab_no == 0 ]]; then
        haab_no="Seating of"
    fi
fi

echo $baktun"."$katun"."$tun"."$uinal"."$kin"  "$tzolkin_no" "$tzolkin_nm"  "$haab_no" "$haab_nm


# French Republican calendar section
#substract Julian day of day 0 to get the FRC day number
sinced0=$(($julian-2375840))

#calculate the FRC date
fr_year=$((($sinced0/365)+1))
rem=$((($sinced0%365)-($fr_year/4)+($fr_year/100)))
fr_month=$((($rem/30)+1))
fr_day=$((($rem%30)+1))

month_nms=("Vendémiaire" "Brumaire" "Frimaire" "Nivôse" "Pluviôse" "Ventôse" "Germinal" "Floréal" "Prairial" "Messidor" "Thermidor" "Fructidor")
if [[ $rem -lt 0 ]] || [[ $rem > 359 ]] || [[ $fr_month == 13 ]] || [[ $fr_month == 1 ]]; then
    fr_month=""
    if [[ $rem == 360 ]] || [[ $rem == -5 ]]; then
        fr_day="Celebration of Virtue"
    elif [[ $rem == 361 ]] || [[ $rem == -4 ]]; then
        fr_day="Celebration of Talent"
    elif [[ $rem == 362 ]] || [[ $rem == -3 ]]; then
        fr_day="Celebration of Labour"
    elif [[ $rem == 363 ]] || [[ $rem == -3 ]]; then
        fr_day="Celebration of Convictions"
    elif [[ $rem == 364 ]] || [[ $rem == -2 ]]; then
        fr_day="Celebration of Honours"
    elif [[ $rem == -1 ]]; then
        fr_day="Revolution Day"
        fr_year=$(($fr_year-1))
    fi
    echo "$fr_day, an $fr_year"
else
    fr_month=${month_nms[($fr_month-1)]}
    echo "$fr_day $fr_month an $fr_year"
fi




