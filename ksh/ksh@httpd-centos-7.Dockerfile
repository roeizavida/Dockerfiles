FROM centos:7

RUN yum update -y && \
    yum install -y ksh httpd && \
    yum clean all && \
    rm -rf /var/cache/yum

ENTRYPOINT [ "/bin/ksh" ]