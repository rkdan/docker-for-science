# Our first steps with Docker

Here we will get up and running with Docker, and introduce some basic commands.

## Installing Docker
You can install Docker from the [official website](https://docs.docker.com/get-docker/). Your experience may vary depending on your operating system. Take careful note of the requirements, especially for Windows - you will need the Windows Subsystem for Linux (WSL) enabled, which should come as standard on Windows 10 and later.

For windows users, we will be working in WSL terminal. This means you will need to setup VSCode to be using the WSL terminal by default. You can do this by opening the command palette (Ctrl+Shift+P) and typing `Terminal: Select Default Shell`. You can then select `WSL Bash` from the list.

For MacOS and Linux users, your lives are easier. You can just use the terminal as normal. From here on out, we'll assume you're using the terminal.

## Running your first container
Once you have Docker installed, you can run your first container. Open a terminal and type the following command:

```bash
docker run hello-world
```

This will download the `hello-world` image from the Docker Hub and run it. You should see the following:
    
```bash
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
478afc919002: Pull complete
Digest: sha256:a26bff933ddc26d5cdf7faa98b4ae1e3ec20c4985e6f87ac0973052224d24302
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (arm64v8)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

If you check out the Docker Desktop, you will now see that the `hello-world` image is downloaded and running. To see a list of images, run

```bash
docker image ls -a
```

and to see a list of containers, run

```bash
docker container ls -a
```

## Running an interactive container
Now here is where things get really interesting. Run the following command:

```bash
docker run -it ubuntu
```

You should something like the following:

```bash
root@ba2346677656:/#
```

Now enter,

```bash
cat /etc/os-release
```

You should see something like:

```bash
PRETTY_NAME="Ubuntu 24.04 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
```

So we have learned that we are no longer using the host machine command line, but in a container running Ubuntu 24.04 LTS. This is a powerful concept, as it allows us to run software in a controlled environment, without having to worry about dependencies!

We can stop the container by typing `exit`, but we will keep it running for now.

Create a new directory called `workspace`:

```
mkdir workspaces && cd workspaces.
```

Open up VSCode and install the Remote Development extension. Once this is installed, connect to the container that is now running. We now have a fully functional Ubuntu environment running in a container and accessible from VSCode!

Just to really hammer home how powerful this is, we now no longer have to worry about installing software on our host machine. We don't have to worry about managing dependencies and environments, because this IS our environment!

Through this workshop we will build a small machine learning project in this container and deploy it on a remote GPU. We will learn how to make our own containers, upload them to Docker Hub and build off of them. We will also learn how to use Docker in a CI/CD pipeline.



## Further reading
<div class="grid cards" markdown>

-   :fontawesome-solid-book-open:{ .lg .middle } [__CI/CD - Testing resources__](../resources/references.md#cicd-testing)

    ---
    Information on GitHub Workflows

</div>