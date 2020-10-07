FROM centos:7

RUN yum update -y && \
    yum install -y ksh && \
    yum clean all && \
    rm -rf /var/cache/yum

ENTRYPOINT [ "/bin/ksh", "-i" ]

CMD ["sleep infinity"]