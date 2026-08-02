# fedora-niri &nbsp; [![bluebuild build badge](https://github.com/khoocw97/fedora-niri/actions/workflows/build.yml/badge.svg)](https://github.com/khoocw97/fedora-niri/actions/workflows/build.yml)


这是我的个人定制镜像，基于 Niri 窗口管理器与 Noctalia Shell 构建。


> [!WARNING]  
> 该镜像仍处于高度实验阶段，且预装了我的个人自定义配置。


## 安装指南
将现有的 Fedora Atomic 系统升级（Rebase）到最新镜像：

- 首先切换到**未签名镜像**，以安装所需的签名密钥（Signing Keys）和安全策略（Policies）：
  ```bash
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/khoocw97/fedora-niri:latest

- 重启系统以完成此次 Rebase：
  ```
  systemctl reboot
  ```
  
- 随后切换到**已签名镜像**：
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/khoocw97/fedora-niri:latest
  ```
  
- 再次重启系统，完成安装。
  ```
  systemctl reboot
  ```
  
- **Bootc** 安装方式（完成后别忘了重启系统）：
  ```
  sudo bootc switch ghcr.io/khoocw97/fedora-niri:latest
  ```
## 鸣谢与参考

本项目依托开源社区的力量，在开发过程中借鉴了以下优秀项目的思路与代码，在此诚挚致谢：


* **[NyxNiri](https://github.com/ech678/NyxNiri)** 
  - 提供了 Niri 窗口管理器的配置参考。

* **[MizukiOS](https://github.com/koitorin/MizukiOS)** 
  - 提供了系统镜像构建与架构方案参考。

---

### 推荐项目

如果你正在寻找一套优秀的 Niri 桌面配置方案，强烈推荐关注 **[NyxNiri](https://github.com/ech678/NyxNiri)**！

## Verification

这些镜像使用了[Sigstore](https://www.sigstore.dev/)的[cosign](https://github.com/sigstore/cosign)进行签名。您可以通过从该仓库下载`cosign.pub` 文件并运行以下命令来验证签名：

```bash
cosign verify --key cosign.pub ghcr.io/khoocw97/fedora-niri
```
