## Jenkins Docker Images
This project contains Docker images based off the official Jenkins CI images.  The main difference from the base images is that the Docker package is installed and `jenkins` user updated.  This allows Jenkins to execute Docker commands against an outside daemon, known as Docker outside of Docker (i.e. DooD).

#### DooD
Docker outside of Docker is when the Docker CLI (or API) that gets executed within a container communicates with the daemon that is running said container.  This is accomplished by exposing the Docker socket to a container on startup:
```
-v /var/run/docker.sock:/var/run/docker.sock
```
For more detailed info about this read Jérôme Petazzoni's [blog](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/) 

### Server
More documentation for the server can be found at the official sites for the [Docker image](https://hub.docker.com/r/jenkinsci/jenkins/) and [GitHub repo](https://github.com/jenkinsci/docker).

To build the image:
```
$ docker build -t jenkins-server --build-arg executors=4 ./server
```
The `executors` build argument is optional.  The build downloads the plugins found in `./server/conf/plugins.txt` so this takes some time.

To start the container:
```
$ docker run -d --name jenkins-server \
	-p 8080:8080 -p 50000:50000 \
	-v /var/jenkins_home \
	-v /var/run/docker.sock:/var/run/docker.sock \
	jenkins-server
```

#### Persisting Data
In most cases, server data needs to be persisted across container starts so it is a good idea to either backup the `/var/jenkins_home` directory or use a data volume mounted to an external file system.

[Here is a blog](https://aws.amazon.com/blogs/compute/using-amazon-efs-to-persist-data-from-amazon-ecs-containers/) that documents how to accomplish this using AWS EFS.

### Agent
More documentation for the agent can be found at the official sites for the [Docker image](https://hub.docker.com/r/jenkinsci/jnlp-slave/) and [GitHub repo](https://github.com/jenkinsci/docker-jnlp-slave).

To build the image:
```
$ docker build -t jenkins-agent ./agent
```
Before the agent container can be started, it must be added as a node to the server.  One way to do this is through the Jenkins CI web UI on the server.

1. Select ***Manage Jenkins > Manage Nodes > New Node***

2. Enter a name for the agent and select the `Permanent agent` option

3. Set `Remote root directory` to `/var/jenkins_home`

4. Make sure `Launch method` is set to `Launch agent via Java Web Start`

5. Enter any desired setting for `Description`, `# of executors`, `Labels`, and `Node Properties`

6. Click `Save`

7. Navigate to the new node's overview page by either selecting the new node or using the URL of the form `http://<server>:<port>/computer/<agent>`

8. Make note of the secret in the java command displayed as it is needed for the agent container to start

To start the container:
```
$ docker run -d --name jenkins-agent \
	--link jenkins-server \
	-e JENKINS_URL=http://jenkins-server:8080 \
	-e JENKINS_SECRET=<secret> \
	-e JENKINS_AGENT_NAME=<agent> \
	jenkins-agent
```
