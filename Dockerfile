# Created on Dec, 18, 2016
# @author: Yvictor

FROM ubuntu:14.04
MAINTAINER yvictor

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing && apt-get install -y make g++ wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.1.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

ENV PATH /opt/conda/bin:$PATH


ENTRYPOINT [ "/usr/bin/tini", "--" ]
RUN [ "/bin/bash" ]
CMD [ "/bin/bash" ]

RUN conda install numpy pandas scipy theano h5py pytables pillow html5lib -y
RUN conda install -c anaconda beautifulsoup4 lxml=3.7.0 -y
RUN pip install keras==1.1.2

CMD [ "/bin/bash" ]
