# Ubuntu 16.04 base image
FROM ubuntu:16.04 
MAINTAINER Roman Milovanov <rmilovanov@gmail.com> 

# Update packages and install basics 
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y dist-upgrade
RUN apt-get -y autoremove


# Update packages and install basics 
RUN apt-get install -y \
	wget \
	unzip \
	git

# Install dependencies 
RUN apt-get install -y build-essential libgtk2.0-dev cmake python-dev python-numpy libeigen3-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev default-jdk ant libvtk5-qt4-dev

# Parallelism and linear algebra libraries:
RUN apt-get install -y libtbb-dev libeigen3-dev

# Install pip 
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py && rm get-pip.py
RUN pip install --upgrade pip


# 3. INSTALL THE LIBRARY (YOU CAN CHANGE '3.2.0' FOR THE LAST STABLE VERSION)

WORKDIR /tmp
RUN wget https://github.com/opencv/opencv/archive/3.2.0.zip
RUN unzip 3.2.0.zip 
RUN rm 3.2.0.zip 
RUN mv opencv-3.2.0 /tmp/OpenCV
WORKDIR /tmp/OpenCV
RUN mkdir build
WORKDIR /tmp/OpenCV/build
RUN cmake -DWITH_QT=ON -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON -DWITH_XINE=ON -DBUILD_EXAMPLES=ON ..
RUN make -j4
RUN make install
RUN ldconfig

RUN apt-get -y install libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev
RUN pip install Pillow
