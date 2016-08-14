FROM vvoronin/ubuntu-tools
MAINTAINER Xinjiang Shao <shaoxinjiang@gmail.com>

RUN /tools/apt build-essential wget git libssl-dev nodejs npm

# Install Perl
ENV TARGET_PERL_FULL 5.16.3
ENV TARGET_PERL      5.16
ENV TARGET_PERLBREW  0.76

ENV PERLBREW_ROOT=/perl5

RUN bash -c '\wget -O - http://install.perlbrew.pl | bash' &&\
        /perl5/bin/perlbrew init &&\
        /perl5/bin/perlbrew install -j 4 perl-$TARGET_PERL_FULL &&\
        /perl5/bin/perlbrew install-cpanm &&\
        /perl5/bin/perlbrew switch perl-$TARGET_PERL_FULL
        
ENV PERLBREW_ROOT=/perl5 \
    PATH=/perl5/bin:/perl5/perls/perl-$TARGET_PERL_FULL/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    PERLBREW_PERL=perl-$TARGET_PERL_FULL \
    PERLBREW_VERSION=$TARGET_PERLBREW \
    PERLBREW_MANPATH=/perl5/perls/perl-$TARGET_PERL_FULL/man \
    PERLBREW_PATH=/perl5/bin:/perl5/perls/perl-$TARGET_PERL_FULL/bin \
    PERLBREW_SKIP_INIT=1

RUN perlbrew info
RUN perl -v
RUN cpanm --version

# Install DuckPAN
RUN cpanm --notest --mirror http://www.cpan.org/ --mirror http://duckpan.org Term::ReadKey@2.32

# RUN useradd -ms /bin/bash ddg
# USER ddg
# WORKDIR /home/ddg
# ENV USER ddg

RUN cpanm --notest --skip-installed --mirror http://www.cpan.org/ --mirror http://duckpan.org App::DuckPAN 

# Clone repositories and install their dependencies
RUN git clone https://github.com/duckduckgo/zeroclickinfo-goodies.git
RUN cd zeroclickinfo-goodies &&\
    npm install -g uglify-js handlebars &&\
    cpanm --notest Dist::Zilla &&\
    dzil authordeps | grep -ve '^\W' | xargs -n 5 -P 10 cpanm --notest --mirror http://www.cpan.org/ --mirror http://duckpan.org &&\
    dzil listdeps | grep -ve '^\W' | cpanm --mirror http://www.cpan.org/ --mirror http://duckpan.org &&\
    cd .. && rm -rf zeroclickinfo-goodies

RUN git clone https://github.com/duckduckgo/zeroclickinfo-spice.git
RUN cd zeroclickinfo-spice &&\
    npm install -g uglify-js handlebars &&\
    cpanm --notest Dist::Zilla &&\
    dzil authordeps | grep -ve '^\W' | xargs -n 5 -P 10 cpanm --notest --mirror http://www.cpan.org/ --mirror http://duckpan.org &&\
    dzil listdeps | grep -ve '^\W' | cpanm --mirror http://www.cpan.org/ --mirror http://duckpan.org &&\
    cd .. && rm -rf zeroclickinfo-spice

RUN git clone https://github.com/duckduckgo/zeroclickinfo-fathead.git
RUN cd zeroclickinfo-fathead &&\
    dzil authordeps | grep -ve '^\W' | xargs -n 5 -P 10 cpanm --notest --mirror http://www.cpan.org/ --mirror http://duckpan.org &&\
    dzil listdeps | grep -ve '^\W' | cpanm --mirror http://www.cpan.org/ --mirror http://duckpan.org &&\
    cd .. && rm -rf zeroclickinfo-fathead

RUN duckpan check
# Clean out downloaded modules.
RUN rm -r /root/.cpanm/latest-build/*

WORKDIR /home/ddg
VOLUME /home/ddg
EXPOSE 5000


