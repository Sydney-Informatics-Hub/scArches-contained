#To build this file:
#sudo docker build . -t nbutter/megadetector:ubuntu1604

#To run this, mounting your current host directory in the container directory,
# at /project, and excute the check_installtion script which is in your current
# working direcotry run:
#sudo docker run --gpus all -it -v `pwd`:/project nbutter/megadetector:ubuntu1604 /bin/bash -c "cd /project && python /build/cameratraps/detection/run_detector_batch.py /build/blobs/md_v5a.0.0.pt /build/cameratraps/test_images/test_images/ mdv4test.json --output_relative_filenames --recursive"

#To push to docker hub:
#sudo docker push nbutter/megadetector:ubuntu1604

#To build a singularity container
#sudo singularity build mega.img docker://nbutter/megadetector:ubuntu1604

#To run the singularity image (noting singularity mounts the current folder by default)
#singularity run --nv mega.img python /build/cameratraps/detection/run_detector_batch.py /build/blobs/md_v5a.0.0.pt /build/cameratraps/test_images/test_images/ mdv4test.json --output_relative_filenames --recursive

# Pull base image.
FROM nvidia/cuda:10.2-cudnn8-devel-ubuntu16.04
MAINTAINER Nathaniel Butterworth USYD SIH

# Set up ubuntu dependencies
RUN apt-get update -y && \
  apt-get install -y wget git build-essential git curl libgl1 libglib2.0-0 libsm6 libxrender1 libxext6 && \
  rm -rf /var/lib/apt/lists/*

# Make the dir everything will go in
WORKDIR /build

# Intall anaconda
ENV PATH="/build/miniconda3/bin:${PATH}"
ARG PATH="/build/miniconda3/bin:${PATH}"
RUN curl -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh &&\
	mkdir /build/.conda && \
	bash miniconda.sh -b -p /build/miniconda3 &&\
	rm -rf miniconda.sh

RUN conda --version

# Install camera traps and dependencies
ENV PYTHONPATH="$PYTHONPATH:/build/cameratraps:/build/ai4eutils:/build/yolov5"
ARG PYTHONPATH="$PYTHONPATH:/build/cameratraps:/build/ai4eutils:/build/yolov5"

RUN git clone https://github.com/Microsoft/cameratraps
# RUN conda env update --file cameratraps/environment-detector.yml --prune

RUN git clone https://github.com/Microsoft/ai4eutils
RUN git clone https://github.com/ultralytics/yolov5/ && \
  cd yolov5 && git checkout c23a441c9df7ca9b1f275e8c8719c949269160d1

# Get one of the model files
RUN mkdir blobs
# RUN wget -O blobs/md_v5a.0.0.pt https://github.com/microsoft/CameraTraps/releases/download/v5.0/md_v5a.0.0.pt
RUN wget -O blobs/md_v5b.0.0.pt https://github.com/microsoft/CameraTraps/releases/download/v5.0/md_v5b.0.0.pt

# Finally, set up the conda env in the base
RUN conda install Pillow=9.1.0 nb_conda_kernels ipykernel tqdm jsonpickle humanfriendly numpy matplotlib opencv requests pandas seaborn>=0.11.0 PyYAML>=5.3.1 pytorch::pytorch=1.10.1 pytorch::torchvision=0.11.2 conda-forge::cudatoolkit=10.2 conda-forge::cudnn=8.1 -c conda-forge


RUN mkdir /project /scratch
CMD /bin/bash
#
