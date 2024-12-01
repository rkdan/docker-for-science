# Hello, world!
As a reminder, when we ran the `hello-world` image, we saw the following output:
```bash
$ docker run hello-world
```
```bash
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
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

As a simple first step, let's try and recreate this image from scratch. We will create a new directory called `hello-world` and create a new file called `Dockerfile` inside it. The contents of the `Dockerfile` will be as follows:
```Dockerfile
# Use a minimal base image
FROM alpine:latest

# Create a simple script that will be our executable
COPY hello.sh /
RUN chmod +x /hello.sh

# Set the script as our container's entry point
ENTRYPOINT ["/hello.sh"]
```

and also create a new file called `hello.sh` with the following contents:
```bash
#!/bin/sh

echo "Hello from your custom Docker container!"
echo "This message demonstrates that you've successfully:"
echo ""
echo " 1. Built a custom Docker image from a Dockerfile"
echo " 2. Created a container from that image"
echo " 3. Executed a script inside the container"
echo " 4. Had the output streamed back to your terminal"
echo ""
echo "Things this example demonstrates:"
echo " - Using a base image (alpine:latest)"
echo " - Copying files into a container"
echo " - Setting file permissions"
echo " - Using ENTRYPOINT to define container behavior"
echo ""
echo "Try these next steps:"
echo " 1. Look at the Dockerfile to see how this works"
echo " 2. Modify the script to print different messages"
echo " 3. Rebuild the image to see your changes"
echo ""
echo "Happy Dockerizing! 🐳"
```

We can now run
```bash
docker build -t my-hello-world .
```

and then
```bash
docker run my-hello-world
```

and we should see the following output:
```text
Hello from your custom Docker container!
This message demonstrates that you've successfully:

 1. Built a custom Docker image from a Dockerfile
 2. Created a container from that image
 3. Executed a script inside the container
 4. Had the output streamed back to your terminal

Things this example demonstrates:
 - Using a base image (alpine:latest)
 - Copying files into a container
 - Setting file permissions
 - Using ENTRYPOINT to define container behavior

Try these next steps:
 1. Look at the Dockerfile to see how this works
 2. Modify the script to print different messages
 3. Rebuild the image to see your changes

Happy Dockerizing! 🐳
```

Let's try something harder...