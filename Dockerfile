FROM alpine
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
	echo 'if [ ${USER_ID} -ne 0 ]; then'; \
	echo '    addgroup -g ${GROUP_ID} -S group'; \
	echo '    adduser -h /root -G group -S -D -H -u ${USER_ID} user'; \
	echo 'fi'; \
	echo 'exec su-exec ${USER_ID}:${GROUP_ID} "$@"'; \
	} > /entrypoint && chmod +x /entrypoint
ENTRYPOINT [ "/entrypoint" ]

CMD ["git"]
