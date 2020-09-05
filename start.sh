#!/bin/bash
##author: arthurtibame
##GitHub: https://github.com/arthurtibame

## Some configure fucntions and variables
get_script_dir () {
     SOURCE="${BASH_SOURCE[0]}"
     # While $SOURCE is a symlink, resolve it
     while [ -h "$SOURCE" ]; do
          DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
          SOURCE="$( readlink "$SOURCE" )"
          # If $SOURCE was a relative symlink (so no "/" as prefix, need to resolve it relative to the symlink base directory
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
     done
     DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
     echo "$DIR"
}


PASSWORD=$(awk -F'[<>]' '/<password>/{print $3}' $(get_script_dir)/utils/configure.xml)
CONFIGURE_PATH=$(get_script_dir)/conf
BASE_PATH=/home/$USER
JAVA_VERSION=1.8.0_261
SCALA_VERSION=2.12.11
HADOOP_VERSION=2.10.0
SPARK_VERSION=2.4.6
HADOOP_PATH=$BASE_PATH/hadoop-$HADOOP_VERSION
SPARK_PATH=$BASE_PATH/spark-$SPARK_VERSION-bin-hadoop2.7


##### start install 
echo $PASSWORD | sudo -S apt-get update -y &&\
echo $PASSWORD | sudo apt-get upgrade -y;

#DOWDLOAD packages
wget http://apache.stu.edu.tw/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
wget http://apache.stu.edu.tw/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz 
wget https://downloads.lightbend.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz

#EXTRACT FILES
tar -zxvf $(get_script_dir)/hadoop-$HADOOP_VERSION.tar.gz
tar -zxvf $(get_script_dir)/spark-$VERSION-bin-hadoop2.7.tgz 
tar -zxvf $(get_script_dir)/scala-$SCALA_VERSION.tgz
tar -zxvf $(get_script_dir)/jdk-8u261-linux-x64.tar.gz

#REMOBE all file
rm -rf *.t*

#COPY CONGIURE to each file
cp -r $CONFIGURE_PATH/hadoop-2.10.0/* $(get_script_dir)/hadoop-$HADOOP_VERSION/
cp -r $CONFIGURE_PATH/spark-2.4.6-bin-hadoop2.7/* $(get_script_dir)/spark-$SPARK_VERSION-bin-hadoop2.7/
echo "COPY CONFIGURE COMPLETED"

#move all dirs to BASE PATH
mv $(get_script_dir)/spark-$SPARK_VERSION-bin-hadoop2.7/ $BASE_PATH/ && \
mv $(get_script_dir)/hadoop-$HADOOP_VERSION/ $BASE_PATH/ && \
mv $(get_script_dir)/jdk$JAVA_VERSION $BASE_APTH/ $BASE_PATH/ && \
mv $(get_script_dir)/scala-$SCALA_VERSION/ $BASE_PATH/ && \

echo "MOVED ALL DIRS to /home/$USER"

#ADD ENV to PATH
echo "ADD JAVA_HOME"
export JAVA_HOME=$BASE_PATH/jdf$JAVA_VERSION
export PATH=$JAVA_HOME/bin:$PATH

echo "ADD SCALA_HOME"
export SCALA_HOME=$BASE_PATH/scala-$SCALA_VERSION
export PATH=$SCALA_HOME/bin:$PATH

echo "ADD HADOOP_HOME"
export HADOOP_HOME=$BASE_PATH/hadoop-$HADOOP_VERSION
export PATH=$HADOOP_HOME/bin:$PATH

echo "ADD SPARK_HOME"
export SPARK_HOME=$BASE_PATH/spark-$SPARK_VERSION-bin-hadoop2.7
export PATH=$SPARK_HOME/bin:$PATH
