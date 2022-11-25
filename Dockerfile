#To build this file:
#sudo docker build . -t nbutter/scarches:ubuntu1604


#To run this, mounting your current host directory in the container directory,
# at /project, and excute the check_installtion script which is in your current
# working direcotry run:
#sudo docker run --gpus all -it -v `pwd`:/project nbutter/scarches:ubuntu1604 /bin/bash -c "cd /project && python example_Unsupervised_surgery_pipeline_with_SCVI.py"
#To push to docker hub:
#sudo docker push nbutter/scarches:ubuntu1604

#To build a singularity container
#singularity build scarches.img docker://nbutter/scarches:ubuntu1604

#To run the singularity image (noting singularity mounts the current folder by default)
#singularity run --nv scarches.img python /build/cameratraps/detection/run_detector_batch.py /build/blobs/md_v5a.0.0.pt /build/cameratraps/test_images/test_images/ mdv4test.json --output_relative_filenames --recursive

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

RUN pip install -U scarches
RUN pip install leidenalg

RUN conda clean -a -y
RUN pip cache purge

RUN mkdir /project /scratch
CMD /bin/bash
#
