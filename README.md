# ⚠️ 致歉声明

**对不起——我在开源许可证上做了不得已的取舍。**

**本内核树集成 KernelSU-Next（GPL-3.0，drivers/kernelsu/）以提供 Root 能力，它与 Linux 内核（GPL-2.0-only）的组合分发，在许可证兼容性上存在业界公认的争议。（另：此前 drivers/kernelsu/LICENSE 误放为 GPL-2 正文，现已更正为 GPL-3.0 原文。）**

**我这样做，是为了用户。** Root、模块扩展、完整掌控自己手中的设备——这是小米 8 用户呼声最高的需求，我把用户的自由放在了第一位。

**如果相关权利人认为不妥，请立刻联系我，我将在第一时间删除相关代码与构建产物，不拖延、不争辩。**

**联系邮箱：[lilining308@gmail.com](mailto:lilining308@gmail.com)**

---

# TieDun OS (System Kernel) — 铁盾 OS 系统内核

小米 8（dipper / 高通骁龙 845 / sdm845）系统内核，随「铁盾 OS 1.0.2.4」交付。
Linux **4.19.325**（4.19-CIP 系，perf 血统）+ **KernelSU-Next**（内置 Root，默认激活）。

> 📦 **源码仓库**：主仓（定制/文档/构建说明）<https://github.com/lilining308-prog/tiedun-os> ｜
> 内核仓（本仓）<https://github.com/lilining308-prog/tiedun-os-system-kernel>

- 适用机型：小米 8（dipper）
- 上游血统：[sdm845-419/android_kernel_xiaomi_sdm845_419](https://github.com/sdm845-419/android_kernel_xiaomi_sdm845_419)（perf）× KernelSU-Next 12759 + SUSFS
- 内核构建后合入 boot.img，dtbo 随内核；平台侧构建说明见主仓 `docs/BUILDING.md`

## 本仓内容
| 路径 | 内容 |
|---|---|
| （仓根） | 完整内核源码树（交付物 `tiedun-kernel-4.19.325-ksu.tar.gz` 原样展开，无编译产物） |
| `patches/dts-xiaomi/` | 小米 8 板级 DTS 源（A18：由原包 boot.img 反编译 12 个板级 dtb 重建） |
| `patches/*.md` | 内核侧编译适配档案：A12 techpack 存根 / A13 UAPI 去重 / A14 ion-v4l2 别名 / A18 dtb 重建 |
| `patches/apply-*.sh` | 对应幂等施工脚本 |

## 许可
- 内核本体：**GPL-2.0**（见 `COPYING` 与仓根 `LICENSE`）
- KernelSU-Next（`drivers/kernelsu/`）：**GPL-3.0**（见 `drivers/kernelsu/LICENSE`）；
  内核 GPL-2.0 与 KernelSU GPL-3.0 的聚合分发争议见主仓 `NOTICE` 公示
- 本仓集成脚手架（patches/）：随所属部件，GPL-2.0 / GPL-3.0

## 署名
铁盾 OS 由 lilining308 制作 · GitHub: [lilining308-prog](https://github.com/lilining308-prog) · lilining308@gmail.com
