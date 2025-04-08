#!/bin/bash
echo "Starting FydeOS ARCVM installation on Chromium OS..."

# Проверка прав
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)."
  exit
fi

# Создаем директорию для ARCVM
echo "Creating directories for ARCVM..."
mkdir -p /opt/arcvm

# Загрузка FydeOS ARCVM
echo "Downloading FydeOS ARCVM files..."
wget https://github.com/FydeOS-ArcHero/arcvm-release.tar.gz -O /tmp/arcvm-release.tar.gz
if [ $? -ne 0 ]; then
  echo "Failed to download ARCVM files. Exiting..."
  exit 1
fi

# Распаковываем файлы
echo "Extracting ARCVM files..."
tar -xvf /tmp/arcvm-release.tar.gz -C /opt/arcvm

# Настройка среды ARCVM
echo "Setting up ARCVM environment..."
cd /opt/arcvm
if [ -f setup.sh ]; then
  chmod +x setup.sh
  ./setup.sh
else
  echo "Setup script not found. Exiting..."
  exit 1
fi

# Установка и активация ARCVM
echo "Activating ARCVM..."
systemctl enable arcvm
systemctl start arcvm

# Удаление временных файлов
echo "Cleaning up temporary files..."
rm /tmp/arcvm-release.tar.gz

# Завершение
echo "FydeOS ARCVM installed successfully!"
echo "You can now install APK files using adb. Example:"
echo "  adb install my_app.apk"
exit 0
