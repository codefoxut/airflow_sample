FROM centos:latest
LABEL maintainer="Stratos Team <stratos-dev@go-mmt.com>"

ARG PYTHON_VERSION=3.7.3
ARG PYTHON_URL=https://www.python.org/ftp/python


RUN \
 yum install -y epel-release && \
 yum groupinstall -y "Development Tools" && \
 yum install -y wget \
                git \
                which \
                make \
                python-setuptools \
                python-pip \
                python-dev \
                zlib-devel \
                python-wheel \
                openssl-devel \
                mysql-devel \
                python-devel \
                gcc-c++ \
                snappy-devel \
                gcc \
                postgresql \
                postgresql-devel \
                sqlite-devel \
                expat-devel \
                bzip2-devel \
                libffi \
                libffi-devel \
                zlib-devel \
                numpy \
                supervisor \
                redhat-rpm-config \
                && \
 yum install -y nginx && \
 easy_install supervisor && \
 yum install -y supervisor && \
 mkdir -p /var/log/supervisor /etc/supervisord.d /logs /logs/celery_logs/ /etc/newrelic && \
 yum clean all

EXPOSE 80 8080 5555 6789

# install python.
RUN \
 cd /opt && \
 wget ${PYTHON_URL}/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
 tar xvf Python-${PYTHON_VERSION}.tgz && \
 cd /opt/Python-${PYTHON_VERSION} && \
 ./configure --enable-shared --with-system-ffi --with-system-expat --enable-loadable-sqlite-extensions --prefix=/usr/local/python3.7 LDFLAGS="-L/usr/local/python3.7/lib -Wl,--rpath=/usr/local/python3.7/lib"  && \
 make && \
 make altinstall && \
 rm -f /etc/localtime && \
 ln -s /usr/share/zoneinfo/Asia/Kolkata /etc/localtime


ENV AIRFLOW_HOME=/usr/local/stratos/airproject
ENV PATH=$PATH:/usr/local/python3.7/bin

# pip isntall
COPY config/pip/requirements.txt /etc/pip/requirements.txt
COPY config/pip/constraints.txt /etc/pip/constraints.txt
RUN \
  /usr/local/python3.7/bin/pip3.7 install -r /etc/pip/requirements.txt

COPY . /usr/local/goibibo/stratos

WORKDIR ${AIRFLOW_HOME}

#CMD ["airflow", "webserver", "-p", "8080"]

CMD ["/bin/bash"]