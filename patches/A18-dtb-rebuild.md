# A18 档案：小米 8（dipper）板级 DTB 重建

## 背景

内核以 `Image.gz-dtb` 交付（`BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb`，
`CONFIG_BUILD_ARM64_APPENDED_DTB_IMAGE=y`），dtb 拼接在内核镜像尾部
（`arch/arm64/boot/Makefile`：`find dts/ -name *.dtb` 全量收集）。
`dts/Makefile` 里 `subdir-y += xiaomi` 指向的板级 DTS 目录在上游
（`sdm845-419/android_kernel_xiaomi_sdm845_419`，含 perf / perf-dipper 分支）
从未入库——这批源码历来只存在于构建机上。

A18 的做法：以原包 `lineage-23.2-20260411-UNOFFICIAL-dipper.zip` 的 `boot.img`
（及同内容的 `recovery.img`）为准，反编译其中拼接的 **12 个板级 dtb**，重建 DTS 源码，
保证与原包设备树字节语义一致（bootloader 按 `qcom,board-id` 选板，12 块覆盖
P0/P1/P1.1/P2/MP 各硬件版 × v2/v2.1）。

## 方法

1. 解出 boot.img 尾部拼接的 12 个 dtb（魔数 0xd00dfeed 切分，均约 452 KB）。
2. 按 FDT 结构块/字符串块反编译为 DTS 文本（属性值逐字节无损；
   已用「文本→字节回读」校验 12 个文件、每个约 1.4 万处属性全部一致）。
3. 固化到本目录 `dts-xiaomi/`，由 `apply-a18-dts.sh` 落位到
   `arch/arm64/boot/dts/xiaomi/`（`dts/Makefile` 的 `subdir-y += xiaomi`
   递归构建；`Image.gz-dtb` 以 `find dts/ -name *.dtb` 拼接产出）。

反编译为全展开 DTS（无 /include/ 依赖），可直接被内核自带 dtc 编译；
phandle 保留原数值，回编译产物与原 dtb 语义等价（字节布局因 dtc
字符串池排布可能不同，不影响引导匹配）。

## 12 块 dtb 清单（顺序 = boot.img 拼接顺序）

| # | 文件 | model | qcom,board-id |
|---|------|-------|----------------|
| 1 | dipper-p1-v2-cn.dts | Dipper new P1 v2 cn | <0x33 0x0> |
| 2 | dipper-p2-v2p1.dts | Dipper new P2 v2.1 | <0x36 0x0> |
| 3 | dipper-p1-v2-gb.dts | Dipper new P1 v2 gb | <0x34 0x0> |
| 4 | dipper-p1-v2p1-gb.dts | Dipper new P1 v2.1 gb | <0x34 0x0> |
| 5 | dipper-p0-v2p1.dts | Dipper new P0 v2.1 | <0x32 0x0> |
| 6 | dipper-mp-v2.dts | Dipper new MP v2 | <0x37 0x0> |
| 7 | dipper-p0-v2.dts | Dipper new P0 v2 | <0x32 0x0> |
| 8 | dipper-p1p1-v2.dts | Dipper new P1.1 v2 | <0x35 0x0> |
| 9 | dipper-p2-v2.dts | Dipper new P2 v2 | <0x36 0x0> |
| 10 | dipper-p1-v2p1-cn.dts | Dipper new P1 v2.1 cn | <0x33 0x0> |
| 11 | dipper-mp-v2p1.dts | Dipper new MP v2.1 | <0x37 0x0> |
| 12 | dipper-p1p1-v2p1.dts | Dipper new P1.1 v2.1 | <0x35 0x0> |

原始 dtb 完整 SHA-256 见 `dts-xiaomi/MANIFEST.txt`。

## 落位

```bash
bash patches/apply-a18-dts.sh          # 在内核仓根执行
```

脚本把 DTS 与 Makefile 装入 `arch/arm64/boot/dts/xiaomi/`，并为
`dts/Makefile` 引用的 `qcom-sdm845/` 补空壳 Makefile（该目录上游即缺，
kbuild 的 subdir-y 递归需要兜底），最后校验 12 个文件落位一致。

## 出处与许可

- dtb 字节来源：LineageOS 23.2 dipper UNOFFICIAL 社区包（`lineage-23.2-20260411-UNOFFICIAL-dipper.zip`）内 boot.img；
  设备树内容为高通 sdm845 + 小米 dipper 板级描述，随内核 GPL-2.0 聚合分发。
- 反编译重建：铁盾 OS 施工（A18），本目录脚本与档案 GPL-2.0。
