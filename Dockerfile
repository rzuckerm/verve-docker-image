FROM ubuntu:18.04

COPY VERVE_* /tmp/
COPY fix_output /usr/local/bin
ENV LC_ALL="C.UTF-8"
RUN apt-get update && \
    apt-get install -y \
        git \
        curl \
        xz-utils \
        make \
        gcc \
        libgmp-dev \
        libncurses5-dev \
        python3 \
        && \
    (curl -L https://www.stackage.org/stack/linux-x86_64 | tar xz --wildcards --strip-components=1 -C /usr/local/bin '*/stack') && \
    mkdir -p /opt && \
    cd /opt && \
    git clone https://github.com/tadeuzagallo/verve-lang && \
    cd verve-lang && \
    git reset --hard $(cat /tmp/VERVE_COMMIT_HASH) && \
    stack --no-terminal build && \
    cd / && \
    find /opt/verve-lang/ -mindepth 1 -maxdepth 1 '!' -name '.stack-work' -exec rm -rf '{}' ';' && \
    apt-get remove -y git curl xz-utils make gcc && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /root/.stack
ENV PATH=/opt/verve-lang/.stack-work/dist/x86_64-linux/ghc-8.0.2/build/verve:$PATH
