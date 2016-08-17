FROM rsrchboy/perl-v5.16
MAINTAINER Xinjiang Shao <shaoxinjiang@gmail.com>

RUN apt-get update \
    && apt-get install -y git libssl-dev \
    && rm -fr /var/lib/apt/lists/*

# Install cpanminus
RUN perlbrew install-cpanm 

RUN perl -v
RUN cpanm --version

# Install DuckPAN
RUN cpanm --notest --skip-installed --mirror http://www.cpan.org/ --mirror http://duckpan.org Dist::Zilla

RUN cpanm --notest --skip-installed --mirror http://www.cpan.org/ --mirror http://duckpan.org App::DuckPAN 

RUN duckpan check

# Clean out downloaded modules.
RUN rm -r /root/.cpanm/latest-build/*

WORKDIR /home/ddg
VOLUME /home/ddg
EXPOSE 5000