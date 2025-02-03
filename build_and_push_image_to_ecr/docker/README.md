Essential commands
=====================

## ✪ Building and running the image
- Building the image
```shell
docker build --platform linux/amd64 --no-cache -f docker/pure_cpu_support/Dockerfile -t semantic_seg:1.0 .
```
PS: Run the command from the repo root where `scripts` and `checkpoints` dir is present. (thus providing the path 
  to the `Dockerfile`)

- Running the image to get the container
```shell
docker run --rm --gpus all --env-file ./.env.list --name=semantic_container semantic_seg:1.0
```
Example of `.env.list` file
```
INPUT_BUCKET=test-images-ml
INPUT_DIR=camera_2
INPUT_FILE_PATH=camera_2/image-01400.png
MASK_BUCKET=test-images-ml
MASK_FILE_PATH=mask_2.png
OUTPUT_BUCKET=test-images-ml
OUTPUT_DIR=test_outputs
```

```shell
or
```shell
docker run --rm --entrypoint /bin/bash -it --name=semantic_container semantic_seg:1.0
```

---

## ✪ Analyzing docker images (using `dive`)
`dive` git page: [Click here](https://github.com/wagoodman/dive)  

### ◎ Installation
```shell
DIVE_VERSION=$(curl -sL "https://api.github.com/repos/wagoodman/dive/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
curl -OL https://github.com/wagoodman/dive/releases/download/v${DIVE_VERSION}/dive_${DIVE_VERSION}_linux_amd64.deb
sudo apt install ./dive_${DIVE_VERSION}_linux_amd64.deb
```

### ◎ Usage
```shell
dive semantic_seg:1.0
```
PS: takes several minutes to analyse for larger images.

Response
```
┃ ● Layers ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ Permission     UID:GID       Size  Filetree                                                                                       
Cmp   Size  Command                                                                                                                -rw-r--r--         0:0      17 kB  ├── NGC-DL-CONTAINER-LICENSE                                                                   
     78 MB  FROM 9c78f74ad967b89                                                                                                   drwxr-xr-x         0:0      30 kB  ├── app                                                                                        
     10 MB  RUN |1 TARGETARCH=amd64 /bin/sh -c apt-get update && apt-get install -y --no-install-recommends     gnupg2 curl ca-cer drwxrwxr-x         0:0        0 B  │   ├── _tmp_in                                                                                
    151 MB  RUN |1 TARGETARCH=amd64 /bin/sh -c apt-get update && apt-get install -y --no-install-recommends     cuda-cudart-11-8=$ drwxrwxr-x         0:0        0 B  │   ├── _tmp_mid_step                                                                          
      46 B  RUN |1 TARGETARCH=amd64 /bin/sh -c echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf     && echo "/usr/loc drwxrwxr-x         0:0        0 B  │   ├── _tmp_out                                                                               
     17 kB  COPY NGC-DL-CONTAINER-LICENSE / # buildkit                                                                             -rw-rw-r--         0:0     8.2 kB  │   ├── mask_rcnn_model.py                                                                     
    2.4 GB  RUN |1 TARGETARCH=amd64 /bin/sh -c apt-get update && apt-get install -y --no-install-recommends     cuda-libraries-11- -rw-rw-r--         0:0     6.9 kB  │   ├── s3_utils.py                                                                            
    260 kB  RUN |1 TARGETARCH=amd64 /bin/sh -c apt-mark hold ${NV_LIBCUBLAS_PACKAGE_NAME} ${NV_LIBNCCL_PACKAGE_NAME} # buildkit    -rw-rw-r--         0:0      10 kB  │   ├── segment.py                                                                             
    3.1 kB  COPY entrypoint.d/ /opt/nvidia/entrypoint.d/ # buildkit                                                                -rw-rw-r--         0:0     5.0 kB  │   └── utils.py                                                                               
    2.5 kB  COPY nvidia_entrypoint.sh /opt/nvidia/ # buildkit                                                                      -rwxrwxrwx         0:0        0 B  ├── bin → usr/bin                                                                              
    1.1 GB  RUN |1 TARGETARCH=amd64 /bin/sh -c apt-get update && apt-get install -y --no-install-recommends     ${NV_CUDNN_PACKAGE drwxr-xr-x         0:0        0 B  ├── boot                                                                                       
       0 B  WORKDIR /app                                                                                                           -rw-r--r--         0:0     4.3 kB  ├── cuda-keyring_1.0-1_all.deb                                                                 
     30 kB  COPY ./scripts/ /app # buildkit                                                                                        drwxr-xr-x         0:0        0 B  ├── dev                                                                                        
       0 B  COPY ./_tmp /app/ # buildkit                                                                                           drwxr-xr-x         0:0     867 kB  ├── etc                                                                                        
       0 B  RUN |1 DEBIAN_FRONTEND=noninteractive /bin/sh -c mkdir -p /root/.cache/torch/hub/checkpoints # buildkit                -rw-------         0:0        0 B  │   ├── .pwd.lock                                                                              
    178 MB  COPY model_checkpoints/ /root/.cache/torch/hub/checkpoints # buildkit                                                  drwxr-xr-x         0:0     244 kB  │   ├── ImageMagick-6                                                                          
    850 MB  RUN |1 DEBIAN_FRONTEND=noninteractive /bin/sh -c apt-get update &&     apt-get install -y python3-pip     libgl1     l -rw-r--r--         0:0      899 B  │   │   ├── coder.xml                                                                          
    5.6 GB  RUN |1 DEBIAN_FRONTEND=noninteractive /bin/sh -c pip install --no-cache-dir torch==2.2.2+cu118 torchvision==0.17.2+cu1 -rw-r--r--         0:0     1.4 kB  │   │   ├── colors.xml                                                                         
    194 MB  RUN |1 DEBIAN_FRONTEND=noninteractive /bin/sh -c pip install --no-cache-dir opencv-python==4.9.0.80 pynvml==11.5.0 bot -rw-r--r--         0:0      14 kB  │   │   ├── delegates.xml                                                                      
                                                                                                                                   -rw-r--r--         0:0     1.6 kB  │   │   ├── log.xml                                                                            
                                                                                                                                   -rw-r--r--         0:0      888 B  │   │   ├── magic.xml                                                                          
│ Layer Details ├───────────────────────────────────────────────────────────────────────────────────────────────────────────────── -rw-r--r--         0:0     134 kB  │   │   ├── mime.xml                                                                           
                                                                                                                                   -rw-r--r--         0:0     4.7 kB  │   │   ├── policy.xml                                                                         
Tags:   (unavailable)                                                                                                              -rw-r--r--         0:0     2.4 kB  │   │   ├── quantization-table.xml                                                             
Id:     70cd0d1cd58f23638042f44daa00157b85e7d689d6beea41915f102cd311efc4                                                           -rw-r--r--         0:0      12 kB  │   │   ├── thresholds.xml                                                                     
Digest: sha256:b8420ccd99440a5e8ab5516cb479b3e5acb8881d961b1d5c9ec5e42a633d7bef                                                    -rw-r--r--         0:0      29 kB  │   │   ├── type-apple.xml                                                                     
Command:                                                                                                                           -rw-r--r--         0:0     8.5 kB  │   │   ├── type-dejavu.xml                                                                    
RUN |1 DEBIAN_FRONTEND=noninteractive /bin/sh -c pip install --no-cache-dir torch==2.2.2+cu118 torchvision==0.17.2+cu118 -f https: -rw-r--r--         0:0     9.7 kB  │   │   ├── type-ghostscript.xml                                                               
//download.pytorch.org/whl/torch_stable.html # buildkit                                                                            -rw-r--r--         0:0      10 kB  │   │   ├── type-urw-base35.xml                                                                
                                                                                                                                   -rw-r--r--         0:0      14 kB  │   │   ├── type-windows.xml                                                                   
                                                                                                                                   -rw-r--r--         0:0      651 B  │   │   └── type.xml                                                                           
                                                                                                                                   drwxr-xr-x         0:0      34 kB  │   ├── X11                                                                                    
                                                                                                                                   -rwxr-xr-x         0:0      709 B  │   │   ├── Xreset                                                                             
                                                                                                                                   drwxr-xr-x         0:0      205 B  │   │   ├── Xreset.d                                                                           
                                                                                                                                   -rw-r--r--         0:0      205 B  │   │   │   └── README                                                                         
                                                                                                                                   drwxr-xr-x         0:0      319 B  │   │   ├── Xresources                                                                         
                                                                                                                                   -rw-r--r--         0:0      319 B  │   │   │   └── x11-common                                                                     
                                                                                                                                   -rwxr-xr-x         0:0     4.1 kB  │   │   ├── Xsession                                                                           
                                                                                                                                   drwxr-xr-x         0:0     7.3 kB  │   │   ├── Xsession.d                                                                         
                                                                                                                                   -rw-r--r--         0:0     1.9 kB  │   │   │   ├── 20x11-common_process-args                                                      
                                                                                                                                   -rw-r--r--         0:0      878 B  │   │   │   ├── 30x11-common_xresources                                                        
                                                                                                                                   -rw-r--r--         0:0      389 B  │   │   │   ├── 35x11-common_xhost-local                                                       
                                                                                                                                   -rw-r--r--         0:0      187 B  │   │   │   ├── 40x11-common_xsessionrc                                                        
│ Image Details ├───────────────────────────────────────────────────────────────────────────────────────────────────────────────── -rw-r--r--         0:0     1.6 kB  │   │   │   ├── 50x11-common_determine-startup                                                 
                                                                                                                                   -rw-r--r--         0:0      991 B  │   │   │   ├── 60x11-common_xdg_path                                                          
Image name: semantic_seg:1.0                                                                                                       -rw-r--r--         0:0      880 B  │   │   │   ├── 90gpg-agent                                                                    
Total Image size: 10 GB                                                                                                            -rw-r--r--         0:0      385 B  │   │   │   ├── 90x11-common_ssh-agent                                                         
Potential wasted space: 49 MB                                                                                                      -rw-r--r--         0:0      166 B  │   │   │   └── 99x11-common_start                                                             
Image efficiency score: 99 %                                                                                                       -rw-r--r--         0:0      265 B  │   │   ├── Xsession.options                                                                   
                                                                                                                                   drwxr-xr-x         0:0     3.4 kB  │   │   ├── app-defaults                                                                       
Count   Total Space  Path                                                                                                          -rw-r--r--         0:0     2.8 kB  │   │   │   ├── GXditview                                                                      
    2        7.6 MB  /usr/bin/perl                                                                                                 -rw-r--r--         0:0      601 B  │   │   │   └── GXditview-color                                                                
    2        4.4 MB  /usr/lib/x86_64-linux-gnu/libc.so.6                                                                           -rw-r--r--         0:0      17 kB  │   │   ├── rgb.txt                                                                            
    2        2.1 MB  /usr/lib/x86_64-linux-gnu/libmvec.so.1                                                                        drwxr-xr-x         0:0        0 B  │   │   └── xorg.conf.d                                                                        
    2        1.9 MB  /usr/lib/x86_64-linux-gnu/libm.so.6                                                                           -rw-r--r--         0:0     3.0 kB  │   ├── adduser.conf                                                                           
    3        1.9 MB  /var/cache/debconf/templates.dat                                                                              drwxr-xr-x         0:0      100 B  │   ├── alternatives                                                                           
    6        1.3 MB  /var/log/dpkg.log                                                                                             -rw-r--r--         0:0      100 B  │   │   ├── README                                                                             
    2        1.3 MB  /var/cache/debconf/templates.dat-old                                                                          -rwxrwxrwx         0:0        0 B  │   │   ├── animate → /usr/bin/animate-im6.q16                                                 
    2        1.3 MB  /usr/lib/x86_64-linux-gnu/perl-base/auto/re/re.so                                                             -rwxrwxrwx         0:0        0 B  │   │   ├── animate-im6 → /usr/bin/animate-im6.q16                                             
    7        1.1 MB  /var/lib/dpkg/status                                                                                          -rwxrwxrwx         0:0        0 B  │   │   ├── awk → /usr/bin/mawk                                                                
    6        1.0 MB  /var/lib/dpkg/status-old                                                                                      -rwxrwxrwx         0:0        0 B  │   │   ├── c++ → /usr/bin/g++                                                                 
    2        946 kB  /usr/lib/x86_64-linux-gnu/gconv/libCNS.so                                                                     -rwxrwxrwx         0:0        0 B  │   │   ├── c89 → /usr/bin/c89-gcc                                                             
    2        801 kB  /usr/lib/x86_64-linux-gnu/perl-base/unicore/To/NFKCCF.pl                                                      -rwxrwxrwx         0:0        0 B  │   │   ├── c99 → /usr/bin/c99-gcc                                                             
    2        482 kB  /usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2                                                                -rwxrwxrwx         0:0        0 B  │   │   ├── cc → /usr/bin/gcc                                                                  
                                                                                                                                   -rwxrwxrwx         0:0        0 B  │   │   ├── compare → /usr/bin/compare-im6.q16                                                 
▏^C Quit ▏Tab Switch view ▏^F Filter ▏^L Show layer changes ▏^A Show aggregated changes ▏                                                                                                                                                                            
```

---


## ✪ ECR (Elastic Container Registry)
Reference docs: [Click here](https://docs.aws.amazon.com/cli/latest/reference/ecr/create-repository.html)

#### ◎ Creating a repository in ECR
```shell
aws ecr create-repository \
 --repository-name semantic_seg \
 --image-tag-mutability IMMUTABLE
```

Response:
```json
{
    "repository": {
        "repositoryArn": "arn:aws:ecr:us-east-1:1234567890:repository/semantic_seg",
        "registryId": "1234567890",
        "repositoryName": "semantic_seg",
        "repositoryUri": "1234567890.dkr.ecr.us-east-1.amazonaws.com/semantic_seg",
        "createdAt": 1716897097.518,
        "imageTagMutability": "IMMUTABLE",
        "imageScanningConfiguration": {
            "scanOnPush": false
        },
        "encryptionConfiguration": {
            "encryptionType": "AES256"
        }
    }
}
```

### ✪ Image push commands
#### ◎ Docker authentication
```shell
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 1234567890.dkr.ecr.us-east-1.amazonaws.com
```

Response:
```
WARNING! Your password will be stored unencrypted in /home/ubuntu/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

#### ◎ Build the Docker image
```shell
docker build -t semantic_seg:1.0 .
```
PS: setting the tag name as version (`1.0`)

Response
```
(base) ubuntu@ip-10-232-1-82:~/model_testing/docker_content$ docker build -t semantic_seg:1.0 .
[+] Building 186.0s (14/14) FINISHED                                                                                                                                                                                                           
 => [internal] load .dockerignore                                                                                                                                                                                                         0.0s
 => => transferring context: 67B                                                                                                                                                                                                          0.0s
 => [internal] load build definition from Dockerfile                                                                                                                                                                                      0.0s
 => => transferring dockerfile: 1.41kB                                                                                                                                                                                                    0.0s
 => [internal] load metadata for nvcr.io/nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04                                                                                                                                                    0.0s
 => [1/9] FROM nvcr.io/nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04                                                                                                                                                                      0.0s
 => [internal] load build context                                                                                                                                                                                                         0.0s
 => => transferring context: 8.66kB                                                                                                                                                                                                       0.0s
 => CACHED [2/9] WORKDIR /app                                                                                                                                                                                                             0.0s
 => [3/9] COPY ./scripts/ /app                                                                                                                                                                                                            0.0s
 => [4/9] COPY ./_tmp /app/                                                                                                                                                                                                               0.0s
 => [5/9] RUN mkdir -p /root/.cache/torch/hub/checkpoints                                                                                                                                                                                 0.3s
 => [6/9] COPY model_checkpoints/ /root/.cache/torch/hub/checkpoints                                                                                                                                                                      0.7s
 => [7/9] RUN apt-get update &&     apt-get install -y python3-pip     libgl1     libglib2.0-0    vim    awscli    && rm -rf /var/lib/apt/lists/*                                                                                        52.0s
 => [8/9] RUN pip install --no-cache-dir torch==2.2.2+cu118 torchvision==0.17.2+cu118 -f https://download.pytorch.org/whl/torch_stable.html                                                                                             100.4s
 => [9/9] RUN pip install --no-cache-dir opencv-python==4.9.0.80 pynvml==11.5.0 boto3==1.34.113                                                                                                                                           6.1s 
 => exporting to image                                                                                                                                                                                                                   26.3s 
 => => exporting layers                                                                                                                                                                                                                  26.3s 
 => => writing image sha256:f8e27ac93d6390a69326ef196dace02efd6e1705642cf0ccce2592bdb4650afd                                                                                                                                              0.0s 
 => => naming to docker.io/library/semantic_seg:1.0                                                                                                                                                                                       0.0s 
```


#### ◎ Creating a tag for image to be pushed
```shell
docker tag semantic_seg:1.0 1234567890.dkr.ecr.us-east-1.amazonaws.com/semantic_seg:1.0
```

#### ◎ Pushing the image to ECR
```shell
docker push 1234567890.dkr.ecr.us-east-1.amazonaws.com/semantic_seg:1.0
```

Response
```
The push refers to repository [1234567890.dkr.ecr.us-east-1.amazonaws.com/semantic_seg]
dee15334da15: Pushed 
b8420ccd9944: Pushed 
5f1b80aa73aa: Pushed 
e82ed955a7ff: Pushed 
a32270201deb: Pushed 
38de5c544645: Pushed 
3033af6a33f8: Pushed 
10e955256b3d: Pushed 
04b6eafdd5ee: Pushed 
345cfa465206: Pushed 
dcb0f55f81ad: Pushed 
399d155a03b0: Pushed 
bc352a27a0e4: Pushed 
498bbcc60d01: Pushed 
c0e21dcee623: Pushed 
d6b19a46b795: Pushed 
e6c05e83c163: Pushed 
256d88da4185: Pushed 
1.0: digest: sha256:c72c1bd61efd413f0df482634b241551192b7d044e6ef1b3b501f5be0c85ed14 size: 4100
```

### ✪ Listing and deleting the containers in ECR
Read from official AWS docs: [Click here](https://docs.aws.amazon.com/AmazonECR/latest/userguide/delete_image.html) 

#### ◎ List all the containers in the repository
```shell
aws ecr list-images --repository-name semantic_seg
```

Response:
```json
{
    "imageIds": [
        {
            "imageDigest": "sha256:1905c8410e4c28012adebad8ecd1b4e0d0718efda7479b3aa0c321f774dbb7b4",
            "imageTag": "gpu_enabled"
        },
        {
            "imageDigest": "sha256:6ddc60285c6bc2f8b3bca88b005d587c6484f3978fc90cb73fbf202a84e22126",
            "imageTag": "pure_cpu"
        }
    ]
}
```

#### ◎ Deleting a particular container tag
```shell
aws ecr batch-delete-image \
    --repository-name semantic_seg \ 
    --image-ids imageDigest=sha256:9359bbcce522ceba67cc1a6f8505ebed4978d232babc7e677b6e4b89d429b2b9
```

## ✪ [IMP] Local testing of the AWS (container) Lambda
- In _first_ terminal, run the following:
```shell
docker run --rm -p 9000:8080 -it --name=semantic_container semantic_seg:pure_cpu
```

- Create a `event.json` file which contains the input for the `lambda_function.lambda_handler` function
```json
{
  "INPUT_BUCKET": "test-images-ml",
  "INPUT_DIR": "camera_2",
  "INPUT_FILE_PATH": "camera_2/image-01400.png",
  "MASK_BUCKET": "test-images-ml",
  "MASK_FILE_PATH": "mask_2.png",
  "OUTPUT_BUCKET": "test-images-ml",
  "OUTPUT_DIR": "test_outputs"
}
```

- In _other_ terminal, run the following (from the directory where `event.json` file is present):
```shell
curl -X PUT -d @event.json "http://localhost:9000/2015-03-31/functions/function/invocations" > output.json
```

Response:
```
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   248    0     4  100   244      0     36  0:00:06  0:00:06 --:--:--     0
```

- To check the content of container, run the following
```shell
docker run --rm --entrypoint /bin/bash -it --name=semantic_container semantic_seg:lambda_cpu
```

- To check the logs of container without entering it
```shell
docker logs semantic_container
```

Response:
```
11 Jun 2024 05:38:12,877 [INFO] (rapid) exec '/var/runtime/bootstrap' (cwd=/var/task, handler=)
START RequestId: 0aa0cd01-a398-4799-996a-da6c3dcab143 Version: $LATEST
11 Jun 2024 05:38:34,443 [INFO] (rapid) INIT START(type: on-demand, phase: init)
11 Jun 2024 05:38:34,443 [INFO] (rapid) The extension's directory "/opt/extensions" does not exist, assuming no extensions to be loaded.
11 Jun 2024 05:38:34,443 [INFO] (rapid) Starting runtime without AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN , Expected?: false
11 Jun 2024 05:38:36,643 [INFO] (rapid) INIT RTDONE(status: success)
11 Jun 2024 05:38:36,643 [INFO] (rapid) INIT REPORT(durationMs: 2200.017000)
11 Jun 2024 05:38:36,643 [INFO] (rapid) INVOKE START(requestId: 22a99b2d-e546-4f7d-8a8f-bc7e70c0ca38)
Created pointer to s3.
Downloaded mask_2.png to /tmp/mask_2.png
Downloaded camera_2/image-01400.png to /tmp/image-01400.png
Labels with scores: [('car', 0.99743), ('car', 0.98161143), ('car', 0.9715668), ('car', 0.9557771), ('car', 0.81839067), ('car', 0.76555645)]
Time elapsed for processing image-01400.png: 2.33secs
11 Jun 2024 05:38:41,103 [INFO] (rapid) INVOKE RTDONE(status: success, produced bytes: 0, duration: 4459.703000ms)
END RequestId: 22a99b2d-e546-4f7d-8a8f-bc7e70c0ca38
REPORT RequestId: 22a99b2d-e546-4f7d-8a8f-bc7e70c0ca38  Init Duration: 0.04 ms  Duration: 6659.90 ms    Billed Duration: 6660 ms        Memory Size: 3008 MB    Max Memory Used: 3008 MB
```

---


- Checking in AWS ECR
  - Navigate to AWS ECR
  - Search for the created repository
  - Go in and check the recently pushed tag and previous versions