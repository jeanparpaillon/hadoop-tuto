#!/usr/bin/make -f
#
# Install hadoop
#
hadoopfile = hadoop-1.2.0-bin.tar.gz
hadoopurl = http://apache.crihan.fr/dist/hadoop/common/hadoop-1.2.0/$(hadoopfile)

archivebaseurl = http://dumps.wikimedia.org/frwiki/20130601
archives = frwiki-20130601-pages-articles-multistream-index.txt frwiki-20130601-pages-articles-multistream.xml

all: hadoop-1.2.0 $(archives)

%.txt: %.txt.bz2
	bunzip2 $<

%.xml: %.xml.bz2
	bunzip2 $<

%.bz2:
	wget -c $(archivebaseurl)/$@

hadoop-1.2.0: $(hadoopfile)
	tar xf $<

$(hadoopfile):
	wget $(hadoopurl)

.PHONY: all data
