FROM ghcr.io/dante-ev/texlive:latest

RUN apt update && apt install -y \
    git \
    vim \
    zsh \
    aspell \
    hunspell \
    hunspell-en-us \
&& rm -rf /var/lib/apt/lists/*

RUN useradd -m vscode && \
    mkdir -p /home/vscode && \
    chown -R vscode:vscode /home/vscode


WORKDIR /workspace

RUN tlmgr update --self
RUN tlmgr update --all

CMD ["/bin/bash"]