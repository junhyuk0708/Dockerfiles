# Base Image
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

# Set noninteractive environment for apt-get install
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul

# Remove any third-party apt sources to avoid issues with expiring keys
RUN rm -f /etc/apt/sources.list.d/*.list

# Update package list & Install basic utilities
RUN apt-get update -q -y && \
    apt-get install -y --no-install-recommends wget vim curl ssh tree sudo git zip unzip libgl1-mesa-glx software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update -y && \
    apt-get install -y python3.8 python3-pip python3.8-distutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    curl https://bootstrap.pypa.io/get-pip.py | python3.8

# Install JupyterLab, ipywidgets, and set up Jupyter configuration
RUN python3.8 -m pip install --upgrade pip && \
    python3.8 -m pip install jupyterlab ipywidgets notebook && \
    echo "y" | jupyter lab --generate-config && \
    echo "c.ServerApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.allow_root = True" >> /root/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.open_browser = False" >> /root/.jupyter/jupyter_server_config.py

# Install Python packages 
RUN pip install numpy==1.19.5
RUN python3.8 -m pip install mxnet
RUN pip install gluonnlp==0.8.0
RUN python3.8 -m pip install pandas==1.1 tqdm
RUN pip install matplotlib==3.6.3
RUN python3.8 -m pip install sentencepiece==0.1.91 # 현재 0.2.0
RUN python3.8 -m pip install transformers==4.8.2 # 현재4.40.2
RUN pip install scipy==1.10.1 # numpy&scikitlearn 호환
RUN python3.8 -m pip install scikit-learn==1.3.2

# Install PyTorch related packages
RUN pip install torch==2.1 torchvision==0.16 torchaudio==2.1 --index-url https://download.pytorch.org/whl/cu118
RUN pip install 'git+https://github.com/SKTBrain/KoBERT.git#egg=kobert_tokenizer&subdirectory=kobert_hf'