FROM centos:7

RUN yum update -y && yum install -y ksh

ENTRYPOINT [ "/bin/ksh", "-i"]
