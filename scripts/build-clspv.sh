BUILDDIR=build-clspv

curdir=`pwd`
DESTDIR=${curdir}/dist

rm -rf ${BUILDDIR}
mkdir ${BUILDDIR}
cd ${BUILDDIR}

# optional. Specify path to python binary.
#  -DPYTHON_EXECUTABLE=/usr/bin/python

cmake -DCMAKE_BUILD_TYPE=MinSizeRel \
  -G Ninja \
  -DCMAKE_INSTALL_PREFIX=${DESTDIR} \
  ../third_party/clspv
  

