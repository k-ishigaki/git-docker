FROM alpine:3.11
LABEL maintainer="Kazuki Ishigaki<k-ishigaki@frontier.hokudai.ac.jp>"

RUN apk add --no-cache bash git git-perl less neovim su-exec

# install git-subrepo
SHELL [ "/bin/bash", "-c" ]
RUN git clone https://github.com/ingydotnet/git-subrepo && \
    echo 'source /git-subrepo/.rc' >> ~/.bashrc
ENV BASH_ENV ~/.bashrc

# allow normal user to use /root directory
RUN chmod +rx ${HOME}

COPY .gitconfig /root/.gitconfig

ENV GIT_SUBREPO_ROOT /git-subrepo
ENV MANPATH /git-subrepo/man:
ENV PATH /git-subrepo/lib:$PATH

RUN echo 'export HOME=/root >> .profile'
ENV USER_ID 0
ENV GROUP_ID 0
RUN { \
    echo '#!/bin/bash -e'; \
    echo 'getent group ${GROUP_ID} || addgroup --gid ${GROUP_ID} group'; \
    echo 'getent passwd ${USER_ID} || adduser --uid ${USER_ID} --disabled-password --ingroup `getent group ${GROUP_ID} | cut -d: -f1` --home /root user'; \
    echo 'exec su-exec ${USER_ID}:${GROUP_ID} "$@"'; \
    } > /entrypoint && chmod +x /entrypoint
ENTRYPOINT [ "/entrypoint" ]

CMD ["git"]
