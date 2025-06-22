ARG NGINX_VERSION=nginx:1.26-alpine
FROM ${NGINX_VERSION}

# 拷贝相关配置
COPY . /etc/nginx

# 设置工作目录
WORKDIR /www

# 时区上海
ENV TZ=Asia/Shanghai