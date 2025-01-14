FROM python:3.10-slim

# Install system dependencies in a single layer
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for caching
ENV TRANSFORMERS_CACHE=/app/cache/transformers
ENV TORCH_HOME=/app/cache/torch
ENV HF_HOME=/app/cache/huggingface

RUN pip install --no-cache-dir \
    torch \
    diffusers \
    transformers \
    accelerate \
    safetensors \
    xformers

WORKDIR /app

# Copy the script
COPY generate.py .

# Change to interactive mode
ENTRYPOINT ["python", "-u", "generate.py"]

# FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04

# # Install Python and required system dependencies
# RUN apt-get update && apt-get install -y \
#     python3.10 \
#     python3-pip \
#     git \
#     curl \
#     && rm -rf /var/lib/apt/lists/*

# # Set environment variables for caching
# ENV TRANSFORMERS_CACHE=/app/cache/transformers
# ENV TORCH_HOME=/app/cache/torch
# ENV HF_HOME=/app/cache/huggingface

# # Install Python dependencies with CUDA support
# RUN pip3 install --upgrade pip && \
#     pip3 install --no-cache-dir \
#     torch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0 --index-url https://download.pytorch.org/whl/cu118 && \
#     pip3 install --no-cache-dir \
#     diffusers==0.21.4 \
#     transformers \
#     accelerate \
#     safetensors \
#     xformers==0.0.22 \
#     flask


# WORKDIR /app

# # Copy the application files
# COPY generate.py .

# # Create a wrapper script
# RUN echo '#!/bin/bash\n\
# python3 -u generate.py & \
# ngrok http 80\n' > /app/start.sh && \
# chmod +x /app/start.sh

# # Download and install ngrok
# RUN curl -Lo /usr/local/bin/ngrok https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.tgz && \
#     tar xvf /usr/local/bin/ngrok -C /usr/local/bin/ && \
#     chmod +x /usr/local/bin/ngrok

# # Set the entrypoint
# ENTRYPOINT ["/app/start.sh"]



