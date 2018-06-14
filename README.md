# e-pad Docker

This is the e-pad software, and specifically work to Dockerize (docker-compose) and then convert the software to work on a kubernetes cluster. This software is [licensed](LICENSE) to the [Rubin Lab](https://rubinlab.stanford.edu) at Stanford. For official use and download, please see [epad.stanford.edu](https://epad.stanford.edu).

## Docker Compose

I can't get this to work with one swift command. We have to define all endpoints in the
docker-compose, but then run a script (with a 10 second sleep) to bring up the mysql
first, followed by the remainder.

```bash
chmod u+x setup.sh
./setup.sh
```

The web interface at [localhost:8080/epad](http://localhost:8080/epad) seems to 
exist, but it takes easily a minute to show up.

## Kubernetes

To use the kubernetes deployment, see the files in [kubernetes](kubernetes).
You will want to use the [deploy.sh](kubernetes/deploy.sh) script to bring up
the cluster.
