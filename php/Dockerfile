# 定义构建参数 PHP_VERSION，用于指定 PHP 的基础镜像版本
ARG PHP_VERSION=php:8.2-fpm

# 阶段1：基础镜像修改镜像源
FROM ${PHP_VERSION} AS base

# 设置镜像源加速
RUN sed -i "s|deb.debian.org|mirrors.aliyun.com|g" /etc/apt/sources.list.d/debian.sources

# 阶段2：编译扩展并安装项目依赖
FROM base AS builder

# 安装系统依赖
RUN export option="--no-install-recommends -y" \
    && apt-get $option update \
    && apt-get $option install unzip

# 复制并解压扩展源码
COPY ./extensions/tonyenc.zip /tmp/tonyenc.zip

# 解压PHP源码及扩展源码
RUN docker-php-source extract && \
    unzip /tmp/tonyenc.zip -d /usr/src/php/ext/tonyenc

# 编译安装扩展
RUN docker-php-ext-configure tonyenc --enable-tonyenc && \
    docker-php-ext-install tonyenc

# 阶段3：最终镜像
FROM base

# 定义构建参数 PHP_EXTENSIONS，用于指定需要安装的PHP扩展列表
ARG PHP_EXTENSIONS=pdo_mysql mysqli mbstring gd intl curl opcache soap bcmath zip

# 定义需要加密的文件或目录
ARG ENCRYPTED_FILES=/public

# 安装系统依赖
RUN export option="--no-install-recommends -y" \
    && apt-get $option update \
    && apt-get $option install tzdata curl

# Clean up the package list to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# 安装PHP扩展
RUN curl -sSLf -o /usr/local/bin/install-php-extensions https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
    && chmod +x /usr/local/bin/install-php-extensions \
    && install-php-extensions $PHP_EXTENSIONS

# 拷贝相关配置
COPY ./php.ini /usr/local/etc/php/php.ini
COPY ./php-fpm.conf /usr/local/etc/php-fpm.d/www.conf

# 拷贝项目初始化脚本
COPY docker-entrypoint.sh /docker-entrypoint.sh

# 设置工作目录
WORKDIR /www

# 拷贝所有项目文件
COPY ./www .
# 拷贝加密工具
COPY --from=builder /usr/src/php/ext/tonyenc/tonyenc.php .

# 安装composer并更改缓存目录
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV COMPOSER_HOME=/tmp/composer

# 安装项目依赖并初始化相关目前及文件权限
RUN composer install --no-dev --optimize-autoloader

# 复制编译好的自定义扩展
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/

# 启用自定义扩展
RUN docker-php-ext-enable tonyenc

# 创建相关目录并初始化文件权限
RUN php tonyenc.php $ENCRYPTED_FILES && \
    rm -rf tonyenc.php && \ 
    mkdir -p /var/log/php && \
    chown -R www-data:www-data /var/log/php && \
    chmod -R 755 /var/log/php && \
    chmod +x /docker-entrypoint.sh

# 时区上海
ENV TZ=Asia/Shanghai

# 默认环境
ENV APP_ENV=dev

# 项目启动时初始化脚本
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php-fpm"]