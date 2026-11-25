### Installing

To switch from upstream Fedora Atomic to this, run:

```bash
sudo ./update --now
```
This will copy the Containerfile and related files to ```/var/lib/custom-os```. If it's the first run, it will perform a one-term boostrapping step of copying some systemd files to ```/etc``` in order to complete the first image build. The ```/etc``` files will automatically be cleaned up later by systemd, as the image will contain the same files stored in ```/usr```.

If you decide to switch away from this image, you should only need to remove ```/var/lib/custom-os``` and perhaps ```/var/tmp/buildah-cache-0```. The latter contains cached versions of rpms in order to avoid to prevent excessive redownloads when rebuilding images.

It will also show a log of the build process. To close out of the log, do Control+C. Note that closing the log does not stop the build.

### Updating

```./update``` copies the changes made in ```./fedora-bootc-public``` to the system, but does not trigger an image build.

```./update --now``` copies the changes and builds a new image immediately.
