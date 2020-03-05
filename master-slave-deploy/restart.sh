#! /bin/sh
logs="logs"
masterLogDir="logs/master"
masterLog="logs/master/redis.log"
slave1LogDir="logs/slave1"
slave1Log="logs/slave1/redis.log"
slave2LogDir="logs/slave2"
slave2Log="logs/slave2/redis.log"
if [ ! -d "$logs" ]; then
	mkdir "$logs"
	chmod +x "$logs"
fi
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