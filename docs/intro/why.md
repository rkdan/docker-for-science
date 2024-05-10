# Why Docker?

So far, you are likely using one of three methods to manage you Python projects:

1. conda
2. venv or pyenv
3. absolutely nothing and just using `pip install` in your base Python environment

If you're using 3, then you've likely already run into the following problems:

- Dependency hell
- Reproducibility issues
- Incompatibility with other operating systems

!!! abstract "Scenario"

    You start a new project, `my-project-1`, and install package X. When you try to import package X, you realize that X actually needs another package to run successfully, called Y. You install that too. You go about your work, and all is well!

    A few months later, you start a new project, `my-project-2`, and install package Z. You import package Z, and go about your work, and all is well!

    A few months later, you start working on `my-project-1` again. You open your Jupyter notebook and try to run the first cell but it fails! Panic! When you try and import package X, you are getting the same error as before and you need to install package Y again! But why!? You already did this! So you install package Y again, and go about your work. All is well again!

    After spending a few hours on `my-project-1` you switch back over to `my-project-2`. You open your notebook and run the first cell, but it fails when trying to import package Z! Panic! Package Z claims that it cannot import package Y! But why!? You already installed package Y! Twice! So you install package Y again, and try to run the first cell, but it fails! Panic! What is going on!? You uninstall package Z, and reinstall it again, and now your first cell works! Excellent! You open up your other notebook where you are working on `my-project-1`, and rerun the imports.
    
    They fail.
    
    You sell your worldly possessions and move to Tibet.

In the scenario above, what you didn't realize is that when you installed package Y after installing X, using `pip install Y`, you were installing the lastest version, perhaps v1.2.23. But then, when you installed package Z, it also needed package Y, but it needed v1.1.13. So, when you installed Z, it downgraded Y to v1.1.13. The difference between these two versions was enough to completely break package X. You have taken your first steps down into dependency hell.

## The above problem is easy to fix
Conda and venv provide an easy way to create standalone Python versions that are isolated from your base Python installation. This means that you can install different versions of packages in different environments, and they won't interfere with each other. This is a great way to avoid the above problem.

However, there are still some issues with this approach. When working collaboratively, it is usually impractical to share your entire environment with your collaborators. This is because your environment is likely to be quite large, and may contain sensitive information. This means that your collaborators will need to recreate your environment on their own machine, and install all the necessary packages. This can be a time-consuming process, and can lead to errors if not done correctly. This can be made easier by using a combination of `requirements.txt` and `environment.yml` files, but this is still not foolproof.

What if you want to share some code with someone who doesn't even have python installed? Or perhaps onboard new students without having to spend hours setting up their environments?

This is where Docker comes in.

Docker allows you to create lightweight, portable, self-sufficient containers that can run on any machine that has Docker installed. This means that you can package up your entire environment, including your code, and share it with anyone. They can then run your code in the exact same environment that you developed it in, without having to worry about installing packages, or setting up their environment.



## Further reading
<div class="grid cards" markdown>

-   :fontawesome-solid-book-open:{ .lg .middle } [__CI/CD - Pre-commit resources__](../resources/references.md#pre-commit)

    ---
    Information on GitHub Actions, Black, Flake8, Mypy, Isort, and Git Hooks

</div>