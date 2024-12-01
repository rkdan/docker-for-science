# Docker Repositories
But where to store your images so that other people can use them? We have two options:

1. **Docker Hub**: The default registry for Docker images. It is free to use for public repositories, but you have to pay for private repositories.
2. **GitHub Container Registry**: GitHub's own registry for Docker images. It is free to use for public and private repositories.

We will cover both options here.

## Docker Hub
When we pulled those basic Ubuntu and Python images, we were actually pulling them from Docker Hub. Docker Hub is the default registry for Docker images.

First, we go to our docker hub repository tab and create a new repository. We can name it anything we want. For this example, we will name it `cancer-prediction`.

We then need to login in our command line:
    
```bash
docker login --username=yourhubusername
```

You will then be prompted for your password. We can now run:

```bash
docker push acceleratescience/cancer-prediction:latest
```

When you navigate to your repository on Docker Hub, you should see your image there.

You could now pull this image and it should run with:

```bash
docker run -p 8888:8888 acceleratescience/cancer-prediction:latest
```

Success! You have now built and pushed your own Docker image to Docker Hub, downloaded it, and run it. If you package up your research in this way, other people will be able to do the same thing. And notice that everything inside the container just works, even though it was built on your machine.

## Automate this process
Ideally, we would want to actually automate this process of pushing new versions to Docker Hub. We can do this by setting up a GitHub action. We will also use this opportunity to push to the GitHub Container Registry.

### The GitHub Action
Create a new file in your repository at `.github/workflows/docker-publish.yml` with the following content:

```yaml
# This workflow uses actions that are not certified by GitHub.
# They are provided by a third-party and are governed by
# separate terms of service, privacy policy, and support
# documentation.

# GitHub recommends pinning actions to a commit SHA.
# To get a newer version, you will need to update the SHA.
# You can also reference a tag or branch, but the action may change without warning.

name: Publish Docker image

on:
  release:
    types: [published]

jobs:
  push_to_registry:
    name: Push Docker image to Docker Hub
    runs-on: ubuntu-latest
    permissions:
      packages: write
      contents: read
      attestations: write
      id-token: write
    steps:
      - name: Check out the repo
        uses: actions/checkout@v4

      - name: Log in to Docker Hub
        uses: docker/login-action@f4ef78c080cd8ba55a85445d5b36e214a81df20a
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Extract metadata (tags, labels) for Docker
        id: meta
        uses: docker/metadata-action@9ec57ed1fcdbf14dcef7dfbe97b2010124a938b7
        with:
          images: my-docker-hub-namespace/my-docker-hub-repository

      - name: Build and push Docker image
        id: push
        uses: docker/build-push-action@3b5e8027fcad23fda98b2e3ac259d8d67585f671
        with:
          context: .
          file: ./Dockerfile
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
```

The important thing here is to replace
```yaml
with:
  images: my-docker-hub-namespace/my-docker-hub-repository
```
with you actual Docker Hub user name and the repo name (which is cancer-prediction in our case).

You will also need to add your Docker Hub username and password as secrets in your repository. You can do this by going to your repository, clicking on settings, and then secrets.

### Create a new release
Head back over to GitHub and create a new release. You can do this by clicking on the releases tab and then clicking on the "Draft a new release" button. You can name the release anything you want. You can also add a description if you want. You should add a tag, such as `v0.0.1` and make sure you are targeting the correct branch. In this case, we are on the `start` branch.

Finally, click "Publish release". You should now see your GitHub action running. If you navigate to the actions tab, you can see the progress of the action. If it is successful, you should see your image on Docker Hub.

### Adding the GitHub Container Registry

We can reuse most of what we have already built, and add a few more lines:

```yaml
# This workflow uses actions that are not certified by GitHub.
# They are provided by a third-party and are governed by
# separate terms of service, privacy policy, and support
# documentation.

# GitHub recommends pinning actions to a commit SHA.
# To get a newer version, you will need to update the SHA.
# You can also reference a tag or branch, but the action may change without warning.

name: Publish Docker image

on:
  release:
    types: [published]

jobs:
  push_to_registries:
    name: Push Docker image to multiple registries
    runs-on: ubuntu-latest
    permissions:
      packages: write
      contents: read
      attestations: write
      id-token: write
    steps:
      - name: Check out the repo
        uses: actions/checkout@v4

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Log in to Docker Hub
        uses: docker/login-action@f4ef78c080cd8ba55a85445d5b36e214a81df20a
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Log in to the Container registry
        uses: docker/login-action@65b78e6e13532edd9afa3aa52ac7964289d1a9c1
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract metadata (tags, labels) for Docker
        id: meta
        uses: docker/metadata-action@9ec57ed1fcdbf14dcef7dfbe97b2010124a938b7
        with:
          images: |
            acceleratescience/cancer-prediction
            ghcr.io/${{ github.repository_owner }}/cancer-prediction

      - name: Build and push Docker images
        id: push
        uses: docker/build-push-action@3b5e8027fcad23fda98b2e3ac259d8d67585f671
        with:
          context: .
          push: true
          platforms: linux/amd64,linux/arm64
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
```

### Multiplatform builds
Notice at the end here, we have added: 
```yaml
platforms: linux/amd64,linux/arm64
```
This is because the GitHub Container Registry supports multiple architectures. A multi-platform build refers to a single build invocation that targets multiple different operating system or CPU architecture combinations. When building images, this lets you create a single image that can run on multiple platforms, such as `linux/amd64`, `linux/arm64`, and `windows/amd64`

Although Docker for the most part solves the "it works on my machine" problem by packaging applications and their dependencies into containers. This actually only solves _part_ of the problem. Containers share the host kernel, which means that the code that's running inside the container must be compatible with the host's architecture. **This means that you cannot run a linux/amd64 container on an arm64 host** (without using emulation), **or a Windows container on a Linux host**.

Multi-platform builds solve this problem by packaging multiple variants of the same application into a single image. This enables you to run the same image on different types of hardware, such as development machines running x86-64 or ARM-based Amazon EC2 instances in the cloud, without the need for emulation.

Multiplatform builts typically take longer to create, but they are worth it for the flexibility they provide - some people may have MacOS and some may be using Linux.