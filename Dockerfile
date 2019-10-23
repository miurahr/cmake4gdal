FROM miurahr/ubuntu-gdal-dev:latest
MAINTAINER Hiroshi Miura <miurahr@linux.com>

RUN (mkdir /home/user && cd /home/user && git clone https://github.com/osgeo/gdal.git && mkdir -p gdal/cmake4gdal)
COPY . /home/user/gdal/cmake4gdal/
RUN python /home/user/gdal/cmake4gdal/deploy.py

WORKDIR /home/user/gdal
