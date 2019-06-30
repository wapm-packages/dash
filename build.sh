#!/usr/bin/env sh

DASH_VERSION=0.5.10.2

rm -rf dash-*
wget https://git.kernel.org/pub/scm/utils/dash/dash.git/snapshot/dash-${DASH_VERSION}.tar.gz
tar xf dash-${DASH_VERSION}.tar.gz
cd dash-${DASH_VERSION}

echo "Configure"
./autogen.sh

emconfigure ./configure \
  --build=`gcc -dumpmachine` \
  --disable-dependency-tracking \
  --enable-static \
  --host=wasm32 \
  || exit $?

echo "Build"
emmake make -j || exit $?

# Generate `.wasm` files
echo "Link"
mv src/dash src/dash.bc
emcc src/dash.bc -o ../dash.wasm -s ERROR_ON_UNDEFINED_SYMBOLS=0

echo "Clean"
cd ..
rm -rf dash-*

echo "Add executable permissions"
chmod +x dash.wasm

echo "Done"
