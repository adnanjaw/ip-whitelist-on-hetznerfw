# Configuration Reference

Below are the required and optional inputs for configuring the IP Whitelist GitHub Action.
!!! danger "Default Cleanup Enabled"
    
    By default, cleanup is set to true, which removes existing firewall rules that match the given description before adding a new rule.

### Required Inputs

- **`hetzner_api_key`**
    - *Description*: API key for Hetzner authentication.
- **`ip_address`**
    - *Description*: IP address to be whitelisted.
- **`firewall_name`**
    - *Description*: Name of the target firewall.
- **`direction`**
    - *Description*: Direction of traffic, either inbound (`in`) or outbound (`out`).
    - *Default*: `in`

- **`protocol`**
    - *Description*: Type of traffic to allow. Options: `tcp`, `udp`, `icmp`, `esp`, `gre`.
    - *Default*: `tcp`


!!! info

    Ensure you provide values for all **Required Inputs** above. Optional inputs have default values but can be customized as needed.

### Optional Inputs

- **`description`**
    - *Description*: Description for the rule.
    - *Default*: "github-actions-rule"

- **`port`**
    - *Description*: Port or range of ports to allow traffic on. Only applies to `tcp` and `udp` protocols. Specify a range using a dash, e.g., `1024-5000`.
    - *Default*: `80`

- **`cleanup`**
    - *Description*: Option to remove all added rules after execution.
    - *Default*: `true`

## Parallel Execution Support

When running multiple workflows simultaneously that use this action, each workflow should use a unique `description` to avoid conflicts:

!!! tip "Unique Descriptions for Parallel Runs"
Using `${{ github.run_id }}` in the description ensures each workflow run creates and cleans up only its own firewall rules, preventing interference between concurrent deployments.

```yaml
- name: Whitelist IP for deployment
  uses: adnanjaw/ip-whitelist-on-hetznerfw@v2.2
  with:
    hetzner_api_key: ${{ secrets.HETZNER_API_KEY }}
    ip_address: ${{ steps.get-ip.outputs.ip }}
    firewall_name: "my-firewall"
    description: 'github-actions-rule-${{ github.run_id }}'
    port: "22"
    protocol: "tcp"
    cleanup: "true"
```