#!usr/bin/env bash

### Tzolkindrier ###
#

fulldate=$(date "+%F")
#fulldate=$"1992-9-21"
fulldate=$"2023-9-22"
#fulldate=$"1826-9-14"

year=$(echo $fulldate | cut -d "-" -f 1)
month=$(echo $fulldate | cut -d "-" -f 2)
day=$(echo $fulldate | cut -d "-" -f 3)

#calculate Julian day
julian=$(((1461*($year+4800+($month-14)/12))/4+(367*($month-2-12*(($month-14)/12)))/12-(3*(($year+4900+($month-14)/12)/100))/4+$day-32075))


## Maya calendar section
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

echo "$baktun.$katun.$tun.$uinal.$kin  $tzolkin_no $tzolkin_nm  $haab_no $haab_nm"


## French Republican calendar section
#substract Julian day of day 0 to get the FRC day number
sinced0=$(($julian-2375840))

#calculate the FRC date
annee=$((($sinced0/365)+1))
annee=$(((($sinced0-($annee/4)+($annee/100))/365)+1))
rem=$(((($sinced0-($annee/4)+($annee/100))%365)+1))
mois=$((($rem/30)+1))
jour=$(($rem%30))
echo $annee

if [[ $(($annee%4)) -eq 0 ]]; then
    if [[ $(($annee%100)) -eq 0 ]]; then
        echo "divisible by 100"
        mois=$((($rem/30)+1))
        jour=$(($rem%30))
    else
        echo "leap"
        rem=$(($rem+1))
        mois=$((($rem/30)+1))
        jour=$(($rem%30))
    fi
else
    echo "non-leap"
    mois=$((($rem/30)+1))
    jour=$(($rem%30))
fi

echo $rem
echo "$jour $mois an $annee"

#convert the year to Roman numerals
year2roman=$annee
subvalue()
{
    annee_roman="${annee_roman}$2"
    year2roman=$(($year2roman-$1))
}
while [[ $year2roman -gt 0 ]]; do
    if [[ year2roman -ge 1000 ]]; then
        subvalue 1000 "M"
    elif [[ year2roman -ge 900 ]]; then
        subvalue 900 "CM"
    elif [[ year2roman -ge 500 ]]; then
        subvalue 900 "D"
    elif [[ year2roman -ge 400 ]]; then
        subvalue 400 "CD"
    elif [[ year2roman -ge 100 ]]; then
        subvalue 100 "C"
    elif [[ year2roman -ge 90 ]]; then
        subvalue 90 "XC"
    elif [[ year2roman -ge 50 ]]; then
        subvalue 50 "L"
    elif [[ year2roman -ge 40 ]]; then
        subvalue 40 "XL"
    elif [[ year2roman -ge 10 ]]; then
        subvalue 10 "X"
    elif [[ year2roman -ge 9 ]]; then
        subvalue 9 "IX"
    elif [[ year2roman -ge 5 ]]; then
        subvalue 5 "V"
    elif [[ year2roman -ge 4 ]]; then
        subvalue 4 "IV"
    elif [[ year2roman -ge 1 ]]; then
        subvalue 1 "I"
    fi
done

#put it all together, adding month names and Sansculottides
mois_nms=("Vendémiaire" "Brumaire" "Frimaire" "Nivôse" "Pluviôse" "Ventôse" "Germinal" "Floréal" "Prairial" "Messidor" "Thermidor" "Fructidor")
if [[ $mois == 13 ]]; then
    mois=""
    if [[ $rem == 361 ]]; then
        jour="Celebration of Virtue"
    elif [[ $rem == 362 ]]; then
        jour="Celebration of Talent"
    elif [[ $rem == 363 ]]; then
        jour="Celebration of Labour"
    elif [[ $rem == 364 ]]; then
        jour="Celebration of Convictions"
    elif [[ $rem == 365 ]]; then
        jour="Celebration of Honours"
    elif [[ $rem == 366 ]]; then
        jour="Revolution Day"
        annee=$(($annee-1))
    fi
    echo "$jour, an $annee_roman"
else
    mois=${mois_nms[($mois-1)]}
    echo "$jour $mois an $annee_roman"
fi



