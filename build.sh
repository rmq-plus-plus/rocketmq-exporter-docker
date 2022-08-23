#!/bin/bash
RETVAL=0

build_image()
{
    IMAGE_VERSION=$1
    version=$2
    jar_name=$3
    namesrv=$4

    docker build --no-cache \
      -t ${IMAGE_VERSION} \
      --build-arg image_version=${IMAGE_VERSION} \
      --build-arg jar_name=${jar_name} \
      --build-arg namesrv=${namesrv} \
    .

    docker images

    mark=`docker images | grep ${version}`
    if [ ! "$mark" ]
    then
        echo "镜像打包失败"
        exit 1
    fi

    echo "镜像打包完成，$mark"
}

work_dir=${PWD}

git clone https://github.com/apache/rocketmq-exporter.git
cd ${work_dir}/rocketmq-exporter

all_version=$(mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=project.version -q -DforceStdout)
namesrv=127.0.0.1:9876

mvn clean package -Dmaven.test.skip=true

cd ${work_dir}/rocketmq-exporter/target
jar_name=$(ls rocketmq-exporter-*.jar)

cp ${work_dir}/rocketmq-exporter/target/$jar_name ${work_dir}/


cd ${work_dir}/
IMAGE_VERSION=rocketmq/rocketmq-exporter:${all_version}
build_image $IMAGE_VERSION $all_version $jar_name $namesrv


exit $RETVAL
