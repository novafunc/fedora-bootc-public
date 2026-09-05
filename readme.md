### Installing

To switch from upstream Fedora Atomic to this, simply run:

```bash
sudo ./update --now
```

This will copy the files needed to build the OCI image to your system and have systemd build to and switch the system to using the bootc image.

It will also show a log of the build process. To close out of the log, do Control+C. Note that closing the log does not stop the build.

### Updating

```./update``` waits until the next image build.

```./update --now``` builds a new image immediately
