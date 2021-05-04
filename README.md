# RShinyMusicBandApp

In order to deploy this as a docker image you can either create your own image from this git repo or use the docker image from my dockerhub.

## Using git repo:

### Installation:

* Please download and install GIT from: https://git-scm.com/download/win
* Please download and install Docker desktop for windows from https://desktop.docker.com/win/stable/amd64/Docker%20Desktop%20Installer.exe

### Clone:

The code can be cloned from the GIT URL: https://github.com/ramesh-suragam/RShinyMusicBandApp.git. Use the below code:
```bash
git clone https://github.com/ramesh-suragam/RShinyMusicBandApp.git
```
### Creating docker image:

Once the git repo is cloned you can create a docker image from CLI(cmd) using the below code:
```bash
docker build -t musicband .
```
Make sure that you are in the git repo folder with 'dockerfile' file.

### Creating docker container:

You may create the docker container using the docker desktop GUI utility installed above or use the CLI method by running the below:

```bash
docker run -p 127.0.0.1:3838:3838/tcp -it -d musicband
```

Use the below command to view all running containers:
```bash
docker ps
```

Use the below command to stop the running container. Get the container ID from the above command.
```bash
docker stop <container ID>
```

Use the below command to view all running and exited containers:
```bash
docker ps -a
```

Use the below command to remove a stopped container. Get the container ID from the above command.
```bash
docker rm <container ID>
```

Use the below command to remove an image. Get the Image ID from the command 'docker images'.
```bash
docker rmi <Image ID>
```
## Using Docker image:

### Installation:
* Please download and install Docker desktop for windows from https://desktop.docker.com/win/stable/amd64/Docker%20Desktop%20Installer.exe
* Make sure you login to the docker

Run the below command to pull the docker image from docker Hub:
```bash
docker pull rameshsuragam/musicband:0.0.1
```

You may create the docker container using the docker desktop GUI utility installed above or use the CLI method by running the below:

```bash
docker run -p 127.0.0.1:3838:3838/tcp -it -d rameshsuragam/musicband:0.0.1
```

Use the below command to view all running containers:
```bash
docker ps
```

Use the below command to stop the running container. Get the container ID from the above command.
```bash
docker stop <container ID>
```

Use the below command to view all running and exited containers:
```bash
docker ps -a
```

Use the below command to remove a stopped container. Get the container ID from the above command.
```bash
docker rm <container ID>
```

Use the below command to remove an image. Get the Image ID from the command 'docker images'.
```bash
docker rmi <Image ID>
```
### Accessing the App:

After a container is created from docker image, access the RShiny app using the link http://localhost:3838

##  Authors
Ramesh Suragam

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
