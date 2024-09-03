# Use an official Ubuntu base image as a parent image
FROM ubuntu:20.04

# Set noninteractive environment for apt-get install
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul

# Update package list & Install basic utilities
RUN apt-get update -q -y && \
    apt-get install -y --no-install-recommends wget vim curl ssh tree sudo git zip unzip libgl1-mesa-glx software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update -y && \
    apt-get install -y python3.7 python3-pip python3.7-distutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    curl https://bootstrap.pypa.io/pip/3.7/get-pip.py | python3.7

# Set the working directory in the container
WORKDIR /usr/src/app

# Install dependencies for MeCab
RUN apt-get update && apt-get install -y \
    mecab \
    libmecab-dev \
    mecab-ipadic-utf8 \
    git \
    curl \
    xz-utils \
    file \
    sudo

# Install mecab-python3 dependencies
RUN apt-get install -y swig

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install JupyterLab and set up its configuration
RUN pip install --upgrade pip && \
    pip install jupyter notebook==5.7.8 && \
    echo "y" | jupyter notebook --generate-config && \
    echo "c.ServerApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.allow_root = True" >> /root/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.open_browser = False" >> /root/.jupyter/jupyter_server_config.py

# Make port 8888 available to the world outside this container
EXPOSE 8888

# Run Jupyter Notebook when the container launches
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]