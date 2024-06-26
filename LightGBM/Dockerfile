FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

#################################################################################################################
#           Global
#################################################################################################################
# apt-get to skip any interactive post-install configuration steps with DEBIAN_FRONTEND=noninteractive and apt-get install -y

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive

#################################################################################################################
#           Global Path Setting
#################################################################################################################

ENV CUDA_HOME /usr/local/cuda
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${CUDA_HOME}/lib64
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/usr/local/lib

ENV OPENCL_LIBRARIES /usr/local/cuda/lib64
ENV OPENCL_INCLUDE_DIR /usr/local/cuda/include

#################################################################################################################
#           TINI
#################################################################################################################

# Install tini
ENV TINI_VERSION v0.14.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

#################################################################################################################
#           SYSTEM
#################################################################################################################
# update: downloads the package lists from the repositories and "updates" them to get information on the newest versions of packages and their
# dependencies. It will do this for all repositories and PPAs.

RUN apt-get update && \
apt-get install -y --no-install-recommends \
build-essential \
curl \
bzip2 \
ca-certificates \
libglib2.0-0 \
libxext6 \
libsm6 \
libxrender1 \
git \
vim \
mercurial \
subversion \
cmake \
libboost-dev \
libboost-system-dev \
libboost-filesystem-dev \
gcc \
g++

# Add OpenCL ICD files for LightGBM
RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

#################################################################################################################
#           CONDA
#################################################################################################################

ARG CONDA_DIR=/opt/miniforge
# add to path
ENV PATH $CONDA_DIR/bin:$PATH

# Install miniforge
RUN echo "export PATH=$CONDA_DIR/bin:"'$PATH' > /etc/profile.d/conda.sh && \
    curl -sL https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -o ~/miniforge.sh && \
    /bin/bash ~/miniforge.sh -b -p $CONDA_DIR && \
    rm ~/miniforge.sh

RUN conda config --set always_yes yes --set changeps1 no && \
    conda create -y -q -n py3 numpy scipy scikit-learn jupyter notebook ipython pandas matplotlib seaborn tqdm

#################################################################################################################
#           LightGBM
#################################################################################################################

RUN cd /usr/local/src && mkdir lightgbm && cd lightgbm && \
    git clone --recursive --branch stable --depth 1 https://github.com/microsoft/LightGBM && \
    cd LightGBM && mkdir build && cd build && \
    cmake -DUSE_GPU=1 -DOpenCL_LIBRARY=/usr/local/cuda/lib64/libOpenCL.so -DOpenCL_INCLUDE_DIR=/usr/local/cuda/include/ .. && \
    make OPENCL_HEADERS=/usr/local/cuda-8.0/targets/x86_64-linux/include LIBOPENCL=/usr/local/cuda-8.0/targets/x86_64-linux/lib

ENV PATH /usr/local/src/lightgbm/LightGBM:${PATH}

RUN /bin/bash -c "source activate py3 && cd /usr/local/src/lightgbm/LightGBM && sh ./build-python.sh install --precompile && source deactivate"

#################################################################################################################
#           System CleanUp
#################################################################################################################
# apt-get autoremove: used to remove packages that were automatically installed to satisfy dependencies for some package and that are no more needed.
# apt-get clean: removes the aptitude cache in /var/cache/apt/archives. You'd be amazed how much is in there! the only drawback is that the packages
# have to be downloaded again if you reinstall them.

RUN apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    conda clean -a -y

#################################################################################################################
#           JUPYTER
#################################################################################################################

# Activate py3 environment by default
RUN echo "source activate py3" >> /root/.bashrc


# Install JupyterLab and set up its configuration
RUN pip install --upgrade pip && \
    pip install jupyterlab && \
    /bin/bash -c "source activate py3 && ipython kernel install --user --name=py3 && source deactivate" && \
    echo "y" | jupyter lab --generate-config && \
    echo "c.ServerApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.allow_root = True" >> /root/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.open_browser = False" >> /root/.jupyter/jupyter_server_config.py