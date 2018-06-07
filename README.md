# e-pad Docker

This is the e-pad software, and specifically work to Dockerize (docker-compose) and then convert the software to work on a kubernetes cluster. This software is [licensed](LICENSE) to the [Rubin Lab](https://rubinlab.stanford.edu) at Stanford. For official use and download, please see [epad.stanford.edu](https://epad.stanford.edu).

## Docker Compose

First, run the [setup.sh](setup.sh) script to download a needed jar and war file, and create local directories. You should run it from this directory with the Github repository and docker-compose.yml file.

```bash
chmod u+x setup.sh
./setup.sh
```

Then, pull and bring up the containers:

```bash
docker-compose up -d
```

The `-d` means detached, and when you first do this, likely the images will be pulled from [Docker Hub](https://hub.docker.com/u/rubinlab/).
