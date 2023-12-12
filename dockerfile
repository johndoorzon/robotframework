FROM mcr.microsoft.com/playwright:focal
USER root
RUN apt-get update
RUN apt-get install -y python3-pip
USER pwuser
RUN pip3 install --no-cache-dir -r requirements.txt
RUN ~/.local/bin/rfbrowser init
ENV NODE_PATH=/usr/lib/node_modules
ENV PATH="/home/pwuser/.local/bin:${PATH}"
