#!/bin/bash

# Instalación del servidor DNS (BIND 9) en el servidor
sudo apt update
sudo apt install bind9 -y

# Iniciar el servicio BIND 9 si no está en ejecución
sudo service bind9 start

# Editar el archivo de configuración principal
sudo nano /etc/bind/named.conf

# Este archivo debe contener las siguientes líneas:
# include "/etc/bind/named.conf.options";
# include "/etc/bind/named.conf.local";
# include "/etc/bind/named.conf.default-zones";

# Editar el archivo de opciones
sudo nano /etc/bind/named.conf.options

# Este archivo debe contener las siguientes opciones:
# options { 
# directory "/var/cache/bind"; 
# dnssec-validation auto; 
# listen-on-v6 { any; };
# };

# Editar el archivo de configuración local
sudo nano /etc/bind/named.conf.local

# Este archivo debe contener la configuración para la zona 'despliegue.class':
# zone "despliegue.class" {
# type master;
# file "/var/lib/bind/despliegue.class.hosts";
# };
# 
# También añadir la zona reversa 192.168.60.x:
# zone "60.168.192.in-addr.arpa" {
# type master;
# file "/var/lib/bind/192.168.60.rev";
# };

# Editar el archivo de zonas predeterminadas
sudo nano /etc/bind/named.conf.default-zones

# Este archivo debe contener las siguientes zonas predeterminadas:
# zone "." { 
# type hint;
# file "/usr/share/dns/root.hints";
# };
# 
# zone "localhost" {
# type master;
# file "/etc/bind/db.local";
# };
# 
# zone "127.in-addr.arpa" {
# type master;
# file "/etc/bind/db.127";
# };

# Configurar la zona 'despliegue.class' en el archivo correspondiente
sudo nano /var/lib/bind/despliegue.class.hosts

# Añadir la configuración de la zona con los registros SOA, NS, A, CNAME y MX:
# $ttl 3600
# despliegue.class. IN SOA servidor-javi.despliegue.class. admin.despliegue.class. (
# 2024100700    ;
# 3600          ;
# 600           ;
# 1209600       ;
# 3600 )        ;
#
# despliegue.class. IN NS servidor-javi.despliegue.class.    ;
# despliegue.class. IN A 192.168.60.112                      ;
# servidor-javi IN A 192.168.60.112                          ;
# cliente-javi.despliegue.class. IN A 192.168.60.212         ;
# www IN CNAME servidor-javi                                 ;
# correo.despliegue.class. IN MX 10 despliegue.class         ;

# Reiniciar el servicio BIND para aplicar los cambios
sudo service bind9 restart

# Configurar la red para usar el DNS local
# Desactivar otros DNS externos y establecer 192.168.60.112 como único DNS
# Añadir el dominio de búsqueda 'despliegue.class'
sudo nano /etc/network/interfaces

# La configuración de red debe verse de esta forma:
# dns-nameservers 192.168.60.112
# search despliegue.class

# En la máquina cliente, configurar el archivo resolv.conf para usar el servidor DNS
sudo nano /etc/resolv.conf

# Debe contener lo siguiente:
# nameserver 192.168.60.112
# search despliegue.class

# Comprobar la resolución de nombres utilizando dig o nslookup
# Consulta sobre el dominio 'despliegue.class'
dig despliegue.class
# O usar nslookup
nslookup despliegue.class
