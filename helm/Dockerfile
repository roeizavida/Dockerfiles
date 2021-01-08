FROM debian as dependencies

WORKDIR /tmp

ARG HELM_VERSION

RUN apt-get update -y
RUN apt-get install -y wget tar curl jq
RUN export HELM_VERSION=$( \
      curl -s -X GET https://api.github.com/repos/helm/helm/tags?per_page=100 | \
        jq -r ".[] | \
          select(.name | startswith(\"v${HELM_VERSION}.\")) | \
          select((.name | contains(\"rc\") | not) and \
          (.name | contains(\"beta\") | not) and \
          (.name | contains(\"alpha\") | not)) | .name" \
          | head -n1 \
    ) && \
    wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar xvf helm-${HELM_VERSION}-linux-amd64.tar.gz && mv linux-amd64/helm . && chmod +x helm


FROM debian as release

COPY --from=dependencies /tmp/helm /usr/local/bin/

ENTRYPOINT ["helm"]