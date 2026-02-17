# Scripts

Lists of scripts I used.

<!-- list file 0 -->
- bash_template.sh: Template to create a bash script
- docker_clean.sh: Clean Docker fs
- logger.sh: logger functions
- nics.sh: List network info based iproute
- nics_sysfs_pci.sh: List network info based on pci info
- perm_backup.sh: Backup linux file permission before changing it for a specific action, then restore old ones
- recovery.sh: Recover recently deleted files
- template_cmd.sh: script to launch function as cmd, ex ./template_cmd.sh <my_func>
- update_md.sh: update code between tag inside markdown
<!-- list file 1 -->

To generate the list above:

```bash
 \ls *.sh | xargs -I {} bash -c "echo -n - {}: ;sed -ne '2p' {} | sed 's/^\\#//'"
```

## Sysfs

### unbind a pci driver

```bash
echo -n 0000:03:00.1 | sudo tee /sys/bus/pci/drivers/<driver_name>/unbind
```

