### Container for tailscale packaged with nftables version of iptables

https://github.com/tailscale/tailscale

Latest release

```bash
curl -s https://api.github.com/repos/tailscale/tailscale/releases/latest | grep tag_name | cut -d '"' -f 4 | tr -d 'v'
```