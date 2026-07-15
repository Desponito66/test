#!/bin/bash

echo "=== Updating zapret with pre-built binaries ==="

# 1. Скачиваем архив с бинарниками
wget -O /tmp/zapret.tar.gz https://github.com/bol-van/zapret/releases/download/v72.12/zapret-v72.12-openwrt-embedded.tar.gz

# 2. Распаковываем
tar -xzf /tmp/zapret.tar.gz -C /tmp/

# 3. Находим папку
ZAPRET_DIR=$(find /tmp -maxdepth 1 -type d -name "zapret*" | head -1)
if [[ -z "$ZAPRET_DIR" ]]; then
    echo "ERROR: Could not find extracted zapret directory"
    exit 1
fi

# 4. Проверяем наличие бинарников для mipsel
NFQWS="$ZAPRET_DIR/binaries/linux-mipsel/nfqws"
TPWS="$ZAPRET_DIR/binaries/linux-mipsel/tpws"
if [[ ! -f "$NFQWS" || ! -f "$TPWS" ]]; then
    echo "ERROR: nfqws or tpws not found in $ZAPRET_DIR/binaries/linux-mipsel/"
    ls -la "$ZAPRET_DIR/binaries/"
    exit 1
fi

echo "Found nfqws: $NFQWS"
echo "Found tpws: $TPWS"

# 5. Создаём папку stage/bin, если её нет
mkdir -p padavan-ng/trunk/stage/bin

# 6. Копируем бинарники в stage/bin (ОНИ ПОПАДУТ В ОБРАЗ!)
cp -v "$NFQWS" padavan-ng/trunk/stage/bin/nfqws
cp -v "$TPWS" padavan-ng/trunk/stage/bin/tpws
chmod 755 padavan-ng/trunk/stage/bin/nfqws padavan-ng/trunk/stage/bin/tpws

# 7. Удаляем старые исходники, чтобы сборщик не трогал их
rm -rf padavan-ng/trunk/user/nfqws/zapret-71.4
rm -rf padavan-ng/trunk/user/nfqws/zapretsh-main
rm -f padavan-ng/trunk/user/nfqws/zapret-71.4.tar.gz
rm -f padavan-ng/trunk/user/nfqws/zapretsh-main.tar.gz

# 8. Создаём фиктивный Makefile, который ничего не делает
cat > padavan-ng/trunk/user/nfqws/Makefile << 'EOF'
all: install

install:
	@echo "nfqws and tpws already installed in stage/bin"

clean:
	@echo "Clean skipped"

.PHONY: all install clean
EOF

echo "=== Update complete ==="
