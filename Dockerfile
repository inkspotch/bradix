FROM ubuntu
RUN apt-get update && apt-get install -y nasm gcc make genisoimage build-essential

