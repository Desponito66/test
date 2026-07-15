#!/bin/bash

echo "=== Updating zapret binaries ==="

wget -O /tmp/zapret.tar.gz https://github.com/bol-van/zapret/releases/download/v72.12/zapret-v72.12-openwrt-embedded.tar.gz
tar -xzf /tmp/zapret.tar.gz -C /tmp/

ZAPRET_DIR=$(find /tmp -maxdepth 1 -type d -name "zapret*" | head -1)
if [[ -z "$ZAPRET_DIR" ]]; then
    echo "ERROR: Could not find extracted zapret directory"
    exit 1
fi

echo "Found extracted zapret directory: $ZAPRET_DIR"

NFQWS="$ZAPRET_DIR/binaries/linux-mipsel/nfqws"
TPWS="$ZAPRET_DIR/binaries/linux-mipsel/tpws"

if [[ ! -f "$NFQWS" || ! -f "$TPWS" ]]; then
    echo "ERROR: nfqws or tpws not found in $ZAPRET_DIR/binaries/linux-mipsel/"
    ls -la "$ZAPRET_DIR/binaries/"
    exit 1
fi

echo "Found nfqws: $NFQWS"
echo "Found tpws: $TPWS"

# ---- ДОБАВЛЯЕМ ОТЛАДКУ ----
echo "=== Content of padavan-ng/trunk/user/nfqws/ ==="
ls -la padavan-ng/trunk/user/nfqws/ || echo "Directory not found"

echo "=== Searching for any nfqws file in padavan-ng ==="
find padavan-ng -name "nfqws" -type f 2>/dev/null

echo "=== Searching for any tpws file in padavan-ng ==="
find padavan-ng -name "tpws" -type f 2>/dev/null

# Теперь заменяем все найденные файлы, но с исключением папок с исходниками (например, если есть папка src)
find padavan-ng -name "nfqws" -type f -not -path "*/src/*" -exec cp -v "$NFQWS" {} \;
find padavan-ng -name "tpws" -type f -not -path "*/src/*" -exec cp -v "$TPWS" {} \;

echo "=== Update complete ==="
