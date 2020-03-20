### Redis主从搭建

本文只是用来记录如何快速搭建Redis主从集群

master节点配置：

```yaml
version: '3.0'
services:
  redis-master:
    image: redis
    # 由于做了持久化的原因，主库不能重启
    # 当主库崩溃是，将一个从库升级为主库，将主库作为前一步升级为主库的从库的slave
    # restart: always
    # 防止docker-compose up -d 启动起来的容器出现立即停止的情况
    tty: true
    container_name: redis-master
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - ./redis-master.conf:/etc/redis/redis.conf
      - ./redis-master.log:/etc/redis/redis.log
      - ./data-master/:/data/
    command:
      ["redis-server","/etc/redis/redis.conf"]
    # 给容器赋予root权限（因为挂载的目录需要root权限）  
    privileged: true
    ports:
      - 6379:6379
# networks:
#  创建网络  
#  redis-network:
#    ipam:
#      config:
#        - subnet: 172.60.0.0/16
    # 使用现有的网络
networks:    
  default:
    external:
      name: redis_redis-network
```

slave节点配置

```yaml
version: '3.0'
services:
  redis-slave-1:
    image: redis
    restart: always
    # 防止docker-compose up -d 启动起来的容器出现立即停止的情况
    tty: true
    container_name: redis-slave-1
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - ./redis-slave.conf:/etc/redis/redis.conf
      - ./redis-slave-1.log:/etc/redis/redis.log
      - ./data-slave-1/:/data/
    command:
      # 此处没有在配置文件中设置，而是在运行的命令中指定了是哪个节点的从节点
      ["redis-server","/etc/redis/redis.conf","--slaveof 172.60.0.2 6379"]
    # 给容器赋予root权限（因为挂载的目录需要root权限）  
    privileged: true
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
      - ./redis-slave.conf:/etc/redis/redis.conf
      - ./redis-slave-2.log:/etc/redis/redis.log
      - ./data-slave-2/:/data/
    command:
      ["redis-server","/etc/redis/redis.conf","--slaveof 172.60.0.2 6379"]
    # 给容器赋予root权限（因为挂载的目录需要root权限）  
    privileged: true
    ports:  
      - 6381:6379
networks:
    # 使用现有的网络
  default:
    external:
      name: redis_redis-network
```

不想手动编写这么多，直接在我已经打好的懒人包上修改运行吧！

[懒人包地址](https://github.com/BeastMouth/redis-depoly/tree/master/master-slave-deploy)



配置文件修改的内容

redis-master.conf

```conf
# 自动触发bgsave的条件
save 900 1
save 300 10
save 60 10000

# RDB文件和AOF文件所在目录
dir ./

# redis 密码
requirepass hbj123456

# 开启aof备份
appendonly yes

# aof文件名
appendfilename "appendonly.aof"

# aof每秒备份一次
appendfsync everysec
```

redis-slave.conf

```conf
# 同时监听主节点
bind 0.0.0.0 172.60.0.2

# 自动触发bgsave的条件
save 900 1
save 300 10
save 60 10000

# RDB文件和AOF文件所在目录
dir ./

# 主节点认证密码
masterauth hbj123456
# redis 密码
requirepass hbj123456

# 开启aof备份
appendonly yes

# aof文件名
appendfilename "appendonly.aof"

# aof每秒备份一次
appendfsync everysec
```

