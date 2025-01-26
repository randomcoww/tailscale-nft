### Container for tailscale packaged with nf_tables version of iptables

https://github.com/tailscale/tailscale

Tag latest by date

```bash
TAG=v$(date -u +'%Y%m%d').1
git tag -a $TAG
git push origin $TAG
```
