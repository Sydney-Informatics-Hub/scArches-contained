# MegaDetector 5 Container

Docker/Singularity image to run [Megadetector 5](https://github.com/microsoft/CameraTraps/blob/master/megadetector.md) on Centos 6.9 kernel (Ubuntu 16.04) with GPU support.

Cuda, torch, etc versions have been modifed from the [original conda environment](https://github.com/microsoft/CameraTraps/blob/main/environment-detector.yml). Other combinations may work.

If you have used this work for a publication, you must acknowledge SIH, e.g: "The authors acknowledge the technical assistance provided by the Sydney Informatics Hub, a Core Research Facility of the University of Sydney."

If you don't want to build anything, you can download the singularity image directly from [here.](https://unisyd-my.sharepoint.com/:u:/g/personal/nathaniel_butterworth_sydney_edu_au/EXSMNJ0ek3FBmMFBQUvLXOoBFjvVDY82fGBLVR_h4yO9JA?e=SPhHTl)

# Build with docker
```
sudo docker build . -t nbutter/megadetector:ubuntu1604
```

# Run with docker.
To run this, mounting your current host directory in the container directory, at /project, and execute a run on the test images (that live in the container) run:
```
sudo docker run --gpus all -it -v `pwd`:/project nbutter/megadetector:ubuntu1604 /bin/bash -c "cd /project && python /build/cameratraps/detection/run_detector_batch.py /build/blobs/md_v5b.0.0.pt /build/cameratraps/test_images/test_images/ mdv4test.json --output_relative_filenames --recursive"
```

# Push to docker hub
```
sudo docker push nbutter/megadetector:ubuntu1604
```

See the repo at [https://hub.docker.com/r/nbutter/megadetector](https://hub.docker.com/r/nbutter/megadetector)


# Build with singularity
```
sudo singularity build mega.img docker://nbutter/megadetector:ubuntu1604
```

# Run with singularity
To run the singularity image (noting singularity mounts the current folder by default)
```
singularity run --nv mega.img /bin/bash -c "python /build/cameratraps/detection/run_detector_batch.py /build/blobs/md_v5b.0.0.pt /build/cameratraps/test_images/test_images/ mdv4test.json --output_relative_filenames --recursive"
```
