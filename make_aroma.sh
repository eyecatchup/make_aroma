#!/bin/bash
##
#  Bash script to re-zip an Evervolv ICS OTA-Package build as AROMA-Installer.
#  (c) 2012 Stephan Schmitz <eyecatchup@gmail.com>
#
#  @use Place the OTA-Package in $aromadir (@see ln 14) and run:
#         ./make_aroma.sh Evervolv-Perdo-x.x.x-passion
##

# Name of otapackage zip (/wo ext.)
otapackage=$1

# Path to the template files
aromadir=/home/bexton/Documents/ota2aroma

# Check correct number of arguments
if [ $# -ne 1 ]; then
    echo -e "This script must be run with one argument, providing the name of an otapackage."
    exit 1
fi;

# Check if otapackage exists
if [ ! -f "$aromadir/$otapackage.zip" ];
then
    echo -e "File \"$aromadir/$otapackage.zip\" not found!"
    exit 1
fi

#
# Create a new installer-package directory
#
echo -e "Creating new AROMA-Installer directory..." 
cd "$aromadir"
tempdest="$aromadir/$otapackage-aroma"
mkdir "$tempdest"
cd "$aromadir/template"
find . -depth | cpio --pass-through --preserve-modification-time --make-directories --verbose "$tempdest" &> /dev/null

#
# Unzip the otapackage zip to a temporary directory
#
echo -e "Unzipping otapackage..." 
cd "$aromadir"
tempsrc=$(mktemp -d)
unzip -d "$tempsrc" "$otapackage.zip" &> /dev/null

#
# Move optional system apps
#
echo -e "Moving optional system apps..." 
mv "$tempsrc"/system/app/Calendar.apk "$tempdest"/optional_sys/calendar/ &> /dev/null
mv "$tempsrc"/system/app/CalendarProvider.apk "$tempdest"/optional_sys/calendar/ &> /dev/null

mv "$tempsrc"/system/app/Email.apk "$tempdest"/optional_sys/email/ &> /dev/null

mv "$tempsrc"/system/app/Androidian-6-100.apk "$tempdest"/optional_sys/themes/ &> /dev/null
mv "$tempsrc"/system/app/ThemeChooser.apk "$tempdest"/optional_sys/themes/ &> /dev/null
mv "$tempsrc"/system/app/ThemeManager.apk "$tempdest"/optional_sys/themes/ &> /dev/null

mv "$tempsrc"/system/app/LiveWallpapers.apk "$tempdest"/optional_sys/livewps/ &> /dev/null
mv "$tempsrc"/system/app/LiveWallpapersPicker.apk "$tempdest"/optional_sys/livewps/ &> /dev/null
mv "$tempsrc"/system/app/Galaxy4.apk "$tempdest"/optional_sys/livewps/ &> /dev/null
mv "$tempsrc"/system/app/HoloSpiralWallpaper.apk "$tempdest"/optional_sys/livewps/ &> /dev/null
mv "$tempsrc"/system/app/MagicSmokeWallpapers.apk "$tempdest"/optional_sys/livewps/ &> /dev/null
mv "$tempsrc"/system/app/NoiseField.apk "$tempdest"/optional_sys/livewps/ &> /dev/null
mv "$tempsrc"/system/app/PhaseBeam.apk "$tempdest"/optional_sys/livewps/ &> /dev/null
mv "$tempsrc"/system/app/VisualizationWallpapers.apk "$tempdest"/optional_sys/livewps/ &> /dev/null

mv "$tempsrc"/system/app/VideoEditor.apk "$tempdest"/optional_sys/misc/ve/ &> /dev/null

#
# Move core system
#
echo -e "Moving core system..."
mv "$tempsrc"/system "$tempdest"/system/ &> /dev/null
echo -e "Moving boot.img..."
mv "$tempsrc"/boot.img "$tempdest"/boot.img &> /dev/null

#
# Move & rename update-binary
#
echo -e "Moving/renaming update-binary..."
mv "$tempsrc"/META-INF/com/google/android/update-binary "$tempdest"/META-INF/com/google/android/update-binary-installer &> /dev/null

#
# Create installer-package zip archive
#
echo -e "Creating AROMA-Installer zip..."
zip -r "$otapackage-aroma.zip" "$tempdest" &> /dev/null
chmod 755 "$otapackage-aroma.zip" &> /dev/null

# Remove temporary directory
echo -e "Removing temporary directory..."
rm -rf "$aromadir/$otapackage-aroma" &> /dev/null 

echo "Done. Successfully created \"$aromadir/$otapackage-aroma.zip\"!"
exit

