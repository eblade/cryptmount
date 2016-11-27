# cryptmount
cryptmount

This is basically clean-up and packaging of @bjodah's encrypted mount/umount
scripts.

# Usage

Mount

```bash
cmount [profile]
```

Unmount
```bash
cumount [profile]
```

Both will require you to give your password for sudoing.

# Installation

- Create an encrypted disk with cryptsetup. Run your password through
  ``supergenpass.sh`` (since that will be used by the mount script).
- Create a folder where you keep your disk profiles.
- Add something like this to `.bashrc`

```bash
#!/bin/bash

export PATH="$HOME/git/cryptmount/bin:$PATH"
export CRYPTMOUNT_PROFILES="/path/to/your/disk/profile/folder"

function _cryptmountComplete {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(ls $CRYPTMOUNT_PROFILES)" -- $cur) )
}

complete -F _cryptmountComplete cmount
complete -F _cryptmountComplete cumount
```

- For each disk, add a shell script file with the disk parameters:

```bash
#!/bin/bash

RESOURCE_NAME='seagate'
RESOURCE_PATH=/dev/disk/by-id/ata-ST2000LM007-1R8174_WCC1BA11-part1
MOUNT_POINT=/run/media/$LOGNAME/seagate
```

Note that different Linux distros have different media folders. This is for
Fedora, while Ubuntu would have ``/media/$LOGNAME/seagate``.
