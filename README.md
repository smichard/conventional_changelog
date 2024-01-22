# Conventional Changelog
description wip

## Badges
[![GitHub Tag](https://img.shields.io/github/v/tag/smichard/conventional_changelog "GitHub Tag")](https://github.com/smichard/conventional_changelog/tags)
[![GitHub pull requests](https://img.shields.io/github/issues-pr-raw/smichard/conventional_changelog "GitHub Pull Requests")](https://github.com/smichard/conventional_changelog/pulls)
[![Container Registry on Quay](https://img.shields.io/badge/Quay-Container_Registry-46b9e5 "Container Registry on Quay")](https://quay.io/repository/michard/conventional_changelog)
[![Start Dev Space](https://www.eclipse.org/che/contribute.svg)](https://devspaces.apps.ocp.michard.cc#https://github.com/smichard/conventional_changelog)

## run locally
```bash
podman build -t <image-name> -f Containerfile
podman run -it --rm -v "$(pwd):/repo" <image-name> sh
cd repo
./generate_changelog_local.sh
```

## run with GitHub Action

## run within a tekton pipeline

## Best Practise Guides
[GitHub Flow](https://githubflow.github.io/)  
[Semantic Versioning](https://semver.org/)  
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)  
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/)  
[Open GitOps](https://opengitops.dev/)
