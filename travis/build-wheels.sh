#!/bin/bash
set +e
echo 'Begin build-wheel...'
export PYTHON_VERSION=`python -c 'import sys; version=sys.version_info[:3]; print("{0}.{1}.{2}".format(*version))'`
echo 'PYTHON_VERSION: '$PYTHON_VERSION

# Begin build
echo 'Begin build'
cd htcondor
mkdir -p _build; PREFIX=$PWD/_build

cmake28 -DPROPER:BOOL=FALSE \
      -DCLIPPED:BOOL=TRUE \
      -DWITH_BLAHP:BOOL=FALSE \
      -DWITH_COREDUMPER:BOOL=FALSE \
      -DWITH_CREAM:BOOL=FALSE \
      -DWITH_DRMAA:BOOL=FALSE \
      -DWITH_GLOBUS:BOOL=FALSE \
      -DWITH_GSOAP:BOOL=FALSE \
      -DWITH_HADOOP:BOOL=FALSE \
      -DWITH_LIBVIRT:BOOL=FALSE \
      -DWITH_LIBXML2:BOOL=FALSE \
      -DWITH_UNICOREGAHP:BOOL=FALSE \
      -DWITH_VOMS:BOOL=FALSE \
      -DWITH_BOINC:BOOL=FALSE \
      -DWITH_LIBCGROUP:BOOL=FALSE \
      -DWITH_GANGLIA:BOOL=FALSE \
      -DWITH_CAMPUSFACTORY:BOOL=FALSE \
      -DWITH_BOSCO:BOOL=FALSE \
      -DWANT_GLEXEC:BOOL=FALSE \
      -DBUILD_TESTING:BOOL=FALSE \
      -DWITH_QPID:BOOL=FALSE \
      -DWITH_LIBDELTACLOUD:BOOL=FALSE \
      -DUW_BUILD:BOOL=FALSE \
      -D_VERBOSE:BOOL=TRUE \
      -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DCMAKE_PREFIX_PATH="${PREFIX}" \
      -DPYTHONLIBS_VERSION_STRING="${PYTHON_VERSION}" \
      -DPYTHON_VERSION_STRING=$(python -c "from platform import python_version; print(python_version())") \
      -DPYTHON_INCLUDE_PATH=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
      -DPYTHON_LIBRARY=$(python -c "from distutils.sysconfig import get_config_var; import os; print(os.path.join(get_config_var('LIBDIR'), get_config_var('LDLIBRARY')))")


make -j4
make install


# Moving back to htcondor-python
cd ../

echo 'Copying *.so'
cp $PREFIX/lib/python/*.so htc/.

# Build wheel
echo 'Build wheel'
pip wheel . -w /io/wheelhouse/
