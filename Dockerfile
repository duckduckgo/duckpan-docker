FROM rsrchboy/perl-v5.16
MAINTAINER Xinjiang Shao <shaoxinjiang@gmail.com>

RUN apt-get update \
    && apt-get install -y curl \
    git \
    libssl-dev \
    libmpfr-dev \
    nodejs \
    npm \
    nodejs-legacy \
    && rm -fr /var/lib/apt/lists/*
RUN npm install -g handlebars@1.3.0 uglifyjs
RUN cpanm --notest --mirror http://www.cpan.org/ --mirror http://duckpan.org Dist::Zilla

# Install DuckPAN 
RUN cpanm --notest --skip-installed --mirror http://www.cpan.org/ --mirror http://duckpan.org App::DuckPAN 

# Install Dependencies for Spice and Goodies
RUN git clone --depth=50 https://github.com/duckduckgo/zeroclickinfo-spice.git
RUN cd zeroclickinfo-spice &&\
    dzil authordeps | grep -ve '^\W' | xargs -n 5 -P 10 cpanm --skip-installed --notest --mirror http://www.cpan.org/ --mirror http://duckpan.org &&\        
    dzil listdeps | grep -ve '^\W'| cpanm --skip-installed --mirror http://www.cpan.org/ --mirror http://duckpan.org &&\
    cd .. && rm -rf zeroclickinfo-spice

RUN git clone --depth=50 https://github.com/duckduckgo/zeroclickinfo-goodies.git
RUN cd zeroclickinfo-goodies &&\
    dzil authordeps | grep -ve '^\W' | xargs -n 5 -P 10 cpanm --skip-installed --notest --mirror http://www.cpan.org/ --mirror http://duckpan.org &&\        
    dzil listdeps | grep -ve '^\W' | cpanm --skip-installed --mirror http://www.cpan.org/ --mirror http://duckpan.org &&\
    cd .. && rm -rf zeroclickinfo-goodies

# Clean out downloaded modules.
RUN rm -r /root/.cpanm/latest-build/*

WORKDIR /home/ddg
VOLUME /home/ddg
EXPOSE 5000