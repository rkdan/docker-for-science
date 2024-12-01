# Devcontainers
In the reproducibility section, we talked about the different levels of reproducibilty. You are probably familiar with things like Python venvs, conda environments, and even virtual machines. These are all ways to isolate your code and dependencies from the rest of your system. But what if you could isolate your code and dependencies in a way that is even more portable and reproducible? That's where devcontainers come in.

The Visual Studio Code Dev Containers extension lets you use a container as a dev environment. You can open any folder inside (or mounted into) a container inside VSCode. A `devcontainer.json` file in your project tells VS Code how to access (or create) a development container with a well-defined tool and runtime stack. This container can be used to run an application or to separate tools, libraries, or runtimes needed for working with a codebase.

Workspace files are mounted from the local file system or copied or cloned into the container. Extensions are installed and run inside the container, where they have full access to the tools, platform, and file system. This means that you can seamlessly switch your entire development environment just by connecting to a different container.

<a>
    <img src="../imgs/architecture-containers.png" alt="docker-cont">
</a>

Let's create a bare-bones devcontainer for our python project. Create a new folder:

```bash
mkdir .devcontainer
```
and then create a new file:
```bash
touch .devcontainer/devcontainer.json
```
Now populate it with the following:
```json
{
    "name": "Research Environment",
    "build": {
        "dockerfile": "../Dockerfile",
        "context": "."
    },
    "forwardPorts": [8888]
}
```
This will create a new devcontainer called "Research Environment" that will use the Dockerfile in the parent directory. It will also forward port 8888 to the host machine.

This is very basic. We don't have much functionality here at all. And how do we even access the actual jupyter lab server? We don't even have the python extension installed in the container! We would also find that any changes to the the stuff inside the container would not be reflected in the host machine. So let's make our experience more enjoyable.

```json
{
    "name": "Research Environment",
    "build": {
        "dockerfile": "../Dockerfile",
        "context": ".."
    },
    
    // Features to add to the dev container
    "features": {
        "ghcr.io/devcontainers/features/git:1": {}
    },

    // Configure tool-specific properties
    "customizations": {
        "vscode": {
            "extensions": [
                "ms-python.python",
                "ms-python.vscode-pylance",
                "ms-python.black-formatter",
                "ms-toolsai.jupyter",
                "github.copilot"
            ],
            "settings": {
                "python.defaultInterpreterPath": "/usr/local/bin/python",
                "python.linting.enabled": true,
                "python.formatting.provider": "black",
                "editor.formatOnSave": true,
                "editor.rulers": [88]
            }
        }
    },

    // Use 'forwardPorts' to make a list of ports inside the container available locally
    "forwardPorts": [8888],

    // Run commands after container is created
    "postCreateCommand": "pip install -r requirements.txt",

    // Set environment variables
    "remoteEnv": {
        "PYTHONPATH": "${containerWorkspaceFolder}"
    },
}
```

Now we have **a lot** more functionality!

Let's look at exactly what is going on here:

1. Top-level configuration:
```json
"name": "Research Environment",
```
This simply names your development container for easy identification.

2. Build configuration:
```json
"build": {
    "dockerfile": "../Dockerfile",
    "context": ".."
}
```
This tells VS Code how to build the container:
- `dockerfile`: Points to a Dockerfile one directory up from the devcontainer.json
- `context`: Sets the build context to the parent directory - what stuff to include in the build

3. Features section:
```json
"features": {
    "ghcr.io/devcontainers/features/git:1": {}
}
```
This adds additional tools to your container. Here, it's installing Git from the GitHub Container Registry.

4. VS Code Customizations:
```json
"customizations": {
    "vscode": {
        "extensions": [...],
        "settings": {...}
    }
}
```
This configures VS Code-specific settings:
- Extensions installed automatically:
  - Python extension
  - Pylance (Python language server)
  - Black formatter
  - Jupyter notebook support
  - GitHub Copilot
- VS Code settings configured:
  - Sets Python interpreter path
  - Enables linting
  - Uses Black for formatting
  - Enables format-on-save
  - Sets a line length ruler at 88 characters (Black's default)

We can add other dev tools here like mypy or itools or flake8.

1. Port Forwarding:
```json
"forwardPorts": [8888]
```
Makes port 8888 (commonly used for Jupyter notebooks) available on your local machine.

1. Post-Creation Commands:
```json
"postCreateCommand": "pip install -r requirements.txt"
```
Runs after the container is created - in this case, installing Python dependencies from requirements.txt.

1. Environment Variables:
```json
"remoteEnv": {
    "PYTHONPATH": "${containerWorkspaceFolder}"
}
```
Sets environment variables in the container:
- Adds the workspace folder to Python's module search path, letting you import from any subdirectory

This configuration creates a fully-featured Python development environment with:
- Code formatting and linting
- Jupyter notebook support
- Git integration
- Automatic dependency installation
- Proper Python path configuration
- AI assistance through Copilot

We are also free to add other features such as poetry.