# scArches Container

Docker/Singularity image to run [scArches](https://scarches.readthedocs.io/en/latest/) on Centos 6.9 kernel (Ubuntu 16.04) with GPU support.


If you have used this work for a publication, you must acknowledge SIH, e.g: "The authors acknowledge the technical assistance provided by the Sydney Informatics Hub, a Core Research Facility of the University of Sydney."


# Quickstart for Artemis

Put it on Artemis e.g.
```
cd /project/<YOUR_PROJECT>
git clone https://github.com/Sydney-Informatics-Hub/scArches-contained.git
```
Then `cd scArches-contained` and modify the `run_artemis.pbs` script and launch with `qsub run_artemis.pbs`.

Otherwise here are the full instructions for getting there....


# How to recreate

## Build with docker
Check out this repo then build the Docker file.
```
sudo docker build . -t nbutter/scarches:ubuntu1604
```

## Run with docker.
To run this, mounting your current host directory in the container directory, at /project, and execute a run on the test images (that live in the container) run:
```
sudo docker run --gpus all -it -v `pwd`:/project nbutter/scarches:ubuntu1604 /bin/bash -c "cd /project && python example_Unsupervised_surgery_pipeline_with_SCVI.py"
```

## Push to docker hub
```
sudo docker push nbutter/scarches:ubuntu1604
```

See the repo at [https://hub.docker.com/r/nbutter/scarches](https://hub.docker.com/r/nbutter/scarches)


## Build with singularity
```
export SINGLUARITY_CACHEDIR=`pwd`
export SINGLUARITY_TMPDIR=`pwd`

singularity build scarches.img docker://nbutter/scarches:ubuntu1604
```

## Run with singularity
To run the singularity image (noting singularity mounts the current folder by default)
```
singularity run --nv --bind /project:/project scarches.img /bin/bash -c "cd "$PBS_O_WORKDIR" && python example_Unsupervised_surgery_pipeline_with_SCVI.py"
```
