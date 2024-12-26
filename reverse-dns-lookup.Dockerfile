FROM alpine:3.21.0

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

    # python3-dev \
    # build-base && \
RUN apk add --no-cache \
    python3 \
    py3-pip
    
WORKDIR /app
RUN python3 -m venv /app/dns-pipeline 
ENV PATH="/app/dns-pipeline/bin:$PATH"

### Install python modules
RUN pip install boto3==1.34.113 requests==2.32.3