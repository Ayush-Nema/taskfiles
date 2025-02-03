FROM ubuntu:22.04

# Set the working directory
WORKDIR /var/task
ARG DEBIAN_FRONTEND=noninteractive

# Copying the scripts from local to working directory within container
COPY ./scripts/ /var/task

# Copying the dirs for storing intermediate results (saves ops during runtime)
# files stored under them will be purged alongside
COPY ./_tmp /var/task

# Creating directory to store model checkpoint and place it in correct directory
RUN mkdir -p /root/.cache/torch/hub/checkpoints
COPY model_checkpoints/ /root/.cache/torch/hub/checkpoints

# Update package list and install pip
RUN apt-get update && \
    apt-get install -y python3.10 python3-pip \
    libgl1 \
    libglib2.0-0\
    vim\
    awscli\
    && rm -rf /var/lib/apt/lists/*

# Install the necessary dependencies
# ToDo: CREATE VIRTUAL ENVIRONMENT AND ACTIVATE
RUN pip install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cpu
# RUN pip install --no-cache-dir torch==2.2.2+cu118 torchvision==0.17.2+cu118 -f https://download.pytorch.org/whl/torch_stable.html
RUN pip install --no-cache-dir opencv-python==4.9.0.80 pynvml==11.5.0 boto3==1.34.113

# Setting the entrypoint for execution
CMD [ "lambda_function.lambda_handler" ]
# CMD ["/bin/bash"]
