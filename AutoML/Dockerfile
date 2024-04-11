FROM python:3.7-slim-buster

# 시스템 패키지 업데이트 및 필요한 패키지 설치
RUN apt-get update && \
    apt-get -y update && \
    apt-get install -y build-essential python3-pip python3-dev

# pip 업그레이드
RUN pip3 -q install pip --upgrade

# mljar-supervised와 jupyter 설치
RUN pip3 install mljar-supervised jupyter
RUN pip3 install auto-sklearn
#################################################################################################################
#           JUPYTER
#################################################################################################################

# Install JupyterLab and set up its configuration
RUN pip install --upgrade pip && \
    pip install jupyterlab && \
    echo "y" | jupyter lab --generate-config && \
    echo "c.ServerApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.allow_root = True" >> /root/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.open_browser = False" >> /root/.jupyter/jupyter_server_config.py