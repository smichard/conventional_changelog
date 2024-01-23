# Conventional Changelog
**Conventional Changelog** is a streamlined solution for generating a comprehensive and readable changelog from a project's commit history. This tool harnesses the power of conventional commit messages to create a well-structured and informative changelog, making it easier for users and contributors to track changes, updates, and new features. The tool offers versatile deployment options: it can be executed locally within the development IDE for immediate changelog updates, integrated as part of a continuous integration pipeline such as a GitHub Actions workflow, or employed as a task within a Tekton pipeline.

[![GitHub Tag](https://img.shields.io/github/v/tag/smichard/conventional_changelog "GitHub Tag")](https://github.com/smichard/conventional_changelog/tags)
[![GitHub pull requests](https://img.shields.io/github/issues-pr-raw/smichard/conventional_changelog "GitHub Pull Requests")](https://github.com/smichard/conventional_changelog/pulls)
[![Container Registry on Quay](https://img.shields.io/badge/Quay-Container_Registry-46b9e5 "Container Registry on Quay")](https://quay.io/repository/michard/conventional_changelog)
[![Start Dev Space](https://www.eclipse.org/che/contribute.svg)](https://devspaces.apps.ocp.michard.cc#https://github.com/smichard/conventional_changelog)

## Features
**Conventional Changelog** is a tool designed to parse the commit history of a Git repository and generate a detailed, human-readable changelog. The generated markdown formatted file is a well-structured document that categorizes changes based on the types of commits made. The script aligns with three best practices in software development: [Semantic Versioning](https://semver.org/), [Conventional Commits](https://www.conventionalcommits.org), and the principles of maintaining a changelog.

**Highlights:**
- Commit Parsing and Categorization:
	- The script is designed to parse all commits in the repository, offering the best results when these commits adhere to the Conventional Commits standard.
	- Types like feat (new features), fix (bug fixes), and others are recognized and categorized accordingly.
	- Commits that do not follow the conventional structure are still included but categorized under 'Other'.
	- Git emojis are supported, offering a visually engaging way to enhance commit messages and changelog entries.
- Extended Categories beyond Conventional Commits:  
Unique to this script, it extends the standard conventional commit types by recognizing additional categories such as gitops, deploy, and demo:
	- **Deployment Commits:** Specifically for changes to deployment-related files, like Kubernetes manifests.
	- **GitOps Commits:** For changes that trigger a new deployment of an application or modify an existing deployment in an automated manner. These commits could include updates to application configurations, changes in deployment manifests, or any alterations that are meant to be reflected immediately in the live deployment environment through automated processes.
	- **Demo Commits:** Commits made for demonstration purposes, which are not be part of the core application but are used for showcasing features or functionality.
- Changelog Structure and Formatting:
	- The script generates a changelog that is consistent with the guidelines from [Keep a Changelog](https://keepachangelog.com).
	- It ensures that the changelog is human-friendly, properly formatted, and categorizes changes in a manner that is easy to read and understand.
	- The script also acknowledges the adherence to Semantic Versioning, ensuring that the versioning of the project remains clear and meaningful.
- Automation and Ease of Use:
	- By automating the process of changelog generation, this script significantly reduces manual effort and minimizes the risk of missing out on important changes.
	- It's particularly useful in environments where consistent and detailed logging of changes is crucial, like in large-scale projects or when maintaining open-source libraries.

In summary, this script is a powerful tool for any development team that values detailed, accurate, and automated tracking of changes in their software projects. It not only simplifies the creation of a changelog but also ensures that it is comprehensive, well-organized, and adheres to widely accepted best practices in software development.

## CLI: Run the Script Locally
To ensure maximum flexibility and adaptability, the tool can be executed in various environments such as within the local development environment:

1. Directly run the script in the local development environment:
	```bash
	./generate_changelog_local.sh
	```

2. Using a Container Engine:  
For a more isolated and consistent environment, the tool can be executed with a container engine like Podman or Docker.
	1. First, build the container image using the provided Dockerfile. This step creates an image with the necessary environment for running the script:
		```bash
		podman build -t <image-name> -f Dockerfile
		```
	2. After building the image, run the container. This step mounts the current working directory into the container, allowing the script to access and update the changelog file within the project directory:
		```bash
		podman run -it --rm -v "$(pwd):/repo" <image-name> sh
		```
	3. Inside the container, navigate to the mounted repository directory and execute the script. This process generates the changelog within the containerized environment, reflecting the changes back to the local repository.
		```bash
		cd repo
		./generate_changelog_local.sh
		```

## GitHub Action: Automate within GitHub Workflows
Integrating Conventional Changelog into a CI/CD pipeline as a GitHub Action streamlines the process of keeping your changelog current and comprehensive. This integration ensures that the changelog is automatically updated with every significant push to the main branch, reflecting the latest changes in the project.

Embed the tool in your repository's workflow by adding a new file named `.github/workflows/generate_changelog.yml.` This configuration file will define the actions that GitHub should perform to generate and update the changelog.
```yaml
name: Generate Changelog

on:
  push:
    branches: [ main ]

jobs:
  changelog:
    runs-on: ubuntu-latest
    name: Generate and Commit Changelog

    steps:
    - name: Checkout Repository
      uses: actions/checkout@v4

    - name: Generate Changelog
      uses: smichard/conventional_changelog@1.0.2
      with:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

    - name: Set Git User Info
      run: |
        git config user.name 'GitHub Actions Bot'
        git config user.email 'actions@github.com'

    - name: Commit Changelog
      run: |
        git add CHANGELOG.md
        git commit -m "docs: :robot: changelog file generated" || echo "No changes to commit"
        git push
```
Whenever changes are pushed to the repository, the GitHub Action will automatically execute the script, ensuring that the **CHANGELOG.md** file is consistently up-to-date with the latest commits. When applying this GitHub Actions workflow, it's crucial to ensure that the workflow has the necessary read and write permissions within your GitHub repository settings (Settings -> Actions -> General -> Workflow permissions). 

## Tekton: Integrate as a Task in Tekton Pipelines

Conventional Changelog extends its versatility by offering seamless integration as a task within Tekton pipelines. This feature is particularly beneficial for users operating in Kubernetes and OpenShift environments, allowing for the automation of changelog generation within these robust container orchestration platforms.

1. Begin by applying the provided `tekton/task_generate_changelog.yml` configuration. This step enables using the provided Task as part of a Tekton Pipeline:
	```bash
	oc apply -f tekton/task_generate_changelog.yml
	```
2. Integrate the provided task into a CI/CD pipeline. Find below a minimal pipeline configuration. This pipeline illustrates a minimal configuration which retrieves a Git repository and generates the changelog. However, the provided pipeline can serve as a blueprint to be adopted in a larger context. If the generated changelog file needs to be committed back to the repository, additional steps are required to handle the commit process.
```
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
name: minimal-pipeline
spec:
workspaces:
- name: source
params:
- name: git-url
	type: string
	description: "URL of the git repository"
tasks:
- name: fetch-repository
	taskRef:
	name: git-clone
	kind: ClusterTask
	workspaces:
	- name: output
	workspace: source
	params:
	- name: url
	value: $(params.git-url)
	- name: revision
	value: "main"
- name: generate-changelog
	taskRef:
	name: generate-changelog
	workspaces:
	- name: source
	workspace: source
	runAfter:
	- fetch-repository
```
3. Apply the pipeline:
	```bash
	oc apply -f tekton/pipeline.yml
	```
4. Adopt the provided `PipelineRun` file according to your projects needs. Particularly adjust the repository url to match the specific project and the storage requirements before triggering the pipeline:
```
apiVersion: tekton.dev/v1beta1
kind: PipelineRun
metadata:
generateName: minimal-pipeline-run-
spec:
pipelineRef:
	name: minimal-pipeline
params:
- name: git-url
	value: "https://github.com/your-repo-url"   # adjust GitHub repository url
workspaces:
- name: source
	volumeClaimTemplate:
	spec:
		accessModes:
		- ReadWriteOnce
		resources:
		requests:
			storage: 50Mi                       # adjust to the storage requirements
		storageClassName: managed-nfs-storage
		volumeMode: Filesystem
```
5. Trigger the pipeline:
	```bash
	oc create -f tekton/pipeline_run.yml
	```

These configurations facilitate a streamlined setup for utilizing **Conventional Changelog** in Tekton pipelines, enhancing the change management process within Kubernetes and OpenShift environments.


## License

This project is licensed under the [MIT License](./LICENSE). See the LICENSE file for more details.