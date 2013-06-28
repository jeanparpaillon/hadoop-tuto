#!/usr/bin/make -f
#
# Install hadoop
#
hadoopurl=http://apache.crihan.fr/dist/hadoop/common/hadoop-1.2.0/hadoop-1.2.0-bin.tar.gz

all: hadoop-1.2.0

hadoop-1.2.0: hadoop-1.2.0-bin.tar.gz
	tar xf $<

hadoop-1.2.0-bin.tar.gz:
	wget $(hadoopurl)
