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
JAVA_VERSION=1.8.0_131
SCALA_VERSION=2.12.11
HADOOP_VERSION=2.10.0
SPARK_VERSION=2.4.6
HADOOP_PATH=$BASE_PATH/hadoop-$HADOOP_VERSION
SPARK_PATH=$BASE_PATH/spark-$SPARK_VERSION-bin-hadoop2.7


##### start install 
echo $PASSWORD | sudo -S apt-get update -y && \
echo $PASSWORD | sudo apt-get upgrade -y && \
echo $PASSWORD | sudo apt install -y openssh-server  \
 
#DOWDLOAD packages
wget http://apache.stu.edu.tw/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
wget http://apache.stu.edu.tw/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz 
wget https://downloads.lightbend.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz

wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz

#EXTRACT FILES
tar -zxvf $(get_script_dir)/hadoop-$HADOOP_VERSION.tar.gz
tar -zxvf $(get_script_dir)/spark-$SPARK_VERSION-bin-hadoop2.7.tgz 
tar -zxvf $(get_script_dir)/scala-$SCALA_VERSION.tgz
tar -zxvf $(get_script_dir)/jdk-8u131-linux-x64.tar.gz

#REMOBE all file
rm -rf *.t*

#COPY CONGIURE to each file
cp -r $CONFIGURE_PATH/hadoop-2.10.0/* $(get_script_dir)/hadoop-$HADOOP_VERSION/
cp -r $CONFIGURE_PATH/spark-2.4.6-bin-hadoop2.7/conf $(get_script_dir)/spark-$SPARK_VERSION-bin-hadoop2.7/
echo "COPY CONFIGURE COMPLETED"

#move all dirs to BASE PATH
mv $(get_script_dir)/spark-$SPARK_VERSION-bin-hadoop2.7/ $BASE_PATH/ && \
mv $(get_script_dir)/hadoop-$HADOOP_VERSION/ $BASE_PATH/ && \
mv $(get_script_dir)/jdk$JAVA_VERSION $BASE_PATH/jdk1.8.0_261 && \
mv $(get_script_dir)/scala-$SCALA_VERSION/ $BASE_PATH/ && \

echo "MOVED ALL DIRS to /home/$USER"

#ADD ENV to PATH

echo export JAVA_HOME=$BASE_PATH/jdk$JAVA_VERSION >> $BASE_PATH/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> $BASE_PATH/.bashrc

#echo "ADD SCALA_HOME"
echo export SCALA_HOME=$BASE_PATH/scala-$SCALA_VERSION >> $BASE_PATH/.bashrc
echo 'export PATH="$SCALA_HOME/bin:$PATH"' >> $BASE_PATH/.bashrc

#echo "ADD HADOOP_HOME"
echo export HADOOP_HOME=$BASE_PATH/hadoop-$HADOOP_VERSION >> $BASE_PATH/.bashrc
echo 'export PATH="$HADOOP_HOME/bin:$PATH"' >> $BASE_PATH/.bashrc

#echo "ADD SPARK_HOME"
echo export SPARK_HOME=$BASE_PATH/spark-$SPARK_VERSION-bin-hadoop2.7 >> $BASE_PATH/.bashrc
echo 'export PATH="$SPARK_HOME/bin:$PATH"' >> $BASE_PATH/.bashrc


echo export PYSPARK_PYTHON=python3 >> $BASE_PATH/.bashrc
echo 'export SPARK_KAFKA_VERSION=0.10' >> $BASE_PATH/.bashrc
echo 'export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip:$PYTHONPATH' >> $BASE_PATH/.bashrc

source $BASE_PATH/.bashrc
echo java -version
echo scala -version
echo hadoop version
echo pyspark --version

# use jupyter as the interactive shell
#export PYSPARK_DRIVER_PYTHON=jupyter
#export PYSPARK_DRIVER_PYTHON_OPTS=notebook


mkdir $BASE_PATH/hdfs 
mkdir $BASE_PATH/hdfs/namenode    
mkdir $BASE_PATH/hdfs/datanode 
