#!/bin/bash
#
# Roberto Chaud 
# https://github.com/chinochao/scripts
# Version : 0.1.0
# 
#
# Description: An updated fork of LSI.SH. MegaCLI script to configure and monitor LSI raid cards.

# megalsi.sh

# Full path to the MegaRaid CLI binary
MegaCli="/opt/MegaRAID/MegaCli/MegaCli64"

# The identifying number of the enclosure. Default for our systems is "8". Use
# "MegaCli64 -PDlist -a0 | grep "Enclosure Device"" to see what your number
# is and set this variable.
ENCLOSURE="64"


status() {
    $MegaCli -LDInfo -Lall -aALL -NoLog
    echo "###############################################"
    $MegaCli -AdpPR -Info -aALL -NoLog
    echo "###############################################"
    $MegaCli -LDCC -ShowProg -LALL -aALL -NoLog
}

drives() {
    $MegaCli -PDlist -aALL -NoLog | egrep 'Slot|state' | awk '/Slot/{if (x)print x;x="";}{x=(!x)?$0:x" -"$0;}END{print x;}' | sed 's/Firmware state://g'
}

ident(ID){
    $MegaCli  -PdLocate -start -physdrv[$ENCLOSURE:$2] -a0 -NoLog
    logger "`hostname` - identifying enclosure $ENCLOSURE, drive $ID "
    read -p "Press [Enter] key to turn off light..."
    $MegaCli  -PdLocate -stop -physdrv[$ENCLOSURE:$2] -a0 -NoLog
}

update()){
    echo "################ UPDATING MEGALSI.SH ################"
    logger "`hostname` - identifying enclosure $ENCLOSURE, drive $ID "
    read -p "Press [Enter] key to turn off light..."
    $MegaCli  -PdLocate -stop -physdrv[$ENCLOSURE:$2] -a0 -NoLog
}

case "$1" in
        status)
            status
            ;;
         
        drives)
            drives
            ;;
         
        ident)
            ident
            ;;
        restart)
            stop
            start
            ;;
        update)
            if test "x`pidof anacron`" != x; then
                stop
                start
            fi
            ;;
         
        *)
            echo ""
            echo "            Usage  .:.  lsi.sh \$arg1 \$arg2"
            echo "-----------------------------------------------------"
            echo "status        = Status of Virtual drives (volumes)"
            echo "drives        = Status of hard drives"
            echo "ident \$slot   = Blink light on drive (need slot number)"
            echo "good \$slot    = Simply makes the slot \"Unconfigured(good)\" (need slot number)"
            echo "replace \$slot = Replace \"Unconfigured(bad)\" drive (need slot number)"
            echo "progress      = Status of drive rebuild"
            echo "errors        = Show drive errors which are non-zero"
            echo "bat           = Battery health and capacity"
            echo "batrelearn    = Force BBU re-learn cycle"
            echo "logs          = Print card logs"
            echo "checkNemail   = Check volume(s) and send email on raid errors"
            echo "allinfo       = Print out all settings and information about the card"
            echo "settime       = Set the raid card's time to the current system time"
            echo "setdefaults   = Set preferred default settings for new raid setup"
            echo ""
            exit 1
 
esac

