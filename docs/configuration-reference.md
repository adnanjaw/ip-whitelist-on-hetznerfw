# Configuration Reference

Below are the required and optional inputs for configuring the IP Whitelist GitHub Action.
!!! danger "Default Cleanup Enabled"
    
    By default, `cleanup` is set to `true`, which **removes all rules in the specified firewall** after the action completes.
    If you are using an existing firewall, be cautious as this will delete all rules, including any pre-existing ones. To retain existing rules, set `cleanup` to `false` or use a **dedicated firewall** for this action.

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
    - *Default*: "A new rule using GitHub Action"

- **`port`**
    - *Description*: Port or range of ports to allow traffic on. Only applies to `tcp` and `udp` protocols. Specify a range using a dash, e.g., `1024-5000`.
    - *Default*: `80`

- **`cleanup`**
    - *Description*: Option to remove all added rules after execution.
    - *Default*: `true`