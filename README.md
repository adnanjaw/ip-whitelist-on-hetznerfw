# IP Whitelist on Hetzner Firewall GitHub Action

Author: [Adnan Al Jawabra](https://github.com/adnanjaw)

## Description

This GitHub Action automates the process of whitelisting an IP address on Hetzner Firewall before SSH deployment. It allows you to specify the firewall name, direction of traffic (inbound or outbound), protocol (e.g., TCP, UDP), and port range for traffic. This action helps streamline the deployment process by ensuring that only trusted IP addresses have access to your Hetzner server.

## Inputs

### `hetzner_api_key`

- **Description:** API key of Hetzner.
- **Required:** Yes.

### `ip_address`

- **Description:** IP address to whitelist.
- **Required:** Yes.

### `firewall_name`

- **Description:** The name of the targeted firewall.
- **Required:** Yes.

### `description`

- **Description:** Description of the Rule.
- **Required:** No.
- **Default:** A new rule using GitHub Action.

### `direction`

- **Description:** Direction could be inbound (in) or outbound (out).
- **Required:** Yes.
- **Default:** in.

### `protocol`

- **Description:** Type of traffic to allow (Allowed: tcp, udp, icmp, esp, gre).
- **Required:** Yes.
- **Default:** tcp.

### `port`

- **Description:** Port or port range to which traffic will be allowed. Only applicable for protocols TCP and UDP. A port range can be specified by separating two ports with a dash, e.g., 1024-5000.
- **Required:** No.
- **Default:** 80.

### `cleanup`
- **Description:** remove all added rules
- **Required:**  false
- **Default:** 'true

## Usage

```yaml
name: Whitelist IP on Hetzner firewall

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

      - name: Whitelist IP on Hetzner firewall
        uses: adnanjaw/ip-whitelist-on-hetznerfw@v1
        with:
          hetzner_api_key: ${{ secrets.HETZNER_API_KEY }}
          ip_address: 192.168.1.1 # Runner ip address
          firewall_name: my-firewall
          direction: in
          protocol: tcp
          cleanup: false
```

## Docker Image

This action runs using Docker.

## License

This GitHub Action is licensed under the [MIT License](LICENSE).
