# Volumes

We just saw that containers are stateless - when we created a directory and then started a new container, our directory was gone. This is actually a feature, not a bug! It ensures that every time someone runs your container, they start with the exact same environment. But what if we do need to save data or share files between our computer and the container?

## Introducing Volumes

Volumes are how we share files and folders between our computer (the "host") and the container. Think of them like a shared folder that both can see and modify.

Let's try this:

```bash
# Create a folder for our work
mkdir myproject
cd myproject

# Create a simple Python script
echo "print('Hello from the host!')" > script.py

# Run Python container with current directory mounted
docker run -v $(pwd):/work python:3.9 python /work/script.py
```

Let's break down what happened:
- `-v $(pwd):/work` creates a volume:
  - `$(pwd)` is our current directory on the host
  - `:/work` is where it appears in the container
  - The files are the same in both places!

## Persistent Data

Now let's see how volumes solve our earlier problem:

```bash
# Run container with mounted volume
docker run -it -v $(pwd):/work python:3.9 bash

# Inside container:
cd /work
mkdir data
echo "This will persist!" > data/note.txt
exit

# Back on host, check the files:
ls data
cat data/note.txt
```

The files we created in the container are right there on our computer! This is crucial for:
- Saving analysis results
- Working with data files
- Developing code
- Storing configuration

## Common Volume Use Cases

1. **Code Development**
```bash
docker run -it -v $(pwd):/code python:3.9 bash
```

2. **Data Analysis**
```bash
docker run -v $(pwd)/data:/data -v $(pwd)/notebooks:/notebooks jupyter/datascience-notebook
```

3. **Results Output**
```bash
docker run -v $(pwd)/results:/results myanalysis
```

## Important Volume Tips

1. **Use Absolute Paths**: While `$(pwd)` works for current directory, absolute paths are more reliable:
```bash
docker run -v /Users/me/project:/work python:3.9
```

2. **Read-Only Volumes**: Add `:ro` to prevent container from modifying host files:
```bash
docker run -v $(pwd):/work:ro python:3.9
```

3. **Multiple Volumes**: You can mount multiple volumes:
```bash
docker run \
  -v $(pwd)/data:/data \
  -v $(pwd)/config:/config \
  -v $(pwd)/results:/results \
  python:3.9
```

## Best Practices for Research

1. **Organize Your Mounts**:
```
project/
  ├── data/         # Mount as /data
  ├── notebooks/    # Mount as /notebooks
  ├── scripts/      # Mount as /scripts
  └── results/      # Mount as /results
```

2. **Document Your Volumes**:
```bash
# Run analysis with required volumes
docker run \
  -v $(pwd)/data:/data:ro      # Input data (read-only)
  -v $(pwd)/results:/results    # Analysis output
  -v $(pwd)/config:/config:ro   # Configuration files
  myanalysis
```

3. **Consider Data Size**:
- Large datasets might be better referenced externally
- Consider using data subsets for development
- Document data requirements clearly

Next, we'll look at creating our own images with Dockerfiles, so we can package up our entire research environment for others to use.