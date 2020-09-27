FROM debian as dependencies

WORKDIR /tmp

RUN apt-get update -y && \
    apt-get install -y wget tar curl jq && \
    export HELM_VERSION=$(curl -s -X GET https://api.github.com/repos/helm/helm/git/refs/tags | jq -r '.[] | select(.ref | contains("v2")) | .ref' | tail -1 | awk -F '/' '{ print $3 }') && \
    wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar xvf helm-${HELM_VERSION}-linux-amd64.tar.gz && mv linux-amd64/helm . && chmod +x helm

FROM debian as release

COPY --from=dependencies /tmp/helm /usr/local/bin/