# patches/ — 内核侧施工档案与脚本

本目录归档内核侧编译适配（A 系列）。树内现状与各档案的对应关系：

| 适配 | 状态 | 位置 |
|------|------|------|
| A12 techpack 存根 | 已在树内 | `techpack/stub/`（空实现，占位避免 techpack 缺失断编） |
| A13 UAPI 去重 / A14 ion-v4l2 别名 | 已在树内 | `include/uapi/linux/{ion,msm_ion}.h` 为指向 `drivers/staging/android/uapi/` 同名头的软链，单一来源 |
| A18 dtb 重建 | **本目录交付** | `dts-xiaomi/` + `apply-a18-dts.sh` + [A18-dtb-rebuild.md](A18-dtb-rebuild.md) |

## 使用

```bash
# 在内核仓根执行（把 12 个板级 DTS 落进 arch/arm64/boot/dts/xiaomi/）
bash patches/apply-a18-dts.sh
```

A12–A14 无需施工动作（已在交付树内生效）。A18 未落位时 `Image.gz-dtb`
拼不出设备树，**编内核前必跑**。

## 说明

- 上游 `sdm845-419/android_kernel_xiaomi_sdm845_419` 各分支均不含小米板级
  DTS 源；12 块板级 dtb 以原包 `lineage-23.2-20260411-UNOFFICIAL-dipper`
  的 boot.img 为准反编译重建，清单与哈希见 `dts-xiaomi/MANIFEST.txt`。
- 本目录脚本均为幂等（重复执行安全）。
