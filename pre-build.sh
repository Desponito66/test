#!/bin/bash

echo "=== Updating zapret binaries ==="

# Скачиваем последнюю стабильную версию (v72.12)
wget -O /tmp/zapret.tar.gz https://github.com/bol-van/zapret/releases/download/v72.12/zapret-v72.12-openwrt-embedded.tar.gz

# Распаковываем
tar -xzf /tmp/zapret.tar.gz -C /tmp/

# Находим папку с распакованным содержимым
ZAPRET_DIR=$(find /tmp -maxdepth 1 -type d -name "zapret*" | head -1)

if [[ -z "$ZAPRET_DIR" ]]; then
    echo "ERROR: Could not find extracted zapret directory"
    exit 1
fi

echo "Found extracted zapret directory: $ZAPRET_DIR"

# Теперь явно указываем путь к бинарникам для архитектуры mipsel
NFQWS="$ZAPRET_DIR/binaries/linux-mipsel/nfqws"
TPWS="$ZAPRET_DIR/binaries/linux-mipsel/tpws"

if [[ ! -f "$NFQWS" || ! -f "$TPWS" ]]; then
    echo "ERROR: nfqws or tpws not found in $ZAPRET_DIR/binaries/linux-mipsel/"
    # Выводим содержимое папки для диагностики
    ls -la "$ZAPRET_DIR/binaries/"
    exit 1
fi

echo "Found nfqws: $NFQWS"
echo "Found tpws: $TPWS"

# Ищем все файлы nfqws и tpws в исходниках Padavan и заменяем их
find padavan-ng -name "nfqws" -type f -exec cp -v "$NFQWS" {} \;
find padavan-ng -name "tpws" -type f -exec cp -v "$TPWS" {} \;

echo "=== Update complete ==="
