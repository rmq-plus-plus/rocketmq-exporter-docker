FROM konajdk/konajdk:8

RUN echo "Asia/Shanghai" > /etc/timezone

RUN ls -l /opt/jdk/

ENV APP_HOME /app

ARG jar_name
ENV JAR_FILE_NAME ${jar_name}

ARG namesrv
ENV NAMESRV_ADDR ${namesrv}

RUN mkdir -p ${APP_HOME} 

EXPOSE 5557

COPY ${jar_name} ${APP_HOME}/

RUN ls -lsh ${APP_HOME}


WORKDIR ${APP_HOME}

# 打印环境变量
RUN env
