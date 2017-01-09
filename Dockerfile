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

RUN apt-get install -y curl grep sed dpkg git xvfb && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

ADD https://github.com/mozilla/geckodriver/releases/download/v0.12.0/geckodriver-v0.12.0-linux64.tar.gz /usr/local/bin/
#RUN wget --quiet  -O ~/geckodriver.tar.gz && \
    #tar -xvf ~/geckodriver.tar.gz
    #rm ~/geckodriver.tar.gz \
    #mv ~/geckodriver /bin/geckodriver

#RUN curl "https://gist.githubusercontent.com/amberj/6695353/raw/d7d981379c9602e6323d09a90d6a84cd3e3177a2/setup-headless-selenium-xvfb.sh"
    #/bin/bash setup-headless-selenium-xvfb.sh

ENV PATH /opt/conda/bin:$PATH


ENTRYPOINT [ "/usr/bin/tini", "--" ]
RUN [ "/bin/bash" ]
CMD [ "/bin/bash" ]

#RUN conda install numpy pandas scipy theano h5py pytables pillow html5lib -y
#RUN conda install -c anaconda beautifulsoup4 lxml=3.7.0 -y
#RUN conda install -c conda-forge tensorflow=0.10.0 -y
RUN pip install selenium xvfbwrapper PyVirtualDisplay #keras==1.1.1

CMD [ "/bin/bash" ]

COPY . /docker_conda
WORKDIR /docker_conda

RUN python test.py

