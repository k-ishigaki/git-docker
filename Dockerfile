FROM alpine:3.18

RUN apk add --no-cache bash~=5.2 git~=2.40 github-cli~=2.29 git-perl~=2.40 less~=633

# install git-subrepo
SHELL [ "/bin/bash", "-c" ]
RUN git clone https://github.com/ingydotnet/git-subrepo && \
    echo 'source /git-subrepo/.rc' >> ~/.bashrc
ENV BASH_ENV ~/.bashrc

COPY .gitconfig /root/.gitconfig

ENV GIT_SUBREPO_ROOT /git-subrepo
ENV MANPATH /git-subrepo/man:
ENV PATH /git-subrepo/lib:$PATH
