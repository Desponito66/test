#!/bin/bash

echo "=== Updating zapret sources to v72.12 ==="

# Скачиваем исходники (не бинарники!) v72.12
wget -O /tmp/zapret-src.tar.gz https://github.com/bol-van/zapret/archive/refs/tags/v72.12.tar.gz

# Распаковываем в /tmp
tar -xzf /tmp/zapret-src.tar.gz -C /tmp/

# Проверяем, что распаковалось
if [[ ! -d /tmp/zapret-72.12 ]]; then
    echo "ERROR: Could not find /tmp/zapret-72.12"
    exit 1
fi

echo "Extracted sources to /tmp/zapret-72.12"

# Удаляем старую папку с исходниками (zapret-71.4)
rm -rf padavan-ng/trunk/user/nfqws/zapret-71.4

# Копируем новые исходники (переименовываем папку, чтобы Makefile нашёл)
cp -r /tmp/zapret-72.12 padavan-ng/trunk/user/nfqws/zapret-71.4

echo "=== Source update complete ==="
