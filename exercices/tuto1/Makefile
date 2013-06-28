TOPDIR=$(abspath $(CURDIR)/../..)
HADOOP_VERSION=1.2.0
HADOOP_HOME=$(TOPDIR)/hadoop-$(HADOOP_VERSION)

CLASSPATH=$(HADOOP_HOME)/hadoop-core-$(HADOOP_VERSION).jar
JAR=tuto1.jar

OUTPUT=/user/$(shell id -u -n)/output/tuto1

all: $(JAR)

$(JAR): cls/org/silkan/data/WordCount.class
	jar -cvf $@ -C cls/ .

cls/org/silkan/data/WordCount.class: WordCount.java
	mkdir -p cls
	javac -classpath $(CLASSPATH) -d cls $<

run: all
	-$(HADOOP_HOME)/bin/hadoop fs -rm $(OUTPUT)
	$(HADOOP_HOME)/bin/hadoop jar $(JAR) org.silkan.data.WordCount /user/parpaillonj/input $(OUTPUT)

clean:
	rm -f *~ 
	rm -fr cls
	rm -f $(JAR)

.PHONY: all run clean
