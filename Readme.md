# Scripts


Lists of scripts I used.

- bash_template.sh: Template to create a bash script
- docker_clean.sh: Clean Docker fs
- logger.sh: logger functions
- nics.sh: List network info based iproute
- nics_sysfs_pci.sh: List network info based on pci info
- recovery.sh: Recover recently deleted files
- template_cmd.sh: script to launch function as cmd, ex ./template_cmd.sh <my_func>


To generate the list above:

```bash
 \ls *.sh | xargs -I {} bash -c "echo -n - {}: ;sed -ne '2p' {} | sed 's/^\\#//'"
```
