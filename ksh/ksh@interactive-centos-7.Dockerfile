FROM centos/nginx-116-centos7

RUN yum update -y && \
    yum install -y ksh && \
    yum clean all && \
    rm -rf /var/cache/yum

ENTRYPOINT [ "/bin/ksh" ]