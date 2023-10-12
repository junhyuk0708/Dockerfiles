# Dockerfile
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

# Remove any third-party apt sources to avoid issues with expiring keys.
RUN rm -f /etc/apt/sources.list.d/*.list

# Update package list
RUN apt-get update -y

# Install basic utilities
RUN apt-get install -y --no-install-recommends wget vim curl ssh tree sudo git zip unzip 

# Set noninteractive environment for apt-get install
ENV DEBIAN_FRONTEND=noninteractive

# Install software-properties-common
RUN apt-get install -y software-properties-common

# Add Python 3.11 repository
RUN add-apt-repository ppa:deadsnakes/ppa

# Update package list again
RUN apt-get update -y 

# Install Python 3.11 and pip
RUN apt-get install -y python3.11 python3-pip python3.11-distutils

# Get latest pip
RUN curl https://bootstrap.pypa.io/get-pip.py | python3.11

# Clean up package lists
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Set up time zone
ENV TZ=Asia/Seoul
RUN sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime

# Set Jupyter
RUN python3.11 -m pip install --upgrade pip && \
    python3.11 -m pip install jupyterlab

RUN echo "y" | jupyter lab --generate-config
RUN echo "c.ServerApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_server_config.py
RUN echo "c.ServerApp.allow_root = True" >> /root/.jupyter/jupyter_server_config.py
RUN echo "c.ServerApp.open_browser = False" >> /root/.jupyter/jupyter_server_config.py

# Install Python packages
RUN python3.11 -m pip install numpy scipy matplotlib pandas scikit-learn ipython seaborn jupyterlab tqdm

# Install PyTorch
RUN python3.11 -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# efficientnet_pytorch
RUN pip install efficientnet_pytorch