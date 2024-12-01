# Building your own images

## Project overview
In this section we will build our own images using Dockerfiles. In order to demonstrate the process, we will have some example project files. In the `cancer-prediction` directory, we have the following:

```bash
├── cancer_prediction
│   ├── cancer_model.py
│   ├── data
│   │   ├── breast_cancer.csv
│   │   ├── breast_cancer_test.csv
│   │   └── breast_cancer_train.csv
│   ├── models
│   │   └── cancer_model.pkl
│   └── notebook.ipynb
└── requirements.txt
```

We might want our collaborators to be able to run all of the code in the `cancer-prediction` directory without having to install all of the dependencies. We can create a Dockerfile to build an image that contains all of the dependencies and code needed to run the project.

You should fork this repository (include all branches, not just `main`). Then create a new Codespace on the `start` branch. You should then see the above directory plus some other stuff like a LICENSE file and a README.md file.

This overview sets us up to dive deeper into each of these concepts and see how they work in practice with our machine learning project.

## Our Dockerfile
Here is the Dockerfile:

```Dockerfile
# Start from an official Python base image
FROM python:3.11-slim-bookworm

# Install git and clean up apt cache in the same layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory in the container
WORKDIR /workspace

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install dependencies - combine commands to reduce layers
RUN pip install --no-cache-dir \
    jupyterlab \
    jupyterlab-git \
    httpx==0.27.2 \
    -r requirements.txt

# Copy the entire project
COPY . .

# Expose the port Jupyter will run on
EXPOSE 8888

# Start Jupyter Lab from the cancer_prediction directory
WORKDIR /workspace/cancer-prediction
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--LabApp.token=''", "--LabApp.password=''"]
```

Let's walkthrough the Dockerfile.

**`FROM python:3.11-slim-bookworm`**

- Starts with official Python 3.11 image
- 'slim-bookworm' means minimal Debian Bookworm-based image, reducing container size
- Alternative to full image which includes many unnecessary packages

**`RUN apt-get update && ...`**

- Installs git for version control
- Cleans up apt cache to reduce image size
- Combines commands to reduce layers

**`WORKDIR /workspace`**

- Creates and sets the working directory to /workspace
- All subsequent commands will run from this directory
- Standard practice for development containers

**`COPY requirements.txt .`**

- Copies only requirements.txt first
- Helps with build caching - if requirements don't change, cache this layer
- The '.' means copy to current WORKDIR

**`RUN pip install --no-cache-dir \ jupyterlab \ -r requirements.txt`**

- Installs Python packages
- `--no-cache-dir` reduces image size by not caching pip downloads
- Combines installations in one RUN to create single layer
- Backslashes allow multiple lines for readability

**`COPY . .`**

- Copies all remaining project files
- First '.' means everything in build context
- Second '.' means copy to current WORKDIR
- Done after requirements for better caching

**`USER jupyter`**

- Switches to non-root user
- All subsequent commands run as this user

**`EXPOSE 8888`**

- Documents that container uses port 8888
- Doesn't actually open port - that's done at runtime
- JupyterLab's default port

**`WORKDIR /workspace/cancer_prediction`**

- Changes working directory again
- Ensures Jupyter starts in project directory

**`CMD ["jupyter", "lab", "--ip=0.0.0.0" ...]`**

- Command to run when container starts
- `--ip=0.0.0.0` allows external connections
- `--no-browser` since running in container
- Empty token/password for workshop access

## Building the image

To build the image, run the following command in the terminal:

```bash
docker build -t cancer-prediction .
```

This command builds the image using the Dockerfile in the current directory and tags it with the name `cancer-prediction`.

## Running the container

To run the container, use the following command:

```bash
docker run -p 8888:8888 cancer-prediction
```

You should see the Jupyter Lab URL open in the browser. If you run something in the notebook and save it, the changes will **not** persist in the container. To achieve this, you will need to mount your volume directory when running the container:

```bash
docker run -p 8888:8888 -v $(pwd):/workspace cancer-prediction
```
