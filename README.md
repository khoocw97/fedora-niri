# fedora-niri &nbsp; [![bluebuild build badge](https://github.com/khoocw97/fedora-niri/actions/workflows/build.yml/badge.svg)](https://github.com/khoocw97/fedora-niri/actions/workflows/build.yml)


This is my personal system image, built with Niri WM and Noctalia Shell. 


> [!WARNING]  
> This image is still in a highly experimental stage and comes pre-configured with my personal settings.  


## Installation
To rebase an existing Fedora Atomic installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```bash
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/khoocw97/fedora-niri:latest
  
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
  
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/khoocw97/fedora-niri:latest
  ```
  
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```
  
- Bootc method (Don’t forget to reboot.):
  ```
  sudo bootc switch ghcr.io/khoocw97/fedora-niri:latest
  ```
## Credits & Acknowledgements

This project builds upon ideas, configurations, and build recipes from the open-source community. Special thanks to:


* **[DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell)** & **[NyxNiri](https://github.com/ech678/NyxNiri)**
  - Referenced for Niri window manager configurations.

* **[MizukiOS](https://github.com/koitorin/MizukiOS)** 
  - Referenced for system image building and setup.

* **[Bazzite](https://github.com/ublue-os/bazzite)**
  - Inspired by Bazzite's setup scripts and automation approach.

* **[96yottea](https://x.com/96yottea)**
  - Thanks for the wallpapers used in this project.
  
---

### Recommended Project

If you are looking for a great Niri desktop configuration, be sure to check out **[NyxNiri](https://github.com/ech678/NyxNiri)**!

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/khoocw97/fedora-niri
```
