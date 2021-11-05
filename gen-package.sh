#! /bin/bash -e
export DESTDIR=build-temp
rm -rf $DESTDIR
mkdir $DESTDIR

# create dockcross script
echo "Generating dockercross script"
IMG=tvoneicken/sensorgnome-dockcross:armv7-rpi-buster-main
docker run $IMG >sensorgnome-dockcross
chmod +x sensorgnome-dockcross

echo "Cross-compiling and installing"
make clean
./sensorgnome-dockcross -i $IMG \
    make -j4 install DESTDIR=$DESTDIR STRIP=armv7-unknown-linux-gnueabi-strip

cp -r DEBIAN $DESTDIR
mkdir -p packages
dpkg-deb -v --build $DESTDIR packages/vamp-alsa-host.deb
# dpkg-deb --contents packages/vamp-alsa-host.deb
ls -lh packages/vamp-alsa-host.deb
