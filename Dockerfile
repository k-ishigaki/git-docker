FROM alpine
LABEL maintainer="Kazuki Ishigaki<k-ishigaki@frontier.hokudai.ac.jp>"

# may be override when exec container
ENV USER_SPEC 0:0

RUN apk add --update bash git less su-exec && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

# install git-subrepo
SHELL [ "/bin/bash", "-c" ]
RUN git clone https://github.com/ingydotnet/git-subrepo && \
    echo 'source /git-subrepo/.rc' >> ~/.bashrc
ENV BASH_ENV ~/.bashrc

# allow normal user to use /root directory
RUN chmod +rx ${HOME}

# read bashrc when docker run and change userspec
RUN echo 'exec su-exec ${USER_SPEC} bash -c "export HOME=${HOME} && git $*"' > entrypoint.sh
ENTRYPOINT [ "bash", "/entrypoint.sh"  ]

WORKDIR /git
