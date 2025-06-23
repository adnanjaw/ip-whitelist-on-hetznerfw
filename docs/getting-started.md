# Getting Started

This guide will walk you through the steps to set up and use the **IP Whitelist on Hetzner Firewall GitHub Action**.
This action helps automate IP whitelisting on Hetzner Firewalls, ensuring controlled access to your server.

## Prerequisites

1. **Hetzner API Key**: Generate an API key in your Hetzner Cloud Console. This key will be used to authenticate and configure firewall rules.

2. **GitHub Secrets**: Store your Hetzner API key securely in GitHub Secrets. This ensures that sensitive information is not exposed in workflow files.

3. **Hetzner Firewall**: Set up a firewall in your Hetzner Cloud account. For safer use with this action, it's recommended to create a dedicated firewall to avoid conflicts with existing rules.


## Step 1: Add the Hetzner API Key to GitHub Secrets

1. In your GitHub repository, go to **Settings > Secrets and variables > Actions > New repository secret**.
2. Add a new secret with the following details:
    - **Name**: `HETZNER_API_KEY`
    - **Value**: Paste your Hetzner API key here.
3. Save the secret. You can now reference `HETZNER_API_KEY` in your workflows without exposing the API key.

## Step 2: Create the GitHub Action Workflow File

To use this action, create a workflow file in your repository’s `.github/workflows` directory. This file defines when
and how the IP Whitelist action will run.

### Example Workflow Configuration

Here's an example `whitelist_ip.yml` file you can use to set up the action:


!!! note

      Customize `ip_address`, `firewall_name`, and other inputs based on your needs.

```yaml
name: Whitelist IP on Hetzner Firewall

on:
  push:
    branches:
      - main

jobs:
  whitelist_ip:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Whitelist IP on Hetzner Firewall
        uses: adnanjaw/ip-whitelist-on-hetznerfw@latest
        with:
          hetzner_api_key: ${{ secrets.HETZNER_API_KEY }}
          ip_address: 192.168.1.1  # Replace with the IP address you want to whitelist
          firewall_name: my-firewall  # Replace with your firewall's name
          direction: in
          protocol: tcp
          port: 22
          cleanup: true  # Optional: Set to false if you want to keep the rule after the job finishes
```
