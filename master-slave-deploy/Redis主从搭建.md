### Redis主从搭建

本文只是用来记录如何快速搭建Redis主从集群，具体的原理等不做过多的阐述



Redis配置文件不做过多阐述，主要配置的是主/从Redis关系等（具体的见文件）

docker-compose.yaml

注：此处只需要修改文件的挂载目录，端口等即可

- 物理机由于系统不同，文件目录也有所差异，所以需要修改

- 物理机端口存在占用问题，也需要修改

```yaml
version: '3.0'
services:
  redis-master:
    image: redis
    restart: always
    # 防止docker-compose up -d 启动起来的容器出现立即停止的情况
    tty: true
    container_name: redis-master
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - /Users/narcos/Documents/work/redis/conf/redis-master.conf:/etc/redis/redis.conf
      - /Users/narcos/Documents/work/redis/logs/master/redis.log:/usr/redis-log/redis.log
    command:
      ["redis-server","/etc/redis/redis.conf"]
    # 给容器赋予root权限（因为挂载的目录需要root权限）  
    privileged: true
    networks:
      redis-network:
        ipv4_address: 172.60.0.2
    ports:
      - 6379:6379
  redis-slave-1:
    image: redis
    restart: always
    # 防止docker-compose up -d 启动起来的容器出现立即停止的情况
    tty: true
    container_name: redis-slave-1
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - /Users/narcos/Documents/work/redis/conf/redis-slave.conf:/etc/redis/redis.conf
      - /Users/narcos/Documents/work/redis/logs/slave1/redis.log:/usr/redis-log/redis.log
    command:
      ["redis-server","/etc/redis/redis.conf"]
    # 给容器赋予root权限（因为挂载的目录需要root权限）  
    privileged: true
    networks:
      redis-network:
        ipv4_address: 172.60.0.3
    ports:
      - 6380:6379
  redis-slave-2:
    image: redis
    restart: always
    # 防止docker-compose up -d 启动起来的容器出现立即停止的情况
    tty: true
    container_name: redis-slave-2
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - /Users/narcos/Documents/work/redis/conf/redis-slave.conf:/etc/redis/redis.conf
      - /Users/narcos/Documents/work/redis/logs/slave2/redis.log:/usr/redis-log/redis.log
    command:
      ["redis-server","/etc/redis/redis.conf"]
    # 给容器赋予root权限（因为挂载的目录需要root权限）  
    privileged: true
    networks:
      redis-network:
        ipv4_address: 172.60.0.4
    ports:
      - 6381:6379
networks:
  redis-network:
    ipam:
      config:
        - subnet: 172.60.0.0/16
```

restart.sh

```shell
#! /bin/sh

# 变量
logs="logs"
masterLogDir="logs/master"
masterLog="logs/master/redis.log"
slave1LogDir="logs/slave1"
slave1Log="logs/slave1/redis.log"
slave2LogDir="logs/slave2"
slave2Log="logs/slave2/redis.log"
# -d 判断文件是否存在，-f 判断文件是否存在
# 判断logs是否存在，不存在则创建
if [ ! -d "$logs" ]; then
	mkdir "$logs"
	chmod +x "$logs"
fi
# 同理，判断logs/master是否存在，不存在则创建，以下的判断不做过多阐述
if [ ! -d "$masterLogDir" ];then
 echo "logs/master 不存在"
 mkdir "$masterLogDir"
 chmod +x "$masterLogDir"
fi
if [ ! -f "$masterLog" ];then
 echo "logs/maser/redis.log 不存在"
 touch "$masterLog"
fi
if [ ! -d "$slave1LogDir" ];then
 echo "logs/slave-1 不存在"
 mkdir "$slave1LogDir"
 chmod +x "$slave1LogDir"
fi
if [ ! -f "$slave1Log" ];then
 echo "logs/slave-1/redis.log 不存在"
 touch "$slave1Log"
fi
if [ ! -d "$slave2LogDir" ];then
 echo "logs/slave-2 不存在"
 mkdir "$slave2LogDir"
 chmod +x "$slave2LogDir"
fi
if [ ! -d "$slave2Log" ];then
 echo "logs/slave-2/redis.log 不存在"
 touch "$slave2Log"
fi
docker-compose up -d
```



不想手动编写这么多，直接在我已经打好的懒人包上修改运行吧！

[懒人包地址](https://github.com/BeastMouth/redis-depoly/tree/master/master-slave-deploy)

