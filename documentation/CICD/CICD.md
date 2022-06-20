# CI/CD
## Overview
- Etoet uses CI/CD (Continuous Integration/ Continuous Delivery) method to ensure that all new changes in codebase are regularly built, tested, and merged to the shared repository.
- Etoet's Pipeline consists of runners which automatically runs whenever there is a push from local to remote. The pipeline uses a custom docker image created from a custom Dockerfile.

## Docker
Docker is an open platform for developing, shipping, and running applications.
### Dockerfile
- Docker can build images automatically by reading the instructions from a `Dockerfile`. A `Dockerfile` is a text document that contains all the commands a user could call on the command line to assemble an image.
- Etoet uses Ubuntu as the base image in the Dockerfile.
### Docker Image
- A Docker image is made up of a collection of files that bundle together all the essentials – such as installations, application code, and dependencies – required to configure a fully operational container environment.
- Etoet's image consists of Flutter and Android SDK to build and run unit tests.
- Etoet's image is hosted at:  https://hub.docker.com/repository/docker/teresuki/test
### Docker Container
- Docker container is a running instance of a docker image, containers can be saved as snapshots to create other docker images.
## Etoet's Pineline
- Each time Etoet's pipeline is triggered, 2 phases are run by Gitlab Runners using our custom image.
- The phases are build and (run) unit tests.
- The result is either `passed` or `failed`.

![Pipeline Passed](https://gcdnb.pbrd.co/images/5WO83JplwAew.png?o=1)

![Pipeline Failed](https://gcdnb.pbrd.co/images/g3Zj75Ps7K8z.png?o=1)
