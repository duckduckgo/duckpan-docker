FROM ubuntu:12.04
MAINTAINER Jag Talon <jag@duckduckgo.com>

# Get the latest list of packages.
RUN apt-get update
RUN apt-get install -y build-essential curl git perl

# Create directories.
RUN mkdir -p /root /usr/local/perlbrew

# Set env variables.
RUN umask 0022
ENV HOME /root
ENV PERLBREW_ROOT /usr/local/perlbrew
ENV PERLBREW_HOME /root/.perlbrew

# Install Perlbrew
RUN curl -L http://install.perlbrew.pl | bash
ENV PATH /usr/local/perlbrew/bin:$PATH
ENV PERLBREW_PATH /usr/local/perlbrew/bin
RUN perlbrew install-cpanm

# Install Perl
ENV TARGET_PERL_FULL 5.16.3
ENV TARGET_PERL      stable

RUN perlbrew download $TARGET_PERL_FULL
RUN perlbrew install --notest -j10 --as $TARGET_PERL $TARGET_PERL_FULL && rm -rf /usr/local/perlbrew/build/*

RUN perlbrew switch $TARGET_PERL

ENV PATH /usr/local/perlbrew/perls/$TARGET_PERL/bin:$PATH
ENV MANPATH /usr/local/perlbrew/perls/$TARGET_PERL/man
ENV PERLBREW_MANPATH /usr/local/perlbrew/perls/$TARGET_PERL/man
ENV PERLBREW_PATH /usr/local/perlbrew/bin:/usr/local/perlbrew/perls/$TARGET_PERL/bin
ENV PERLBREW_PERL $TARGET_PERL

RUN perlbrew info
RUN perl -v

# Install DuckPAN
RUN apt-get install -y libssl-dev
RUN cpanm -n App::DuckPAN

# Clone repositories and install their dependencies
RUN git clone https://github.com/duckduckgo/zeroclickinfo-goodies.git
RUN cd zeroclickinfo-goodies && duckpan installdeps && cd .. && rm -rf zeroclickinfo-goodies

RUN git clone https://github.com/duckduckgo/zeroclickinfo-spice.git
RUN cd zeroclickinfo-spice && duckpan installdeps && cd .. && rm -rf zeroclickinfo-spice

RUN duckpan DDG

# Clean out downloaded modules.
RUN rm -r /root/.cpanm/latest-build/*