#!/bin/bash
set -e

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ $# -ne 1 ]; then
	echo "Usage: $0 <build directory>"
	exit 1
fi
builddir=$1
mkdir -p $builddir
builddir="$( cd "$builddir" && pwd )"
packagedir=$builddir/packages
libdir=$builddir/libs

toolchain_file=$dir/toolchain_mingw.cmake
irrlicht_version=1.8.1
ogg_version=1.2.1
vorbis_version=1.3.3
curl_version=7.38.0
gettext_version=0.14.4
freetype_version=2.3.5
sqlite3_version=3.8.7.4
luajit_version=2.0.1
leveldb_version=1.15
zlib_version=1.2.8

mkdir -p $packagedir
mkdir -p $libdir

cd $builddir

#<<'COMMENT'

# Get stuff
[ -e $packagedir/irrlicht-$irrlicht_version.zip ] || wget http://sfan5.pf-control.de/irrlicht-$irrlicht_version-win32.zip \
	-c -O $packagedir/irrlicht-$irrlicht_version.zip
[ -e $packagedir/zlib-$zlib_version.zip ] || wget http://sfan5.pf-control.de/zlib-$zlib_version-win32.zip \
	-c -O $packagedir/zlib-$zlib_version.zip
[ -e $packagedir/libogg-$ogg_version-dev.7z ] || wget http://sfan5.pf-control.de/libogg-$ogg_version-dev.7z \
	-c -O $packagedir/libogg-$ogg_version-dev.7z
[ -e $packagedir/libogg-$ogg_version-dll.7z ] || wget http://sfan5.pf-control.de/libogg-$ogg_version-dll.7z \
	-c -O $packagedir/libogg-$ogg_version-dll.7z
[ -e $packagedir/libvorbis-$vorbis_version-dev.7z ] || wget http://sfan5.pf-control.de/libvorbis-$vorbis_version-dev.7z \
	-c -O $packagedir/libvorbis-$vorbis_version-dev.7z
[ -e $packagedir/libvorbis-$vorbis_version-dll.7z ] || wget http://sfan5.pf-control.de/libvorbis-$vorbis_version-dll.7z \
	-c -O $packagedir/libvorbis-$vorbis_version-dll.7z
[ -e $packagedir/libcurl-$curl_version.zip ] || wget http://sfan5.pf-control.de/libcurl-$curl_version-win32.zip \
	-c -O $packagedir/libcurl-$curl_version.zip
[ -e $packagedir/gettext-$gettext_version.zip ] || wget http://sfan5.pf-control.de/gettext-$gettext_version.zip \
	-c -O $packagedir/gettext-$gettext_version.zip
[ -e $packagedir/libfreetype-$freetype_version.zip ] || wget http://sfan5.pf-control.de/libfreetype-$freetype_version-win32.zip \
	-c -O $packagedir/libfreetype-$freetype_version.zip
[ -e $packagedir/sqlite3-$sqlite3_version.zip ] || wget http://sfan5.pf-control.de/sqlite3-$sqlite3_version-win32.zip \
	-c -O $packagedir/sqlite3-$sqlite3_version.zip
[ -e $packagedir/luajit-$luajit_version-static-win32.zip ] || wget http://sfan5.pf-control.de/luajit-$luajit_version-static-win32.zip \
	-c -O $packagedir/luajit-$luajit_version-static-win32.zip
[ -e $packagedir/libleveldb-$leveldb_version-win32.zip ] || wget http://sfan5.pf-control.de/libleveldb-$leveldb_version-win32.zip \
	-c -O $packagedir/libleveldb-$leveldb_version-win32.zip
[ -e $packagedir/openal_stripped.zip ] || wget http://sfan5.pf-control.de/openal_stripped.zip \
	-c -O $packagedir/openal_stripped.zip

# Extract stuff
cd $libdir
[ -d irrlicht-$irrlicht_version ] || unzip -o $packagedir/irrlicht-$irrlicht_version.zip
[ -d zlib ] || unzip -o $packagedir/zlib-$zlib_version.zip -d zlib
[ -d libogg/include ] || 7z x -y -olibogg $packagedir/libogg-$ogg_version-dev.7z
[ -d libogg/bin ] || 7z x -y -olibogg $packagedir/libogg-$ogg_version-dll.7z
[ -d libvorbis/include ] || 7z x -y -olibvorbis $packagedir/libvorbis-$vorbis_version-dev.7z
[ -d libvorbis/bin ] || 7z x -y -olibvorbis $packagedir/libvorbis-$vorbis_version-dll.7z
[ -d libcurl ] || unzip -o $packagedir/libcurl-$curl_version.zip -d libcurl
[ -d gettext ] || unzip -o $packagedir/gettext-$gettext_version.zip -d gettext
[ -d freetype ] || unzip -o $packagedir/libfreetype-$freetype_version.zip -d freetype
[ -d sqlite3 ] || unzip -o $packagedir/sqlite3-$sqlite3_version.zip -d sqlite3
[ -d openal_stripped ] || unzip -o $packagedir/openal_stripped.zip
[ -d luajit ] || unzip -o $packagedir/luajit-$luajit_version-static-win32.zip -d luajit
[ -d leveldb ] || unzip -o $packagedir/libleveldb-$leveldb_version-win32.zip -d leveldb

# Get magichet

cd $builddir
echo Removing leftovers...
rm -rf $builddir/magichet

echo Copying most recent version...
mkdir $builddir/magichet

echo builtin...
mkdir $builddir/magichet/builtin
cp -rf $builddir/../../../builtin $builddir/magichet

echo client...
mkdir $builddir/magichet/client
cp -rf $builddir/../../../client $builddir/magichet

echo cmake files...
mkdir $builddir/magichet/cmake
cp -rf $builddir/../../../cmake $builddir/magichet

echo docs...
mkdir $builddir/magichet/doc
cp -rf $builddir/../../../doc $builddir/magichet

echo fonts...
mkdir $builddir/magichet/fonts
cp -rf $builddir/../../../fonts $builddir/magichet

echo magichet subgame...
mkdir $builddir/magichet/games
mkdir $builddir/magichet/games/magichet
cp -rf $builddir/../../../games/magichet $builddir/magichet/games

echo misc files...
mkdir $builddir/magichet/misc
cp -rf $builddir/../../../misc $builddir/magichet
cp -rf $builddir/../../../magichet.conf.example $builddir/magichet/magichet.conf.example
cp -rf $builddir/../../../README.txt $builddir/magichet/README.txt

echo translations...
mkdir $builddir/magichet/po
cp -rf $builddir/../../../po $builddir/magichet

echo textures...
cp -rf $builddir/../../../textures $builddir/magichet

echo sources...
mkdir $builddir/magichet/src
cp -rf $builddir/../../../src $builddir/magichet/
cp -rf $builddir/../../../CMakeLists.txt $builddir/magichet/CMakeLists.txt



git_hash="1.2.1"

# Build the thing
cd $builddir/magichet
[ -d _build ] && rm -Rf _build/
mkdir _build
cd _build
export LDFLAGS=-m32
cmake .. \
	-DCMAKE_INSTALL_PREFIX=/tmp \
	-DVERSION_EXTRA=$git_hash \
	-DBUILD_CLIENT=1 -DBUILD_SERVER=1 \
	-DCMAKE_TOOLCHAIN_FILE=$toolchain_file \
	-DCMAKE_C_FLAGS=-m32 -DCMAKE_CXX_FLAGS=-m32 \
	\
	-DENABLE_SOUND=1 \
	-DENABLE_CURL=1 \
	-DENABLE_GETTEXT=1 \
	-DENABLE_FREETYPE=1 \
	-DENABLE_LEVELDB=1 \
	\
	-DIRRLICHT_INCLUDE_DIR=$libdir/irrlicht-$irrlicht_version/include \
	-DIRRLICHT_LIBRARY=$libdir/irrlicht-$irrlicht_version/lib/Win32-gcc/libIrrlicht.dll.a \
	-DIRRLICHT_DLL=$libdir/irrlicht-$irrlicht_version/bin/Win32-gcc/Irrlicht.dll \
	\
	-DZLIB_INCLUDE_DIR=$libdir/zlib/include \
	-DZLIB_LIBRARIES=$libdir/zlib/lib/zlibwapi.dll.a \
	-DZLIB_DLL=$libdir/zlib/bin/zlib1.dll \
	-DZLIBWAPI_DLL=$libdir/zlib/bin/zlibwapi.dll \
	\
	-DLUA_INCLUDE_DIR=$libdir/luajit/include \
	-DLUA_LIBRARY=$libdir/luajit/libluajit.a \
	\
	-DOGG_INCLUDE_DIR=$libdir/libogg/include \
	-DOGG_LIBRARY=$libdir/libogg/lib/libogg.dll.a \
	-DOGG_DLL=$libdir/libogg/bin/libogg-0.dll \
	\
	-DVORBIS_INCLUDE_DIR=$libdir/libvorbis/include \
	-DVORBIS_LIBRARY=$libdir/libvorbis/lib/libvorbis.dll.a \
	-DVORBIS_DLL=$libdir/libvorbis/bin/libvorbis-0.dll \
	-DVORBISFILE_LIBRARY=$libdir/libvorbis/lib/libvorbisfile.dll.a \
	-DVORBISFILE_DLL=$libdir/libvorbis/bin/libvorbisfile-3.dll \
	\
	-DOPENAL_INCLUDE_DIR=$libdir/openal_stripped/include/AL \
	-DOPENAL_LIBRARY=$libdir/openal_stripped/lib/libOpenAL32.dll.a \
	-DOPENAL_DLL=$libdir/openal_stripped/bin/OpenAL32.dll \
	\
	-DCURL_DLL=$libdir/libcurl/bin/libcurl-4.dll \
	-DCURL_INCLUDE_DIR=$libdir/libcurl/include \
	-DCURL_LIBRARY=$libdir/libcurl/lib/libcurl.dll.a \
	\
	-DCUSTOM_GETTEXT_PATH=$libdir/gettext \
	-DGETTEXT_MSGFMT=`which msgfmt` \
	-DGETTEXT_DLL=$libdir/gettext/bin/libintl3.dll \
	-DGETTEXT_ICONV_DLL=$libdir/gettext/bin/libiconv2.dll \
	-DGETTEXT_INCLUDE_DIR=$libdir/gettext/include \
	-DGETTEXT_LIBRARY=$libdir/gettext/lib/libintl.dll.a \
	\
	-DFREETYPE_INCLUDE_DIR_freetype2=$libdir/freetype/include/freetype2 \
	-DFREETYPE_INCLUDE_DIR_ft2build=$libdir/freetype/include \
	-DFREETYPE_LIBRARY=$libdir/freetype/lib/libfreetype.dll.a \
	-DFREETYPE_DLL=$libdir/freetype/bin/freetype6.dll \
	\
	-DSQLITE3_INCLUDE_DIR=$libdir/sqlite3/include \
	-DSQLITE3_LIBRARY=$libdir/sqlite3/lib/libsqlite3.dll.a \
	-DSQLITE3_DLL=$libdir/sqlite3/bin/libsqlite3-0.dll \
	\
	-DLEVELDB_INCLUDE_DIR=$libdir/leveldb/include \
	-DLEVELDB_LIBRARY=$libdir/leveldb/lib/libleveldb.dll.a \
	-DLEVELDB_DLL=$libdir/leveldb/bin/libleveldb.dll

make package -j4

# EOF
