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

# 5. Удаляем старые исходники и временные файлы
rm -rf padavan-ng/trunk/user/nfqws/zapret-71.4
rm -rf padavan-ng/trunk/user/nfqws/zapretsh-main
rm -f padavan-ng/trunk/user/nfqws/zapret-71.4.tar.gz
rm -f padavan-ng/trunk/user/nfqws/zapretsh-main.tar.gz

# 6. Копируем наши бинарники в папку nfqws
cp -v "$NFQWS" padavan-ng/trunk/user/nfqws/nfqws
cp -v "$TPWS" padavan-ng/trunk/user/nfqws/tpws
chmod 755 padavan-ng/trunk/user/nfqws/nfqws padavan-ng/trunk/user/nfqws/tpws

# 7. Создаём новый Makefile, который просто копирует бинарники в stage/bin
cat > padavan-ng/trunk/user/nfqws/Makefile << 'EOF'
all: install

install:
	@echo "Installing nfqws and tpws from pre-built binaries"
	cp -f nfqws $(STAGEDIR)/bin/
	cp -f tpws $(STAGEDIR)/bin/

clean:
	@echo "Clean skipped for pre-built binaries"

.PHONY: all install clean
EOF

echo "=== Update complete ==="
