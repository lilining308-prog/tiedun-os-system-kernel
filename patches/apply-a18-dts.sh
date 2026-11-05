#!/bin/bash
# 铁盾OS A18 施工脚本: 小米 8 (dipper) 12 个板级 DTS 落位
# 幂等: 重复执行安全(内容不变则覆盖为相同字节)。
#
# 做三件事:
#   1) patches/dts-xiaomi/*.dts + Makefile → arch/arm64/boot/dts/xiaomi/
#      (dts/Makefile 的 subdir-y += xiaomi 递归构建; Image.gz-dtb 用
#       find dts/ -name *.dtb 把产出的 dtb 拼进内核镜像尾部)
#   2) 为 dts/Makefile 引用但不存在的 qcom-sdm845/ 补空壳 Makefile,
#      保证 kbuild 的 subdir-y 递归不因缺目录中断(xiaomi/ 由第 1 步创建)。
#   3) 校验落位一致。
#
# 用法: bash apply-a18-dts.sh [<内核树根>]
#   默认内核树根 = 本脚本所在仓库根(patches/ 的上一级)。
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
K="${1:-$(cd "$HERE/.." && pwd)}"
SRC_DTS="$HERE/dts-xiaomi"
DEST="$K/arch/arm64/boot/dts/xiaomi"

[ -d "$K/arch/arm64/boot/dts" ] || { echo "不是内核树根: $K"; exit 1; }
[ -d "$SRC_DTS" ] || { echo "缺 dts-xiaomi/: $SRC_DTS"; exit 1; }

echo "== A18 1/3 板级 DTS → arch/arm64/boot/dts/xiaomi/ =="
mkdir -p "$DEST"
cp "$SRC_DTS"/*.dts "$DEST/"
cp "$SRC_DTS/Makefile" "$DEST/Makefile"
echo "  已落位 $(ls "$DEST"/*.dts | wc -l) 个 dts"

echo "== A18 2/3 补 qcom-sdm845/ 空壳 Makefile(subdir-y 递归保险) =="
mk="$K/arch/arm64/boot/dts/qcom-sdm845/Makefile"
if [ -f "$mk" ]; then
    echo "  qcom-sdm845/Makefile 已在, 跳过"
else
    mkdir -p "$K/arch/arm64/boot/dts/qcom-sdm845"
    cat > "$mk" <<'EOF'
# SPDX-License-Identifier: GPL-2.0
# TieDun A18: 空壳 — dts/Makefile 的 subdir-y 引用本目录;
# sdm845 平台 dtsi 在 qcom/(未启用), 小米 8 板级 DTS 在 xiaomi/。
dtb-y +=
always		:= $(dtb-y)
clean-files	:= *.dtb
EOF
    echo "  qcom-sdm845/Makefile 已创建"
fi

echo "== A18 3/3 校验 =="
for f in "$SRC_DTS"/dipper-*.dts; do
    b="$DEST/$(basename "$f")"
    cmp -s "$f" "$b" || { echo "!! 校验失败: $b"; exit 1; }
done
echo "  12 个 dts 与源一致"
echo "A18 施工完成: $DEST"
