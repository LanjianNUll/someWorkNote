#!/bin/bash
#$0 为执行的文件名  $n 为向脚本传递的参数
# $# 传递到脚本的参数个数   $*  以一个单字符下显示所有传递的参数  $@ 以"" 显示所有传递的参数
# $$脚本运行的当前进程ID

zip_file="$1.zip"
tar_gz_file="$1.tar.gz"
file="$1"
docker_image_name="$1"
#推送的仓库
docker_ip="xxxxx";
#市局
docker_res="xinghuo";
#光明
#docker_res="guangming"
#运行脚本前的参数校验
if [ $# != 2 ]
then
	echo "输入参数有误"
	exit 2
fi

if [ -z $1 ]
then
   echo "输入镜像名称"
   exit 2
fi

if [ -z $2 ]
then
   echo "输入日期版本不能为空"
   exit 2
fi

echo $docker_image_name

if [ -e ${zip_file} ]
then
	##制作好打镜像前的文件
	if [ -e ${tar_gz_file} ]
	then
		rm -rf ${tar_gz_file}
	fi
	if [ -e ${file} ]
	then
		rm -rf ${file}
	fi
	unzip ${zip_file}
	tar -zcvf ${tar_gz_file} ${file}
	rm -rf ${zip_file}
	rm -rf ${file}
	echo "打镜像前的文件制作成功！"
	##开始打镜像了
	docker build -t $docker_image_name:$2 .
	##镜像标签
	docker tag $docker_image_name:$2   $docker_ip/$docker_res/$docker_image_name:$2
	##推送镜像到远程仓库
	docker push $docker_ip/$docker_res/$docker_image_name:$2
	echo "复制下面，运维更新"
	echo 'docker push '$docker_ip/$docker_res/$docker_image_name:$2
else 
	echo "$1.zip 文件不存在,请拖入 ${zip_file}"
fi
