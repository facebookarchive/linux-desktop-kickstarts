# luks-kickstarts
Kickstarts demonstrating automated provisioning with LUKS

## Requirements
- pykickstart (for ksflatten and ksvalidate)
- lorax (for mkksiso and dependent tools like xorriso)


## License note
While this repo is under the MIT license (see `LICENSE`), `mkksiso`
from Lorax is under the GPLv2 - see

  https://github.com/weldr/lorax/blob/master/COPYING

It is temporarily carried here until the fixed `mkksiso` that properly
generate UEFI-bootable ISOs is widely available.

## Usage
```
./gen.sh KICKSTARTFILE
./rebuild.sh SRCISO VOLID
```
