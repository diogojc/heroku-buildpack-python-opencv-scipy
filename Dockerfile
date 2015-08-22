# Base image heroku cedar stack v14
FROM heroku/cedar:14


# Make folder structure
RUN mkdir /app
RUN mkdir /app/.heroku
RUN mkdir /app/.heroku/vendor
WORKDIR /app/.heroku


# Install python 2.7.10
RUN curl -s -L https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz > Python-2.7.10.tgz
RUN tar zxvf Python-2.7.10.tgz
RUN rm Python-2.7.10.tgz
WORKDIR /app/.heroku/Python-2.7.10
RUN ./configure --prefix=/app/.heroku/vendor/
RUN make install
ENV PATH /app/.heroku/vendor/bin:$PATH
WORKDIR /app/.heroku
RUN rm -rf Python-2.7.10


# Install latest setup-tools and pip
RUN curl -s -L https://bootstrap.pypa.io/get-pip.py > get-pip.py
RUN python get-pip.py
RUN rm get-pip.py


# install numpy
RUN pip install numpy


# install scipy
RUN curl -s -L https://db.tt/osV4nSh0 > npscipy.tar.gz
RUN tar zxvf npscipy.tar.gz
RUN rm npscipy.tar.gz
ENV ATLAS /app/.heroku/vendor/lib/atlas-base/libatlas.a
ENV BLAS /app/.heroku/vendor/lib/atlas-base/atlas/libblas.a
ENV LAPACK /app/.heroku/vendor/lib/atlas-base/atlas/liblapack.a
ENV LD_LIBRARY_PATH /app/.heroku/vendor/lib:/app/.heroku/vendor/lib/atlas-base:/app/.heroku/vendor/lib/atlas-base/atlas
RUN apt-get update
RUN apt-get install -y gfortran
RUN pip install scipy


# install matplotlib
RUN pip install matplotlib


# install opencv with python bindings
RUN apt-get install -y cmake
RUN curl -s -L https://github.com/Itseez/opencv/archive/3.0.0.zip > opencv-3.0.0.zip
RUN unzip opencv-3.0.0.zip
RUN rm opencv-3.0.0.zip
WORKDIR /app/.heroku/opencv-3.0.0
RUN cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/app/.heroku/vendor -D BUILD_DOCS=OFF -D BUILD_TESTS=OFF -D BUILD_SHARED_LIBS=OFF -D BUILD_PYTHON_SUPPORT=ON -D BUILD_EXAMPLES=OFF .
RUN make install
WORKDIR /app/.heroku
RUN rm -rf opencv-3.0.0
ENV PYTHONPATH /app/.heroku/vendor/lib/python2.7/site-packages/



