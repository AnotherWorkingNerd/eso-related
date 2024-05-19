#!/bin/zsh
# ==============================================
# Update TTC PriceList script - 2024
# Author: AnotherNerdHere
#
# This is designed to run under ZShell (zsh) on MacOS.
# Since many can get the TTC Client (and frequently minion) to work
# While this may not replace all the functionality of the TTC Client
# it will update the TTC Price List data aka PriceTable.
# if you are reading this it could be easily modified to work with
# any Linux distro using the Zshell.
#
# This is easy to update but this should work for any Mac ESO install.
# but if you want to change things (like for EU)...
# simply update the 3 variables below

# where the TTC addon lives.
ADDONDIR="/Users/${USER}/Documents/Elder Scrolls Online/live/AddOns/TamrielTradeCentre/"
# Where to download the price list
DNLDDIR=/Users/$USER/Downloads/eso
# price list URL aka price list. Change this if you need EU Price table
PLURL='https://us.tamrieltradecentre.com/download/PriceTable'
# PLURL='https://eu.tamrieltradecentre.com/download/PriceTable'

# ==============================================
# PLEASE DO NOT CHANGE THE CODE BELOW.
# Unless you're a trained professional :-D
# ==============================================
# set colors for output strings. no I don't use all of them but I like options.
GREEN=2
YELLOW=3
WHITE=7
BRTGREEN=10
BRTYELLOW=11
BRTWHITE=15
BRTCYAN=13
# capture pwd
OLDDIR=$(pwd)

cd {DNLD-DIR}
echo start
# ==============================================
#clear
print -P "%F{$BRTGREEN}Starting TTC Pricelist update%f"
# ==============================================
print -P "%F{$GREEN} Date: [$(date +%m)] $(date +%B) $(date +%d) [$(date +%A)], $(date +%Y)"
print -P "%F{$GREEN} Time: $(date +%T)"
print -P "%F{$GREEN} Downloading PriceTable from TTC...%f"

# really besic error handling
http_status=$(curl -o ${DNLDDIR}/PriceTable.zip ${PLURL} -sS -w '%{http_code}')
if [ $http_status != "200" ]; then
    # handle error exit with error
    print -P "%F{$BRTYELLOW} PriceTable was not successfully downloaded from TTC"
    exit 1
else
    print -P "%F{$GREEN} Price table successfully downloaded"
fi

print -P "%F{$GREEN} Unzipping PriceTable%f"
unzip -qo ${DNLDDIR}/PriceTable.zip -d ${DNLDDIR}/PriceTable
sleep 1
cd ${DNLDDIR}/PriceTable
print -P "%F{$GREEN} PriceTable Unzipped"

print -P "%F{$GREEN} Updating Previous PriceTable"
mkdir -p ${ADDONDIR}
sleep 1
rsync -auz ${DNLDDIR}/PriceTable/*.lua ${ADDONDIR}
print -P "%F{$GREEN} Update Completed"

print -P "%F{$GREEN} Removing Temporary Files..."
cd ${DNLDDIR}
rm -rf ${DNLDDIR}/PriceTable
rm -f  ${DNLDDIR}/PriceTable.zip
print -P "%F{$GREEN} Temporary Files Removed"
print -P "%F{$BRTGREEN} TTC PriceTable updated successfully."
#always return to where I started.
cd ${OLDDIR}
exit 0
