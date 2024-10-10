# Enterprise Mobility Management (EMM)

## Complete Control at the Tactical Edge

Developed by Sherpa 6, Watchtower is a powerful tactical Enterprise Mobility Management (EMM) solution used to provision and manage Android, Android Enterprise, and Integrated Visual Augmentation System (IVAS) devices. Watchtower was designed to support numerous mission Concepts of Operation (CONOPS) and end-user capability sets in unclassified, tactical collateral secret, and secret enclaves. Watchtower provides a complete and secure Life Cycle Management (LCM) capability in constrained environments at-the-edge. Watchtower provides a single ecosystem for device configuration management (CM), provisioning, governance, security, app management, and analytics. Unlike traditional commercial off-the-shelf MDM solutions, Watchtower provides mechanisms to automatically configure components at an enterprise level that typically require manual touchpoints in a tactical environment, including apps such as ATAK and ATAK plugins. A significant benefit to our customers is that it can be customized to fit specific military applications.

## Purpose

The purpose of this repository is to provide a deployment method for Watchtower. This repository contains the necessary files to bootstrap a new Watchtower environment with a single command. The deployment script will pull the necessary Docker images and deploy the Watchtower application. The deployment script can be run in online or offline environments.

## Features

- Bootstrap a new Watchtower environment with a single command
- Deploy Watchtower in online or offline environments

## Deployment Method

To deploy Watchtower, follow these steps:

1. Copy the repository to the target environment:
    ```sh
    git clone https://github.com/casey-mccarthy/watchtower-deploy.git
    cd watchtower-deploy
    ```
2. If deploying in offline mode, copy the necessary container .tar files to the `containers` directory.
3. Deploy the application using the deployment script:
    ```sh
    ./deploy.sh

    or 

    ./deploy.sh offline
    ```

## Assumptions about Hosting Environment

- The host is running a Linux-based operating system that leverages the yum package manager.
- The hosting environment has access to the internet for pulling Docker images (unless running in offline mode).
- Adequate resources are available to run the Docker containers (CPU, memory, and storage).
- Network configurations allow communication between the containers.


