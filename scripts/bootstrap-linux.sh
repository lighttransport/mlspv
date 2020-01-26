curdir=`pwd`
DESTDIR=dist
BUILDDIR=build

rm -rf ${BUILDDIR}
mkdir ${BUILDDIR}
cd ${BUILDDIR}

cmake -G Ninja \
  -DCMAKE_INSTALL_PREFIX=${DESTDIR} \
  ..
