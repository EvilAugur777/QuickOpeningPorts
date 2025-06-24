#!/bin/bash

# Указываем путь к iptables-save и ip6tables-save
IPTABLES_SAVE=/sbin/iptables-save
IP6TABLES_SAVE=/sbin/ip6tables-save

# Массивы портов для открытия
TCP_PORTS=(80 8043 9615 16550 502 30550 40555 31550 30750 102 123 2404 5432 1433 30501)
UDP_PORTS=(30550 40555)

# Очистка существующих правил
sudo iptables -F INPUT
sudo iptables -F OUTPUT

# Открываем TCP порты
for PORT in "${TCP_PORTS[@]}"; do
    sudo iptables -A INPUT -p tcp --dport "$PORT" -j ACCEPT
    sudo iptables -A OUTPUT -p tcp --dport "$PORT" -j ACCEPT
done

# Открываем UDP порты
for PORT in "${UDP_PORTS[@]}"; do
    sudo iptables -A INPUT -p udp --dport "$PORT" -j ACCEPT
    sudo iptables -A OUTPUT -p udp --dport "$PORT" -j ACCEPT
done

# Создаем каталог и файлы для сохранения правил, если они не существуют
sudo mkdir -p /etc/iptables
sudo touch /etc/iptables/rules.v4
sudo touch /etc/iptables/rules.v6

# Сохраняем правила
sudo $IPTABLES_SAVE > /etc/iptables/rules.v4  # Сохранение для IPv4
sudo $IP6TABLES_SAVE > /etc/iptables/rules.v6 # Сохранение для IPv6 (если используется)

echo "Правила для портов TCP и UDP успешно добавлены и сохранены."