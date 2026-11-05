# SPDX-License-Identifier: GPL-2.0
# TieDun A18: 小米 8 (dipper) 12 个板级 dtb — 由原包 boot.img 反编译重建
#（保持原 boot.img 拼接顺序）。落位 arch/arm64/boot/dts/xiaomi/ 后由
#  Image.gz-dtb 的 find dts/ -name *.dtb 自动拼进内核镜像。

dtb-y += dipper-p1-v2-cn.dtb
dtb-y += dipper-p2-v2p1.dtb
dtb-y += dipper-p1-v2-gb.dtb
dtb-y += dipper-p1-v2p1-gb.dtb
dtb-y += dipper-p0-v2p1.dtb
dtb-y += dipper-mp-v2.dtb
dtb-y += dipper-p0-v2.dtb
dtb-y += dipper-p1p1-v2.dtb
dtb-y += dipper-p2-v2.dtb
dtb-y += dipper-p1-v2p1-cn.dtb
dtb-y += dipper-mp-v2p1.dtb
dtb-y += dipper-p1p1-v2p1.dtb

always		:= $(dtb-y)
clean-files	:= *.dtb
