#!/usr/bin/python
import yaml
with open('/etc/netplan/00-installer-config.yaml','r') as yamlfile:
  y=yaml.safe_load(yamlfile)
  y['network'].update({"renderer": "NetworkManager"})
  print(yaml.dump(y, default_flow_style=False,sort_keys=False))

if y:
  with open('/etc/netplan/00-installer-config.yaml','w') as yamlfile:
    yaml.safe_dump(y,yamlfile)

# Now that we have a GUI, we'll want our wired network to be available to edit, add NetworkManager as the renderer in netplan