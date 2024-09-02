# Base image
FROM python:3.9-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set working directory
WORKDIR /app

# Install system dependencies and OpenCL drivers
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    ocl-icd-opencl-dev \
    clinfo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir numpy==1.22 catboost optuna xgboost lightgbm scikit-learn mlxtend seaborn

# Install JupyterLab, ipywidgets, and set up Jupyter configuration
RUN pip install --no-cache-dir jupyterlab ipywidgets notebook && \
    jupyter lab --generate-config && \
    echo "c.ServerApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.allow_root = True" >> /root/.jupyter/jupyter_server_config.py && \
    echo "c.ServerApp.open_browser = False" >> /root/.jupyter/jupyter_server_config.py

# Copy the application code
COPY . .

# Expose the port JupyterLab will run on
EXPOSE 8888