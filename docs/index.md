# IP Whitelist on Hetzner Firewall

## Overview

This GitHub Action streamlines the process of whitelisting IP addresses in Hetzner Firewalls, automating access control prior to SSH deployments.
It allows for flexible customization of firewall settings, including firewall name, traffic direction (inbound/outbound), protocol type (e.g., TCP, UDP), and port range. This action enhances security by ensuring that only trusted IP addresses can access your Hetzner server.

You can find the GitHub Action on the [GitHub Marketplace](https://github.com/marketplace/actions/ip-whitelist-on-hetznerfw).

## Features

- **Automated IP Whitelisting**: Easily add IP addresses to a Hetzner firewall to control access for specific traffic.
- **Customizable Rules**: Specify the direction, protocol, and port range for precise firewall rule configuration.
- **Optional Cleanup**: Automatically removes added rules after deployment when `cleanup` is set to `true`.
- **Docker-Based Execution**: This action runs in a Docker container, ensuring consistent behavior across environments.


## License

This GitHub Action is licensed under the [MIT License](LICENSE).