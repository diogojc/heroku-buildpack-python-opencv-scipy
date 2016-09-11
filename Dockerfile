# Base image heroku cedar stack v14
FROM heroku/cedar:14


# Make folder structure
RUN mkdir /app
RUN mkdir /app/.heroku
RUN mkdir /app/.heroku/vendor
ENV LD_LIBRARY_PATH /app/.heroku/vendor/lib/


# Install ATLAS with LAPACK and BLAS
WORKDIR /app/.heroku
RUN apt-get update
RUN apt-get install -y gfortran
RUN curl -s -L http://www.netlib.org/lapack/lapack-3.6.1.tgz > lapack-3.6.1.tgz
RUN curl -s -L http://netix.dl.sourceforge.net/project/math-atlas/Stable/3.10.3/atlas3.10.3.tar.bz2 > /app/.heroku/atlas3.10.3.tar.bz2
RUN bunzip2 -c atlas3.10.3.tar.bz2 | tar xfm -
RUN mkdir /app/.heroku/ATLAS/Linux_C2D64SSE3
WORKDIR /app/.heroku/ATLAS/Linux_C2D64SSE3
RUN ../configure -b 64 -D c -DPentiumCPS=2400 \
     --prefix=/app/.heroku/vendor/ \
     --with-netlib-lapack-tarfile=/app/.heroku/lapack-3.6.1.tgz
RUN make build && make check && make ptcheck && make time && make install
WORKDIR /app/.heroku
RUN rm lapack-3.6.1.tgz
RUN rm atlas3.10.3.tar.bz2
RUN rm -r ATLAS
ENV ATLAS /app/.heroku/vendor/lib/libatlas.a
ENV BLAS /app/.heroku/vendor/lib/libcblas.a
ENV LAPACK /app/.heroku/vendor/lib/liblapack.a


# Install Python 2.7.10
RUN apt-get remove -y python2.7
RUN apt-get remove -y python3.4
RUN apt-get remove -y python2.7-minimal
RUN apt-get remove -y python3.4-minimal
RUN apt-get remove -y libpython2.7-minimal
RUN apt-get remove -y libpython3.4-minimal

RUN curl -s -L http://kent.dl.sourceforge.net/project/tcl/Tcl/8.6.6/tcl8.6.6-src.tar.gz > tcl8.6.6-src.tar.gz
RUN tar -xvf tcl8.6.6-src.tar.gz
RUN rm tcl8.6.6-src.tar.gz
WORKDIR /app/.heroku/tcl8.6.6/unix
RUN ./configure --prefix=/app/.heroku/vendor/
RUN make && make install
WORKDIR /app/.heroku/
RUN curl -s -L http://heanet.dl.sourceforge.net/project/tcl/Tcl/8.6.6/tk8.6.6-src.tar.gz > tk8.6.6-src.tar.gz
RUN tar -xvf tk8.6.6-src.tar.gz
RUN rm tk8.6.6-src.tar.gz
WORKDIR /app/.heroku/tk8.6.6/unix
RUN ./configure --prefix=/app/.heroku/vendor/ --with-tcl=/app/.heroku/tcl8.6.6/unix
RUN make && make install
WORKDIR /app/.heroku/
RUN rm -r tcl8.6.6
RUN rm -r tk8.6.6


RUN curl -s -L https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz > Python-2.7.10.tgz
RUN tar zxvf Python-2.7.10.tgz
RUN rm Python-2.7.10.tgz
WORKDIR /app/.heroku/Python-2.7.10
RUN ./configure --prefix=/app/.heroku/vendor/ --enable-shared --with-tcltk-includes="-I/app/.heroku/vendor/include" --with-tcltk-libs="-L/app/.heroku/vendor/lib -ltcl8.6.6 -L/app/.heroku/vendor/lib -ltk8.6.6"
RUN make install
WORKDIR /app/.heroku
RUN rm -rf Python-2.7.10
ENV PATH /app/.heroku/vendor/bin:$PATH
ENV PYTHONPATH /app/.heroku/vendor/lib/python2.7/site-packages


# Install latest setup-tools and pip
RUN curl -s -L https://bootstrap.pypa.io/get-pip.py > get-pip.py
RUN python get-pip.py
RUN rm get-pip.py


# Install Numpy
RUN pip install -v numpy==1.11.1


# Install Scipy
RUN pip install -v scipy==0.18.0


# Install Matplotlib
RUN pip install -v matplotlib==1.5.3


# Install Opencv with python bindings
RUN apt-get install -y cmake
RUN curl -s -L https://github.com/Itseez/opencv/archive/2.4.11.zip > opencv-2.4.11.zip
RUN unzip opencv-2.4.11.zip
RUN rm opencv-2.4.11.zip
WORKDIR /app/.heroku/opencv-2.4.11
RUN cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/app/.heroku/vendor -D BUILD_DOCS=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_EXAMPLES=OFF -D BUILD_opencv_python=ON .
RUN make install
WORKDIR /app/.heroku
RUN rm -rf opencv-2.4.11


# Create vendor package
WORKDIR /app/
RUN tar cvfj /vendor.tar.bz2 .
VOLUME /vendoring
CMD cp /vendor.tar.bz2 /vendoring
