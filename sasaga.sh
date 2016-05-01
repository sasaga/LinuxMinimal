#!/bin/bash
#proyecto LinuxMinimal sistema linux minimo
#Autor: Samir Sanchez Garnica (by:sasaga)
#twitter @sasaga92
#
#
#

#    Copyright (C) <2016>  <samir sanchez garnica>

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


# Ruta de almacenamiento de datos para la compilaacion del sistema
WORK_PATH_ACTUAL=$(pwd)
WORK_PATH="/tmp/SASAGA/"
WORK_PATH_COMPILER="/tmp/SASAGA/src"
WORK_PATH_COMPILER_ROOTFS="/tmp/SASAGA/src/rootfs"
WORK_PATH_COMPILER_ROOTFS_LIB="/tmp/SASAGA/src/rootfs/lib"
WORK_PATH_CREATE="/tmp/SASAGA/src/live"
WORK_PATH_FICHERO_DOWNLOAD="/tmp/SASAGA/DOWNLOAD"


#Colores manejados para el script
blanco="\033[1;37m"
gris="\033[0;37m"
magenta="\033[0;35m"
rojo="\033[1;31m"
verde="\033[1;32m"
amarillo="\033[1;33m"
azul="\033[1;34m"
rescolor="\e[0m"





#header del script, pantalla de bienvenida del sistema de compilacion...
function mostrarheader(){

	echo -e "$verde############################################################"
	echo -e "$verde#                                                          #"
	echo -e "$verde#$rojo		 LinuxMinimal $version" "${amarillo}by ""${azul}SASAGA""$verde                   #"
	echo -e "$verde#""${rojo}	S""${amarillo}ASAGA" "${rojo}N""${amarillo}o" "${rojo}E""${amarillo}s un ""${rojo}F""${amarillo}ramework ""${rojo}De" "${rojo}S""${amarillo}istemas" "${rojo}O""${amarillo}perativos""$verde   #"
	echo -e "$verde#                                                          #"
	echo -e "$verde############################################################""$rescolor"
	echo
	echo
}
mostrarheader


############################################## < INICIO > ##############################################


# pedimos acceso de root para poder ejecutar el script


if ! [ $(id -u) = "0" ] 2>/dev/null; then
	echo -e "\e[1;31mUsted no tiene suficientes privilegios"$rescolor""
	exit
fi

# Si se cierra el script inesperadamente, ejecutar la funcion inmediatamente
trap exitmode SIGINT

function exitmode {
	echo -e "\n\n"$blanco"["$rojo"-"$blanco"] "$rojo"Ejecutando la limpieza y cerrando."$rescolor""
	if [ ! -d $WORK_PATH ]; then
		exit
else
	rm -R $WORK_PATH
	echo -e ""$blanco"["$verde"+"$blanco"] "$verde"Limpiza efectuada con exito!"$rescolor""
	exit
fi
}





# Crear carpeta de trabajo
if [ ! -d $WORK_PATH ]; then

	for directory in $WORK_PATH $WORK_PATH_COMPILER $WORK_PATH_COMPILER_ROOTFS $WORK_PATH_COMPILER_ROOTFS_LIB $WORK_PATH_FICHERO_DOWNLOAD
	do
		mkdir $directory
	done

else
	if [ -d $WORK_PATH ]; then
		comprobar=$(find $WORK_PATH | wc -l)
        dir=5
		if [ "$comprobar" != "$dir" ]; then
     	  echo -e "\e[1;31mHubo algun error al crear directorio de trabajo"$rescolor""
	      exitmode
	    fi
   fi

fi


# comprobar conexion a internet   y descargamos dependencias faltantes, en caso de que alla acceso a internet
function checkRed {
   echo -ne "Comprobando_conexion_a_internet....."$rescolor""
   WGET="/usr/bin/wget"
   $WGET -q --tries=10 --timeout=5 http://www.google.com.co -O /tmp/index.google &> /dev/null
   if [ ! -s /tmp/index.google ];then
       echo -e "\e[1;31mNo esta Conectado"$rescolor""
       echo -e "\e[1;31mImposible descargar dependencias"$rescolor""

   else
       echo -e "\e[1;32mOK!"$rescolor""
        dep1=$(sed -e '/xterm/ !d' $WORK_PATH_FICHERO_DOWNLOAD/list.txt)
        dep2=$(sed -e '/genisoimage/ !d' $WORK_PATH_FICHERO_DOWNLOAD/list.txt)
        dep3=$(sed -e '/gzip/ !d' $WORK_PATH_FICHERO_DOWNLOAD/list.txt)
        dep4=$(sed -e '/strip/ !d' $WORK_PATH_FICHERO_DOWNLOAD/list.txt)
        dep5=$(sed -e '/cpio/ !d' $WORK_PATH_FICHERO_DOWNLOAD/list.txt)
        dep6=$(sed -e '/tar/ !d' $WORK_PATH_FICHERO_DOWNLOAD/list.txt)

        for i in /bin /sbin /usr/bin /usr/sbin ; do

             if [ -f $i/yast ]; then
                  encontrado="yast"
             fi

             if [ -f $i/yast2 ]; then
                  encontrado="yast2"
             fi

             if [ -f $i/yum ]; then
                  encontrado="yum"
             fi

             if [ -f $i/pacman ]; then
                  encontrado="pacman"
             fi

             if [ -f $i/apt-get ]; then
                  encontrado="apt-get"
             fi

             if [ -f $i/zipper ]; then
                  encontrado="zipper"
             fi

             if [ -f $i/emerge ]; then
                  encontrado="emerge"
             fi

       done

	    if [ -n "$dep1" ]; then
	    	echo -e  $azul"instalando dependencias faltantes por favor espere"$rescolor
            gnome-terminal -x  $encontrado install xterm  2> /dev/null &
        fi

        if [ -n "$dep2" ]; then
	    	echo -e $azul"instalando dependencias faltantes por favor espere"$rescolor
            xterm -title "install genisoimage"  -e $encontrado install genisoimage &

        fi

        if [ -n "$dep3" ]; then
	    	echo -e $azul"instalando dependencias faltantes por favor espere"$rescolor
            xterm -title "install gzip"  -e $encontrado install gzip &

        fi

        if [ -n "$dep4" ]; then
	    	echo -e $azul"instalando dependencias faltantes por favor espere"$rescolor
            xterm -title "install strip"  -e $encontrado install strip&

        fi

        if [ -n "$dep5" ]; then
	    	echo -e $azul"instalando dependencias faltantes por favor espere"$rescolor
            xterm -title "install cpio"  -e $encontrado install cpio &

        fi

        if [ -n "$dep6" ]; then
	    	echo -e $azul"instalando dependencias faltantes por favor espere"$rescolor
            xterm -title "install tar"  -e $encontrado install tar &

        fi
   fi

	 sleep 1
	 exitmode

}

#checamos las dependecias para poder llevar con exito la construccion
function checkdependences {
	echo "Verificando dependencias"
	echo -ne "xterm....."
	if ! hash xterm 2>/dev/null; then
		echo -e "\e[1;31mNo esta Instalado"$rescolor""
		echo "xterm" >> $WORK_PATH_FICHERO_DOWNLOAD/list.txt
		salir=1
	else
		echo -e "\e[1;32mOK!"$rescolor""
	fi
	sleep 0.025
	echo -ne "genisoimage....."
	if ! hash genisoimage 2>/dev/null; then
		echo -e "\e[1;31mNo esta Instalado"$rescolor""
		echo "genisoimage " >> $WORK_PATH_FICHERO_DOWNLOAD/list.txt
		salir=1
	else
		echo -e "\e[1;32mOK!"$rescolor""
	fi
	sleep 0.025
	echo -ne "Gzip....."
	if ! hash gzip 2>/dev/null; then
		echo -e "\e[1;31mNo esta Instalado"$rescolor""
		salir=1
	else
		echo -e "\e[1;32mOK!"$rescolor""
	fi
	sleep 0.025
	echo -ne "strip....."
	if ! hash strip 2>/dev/null; then
		echo -e "\e[1;31mNo esta Instalado"$rescolor""
		salir=1
	else
		echo -e "\e[1;32mOK!"$rescolor""
	fi
	sleep 0.025
	echo -ne "cpio....."
	if ! hash cpio 2>/dev/null; then
		echo -e "\e[1;31mNo esta Instalado"$rescolor""
		salir=1
	else
		echo -e "\e[1;32mOK!"$rescolor""
	fi
	sleep 0.025
	echo -ne "tar....."
	if ! hash tar 2>/dev/null; then
		echo -e "\e[1;31mNo esta Instalado"$rescolor""
		salir=1
	else
		echo -e "\e[1;32mOK!"$rescolor""
	fi

	sleep 1
	if [ "$salir" = "1" ]; then
		if [ -f $WORK_PATH_FICHERO_DOWNLOAD/list.txt ]; then
			echo -e "\e[1;31mFaltan algunas dependencias"$rescolor""
			checkRed

		fi

	fi
}
checkdependences





#copiamos y compilamos busybox
function compilacion {
	echo -e "$verde############################################################"
	echo -e "$verde#            ${rojo}C${amarillo}ONFIGURACION ${rojo}D${amarillo}E ${rojo}B${amarillo}U${rojo}S${amarillo}YBOX   ${verde}                   #"
	echo -e "$verde############################################################"
	if [ ! -d packages ]; then
		echo -e "\e[1;31mVerifique que exista el directorio packages"$rescolor""
		exitmode
	else
	    tar -xf packages/busybox-1.22.1.tar.bz2 -C $WORK_PATH_COMPILER
        cp -a $WORK_PATH_COMPILER/busybox-1.22.1/* $WORK_PATH_COMPILER_ROOTFS
        rm -R $WORK_PATH_COMPILER/busybox-1.22.1/
        echo -e "$amarillo copia y compilacion Busybox \e[1;32mOK!"$rescolor""
        sleep 1
fi


if [ ! -f $WORK_PATH_COMPILER_ROOTFS/init ]; then
	rm $WORK_PATH_COMPILER_ROOTFS/linuxrc
	cd $WORK_PATH_COMPILER_ROOTFS/
	ln -s bin/busybox init
	echo -e "$amarillo configuracion Busybox \e[1;32mOK!"$rescolor""
	sleep 1

else

		echo -e "\e[1;31mEl Archivo init ya existe "$rescolor""
		sleep 0.025
fi




 cd $WORK_PATH_ACTUAL
if [ ! -d libraries ]; then
	echo -e "\e[1;31mVerifique que exista el directorio libraries"$rescolor""
		exitmode
else
	cp libraries/* $WORK_PATH_COMPILER_ROOTFS_LIB
	strip $WORK_PATH_COMPILER_ROOTFS_LIB/*
	echo -e "$amarillo Copiando Librerias \e[1;32mOK!"$rescolor""
	sleep 1
	clear
fi


}
compilacion

#creamos nuestra jerarquia de directorios
function jerarquia {
	echo -e "$verde############################################################"
	echo -e "$verde#            ${rojo}C${amarillo}REANDO ${rojo}J${amarillo}ERARQUIA ${rojo}D${amarillo}E ${rojo}D${amarillo}IRECTORIOS   ${verde}           #"
	echo -e "$verde############################################################"
	for var in dev etc etc/init.d root home proc media mnt sys tmp var usr/lib usr/local usr/games usr/share usr/share/doc usr/share/kmap usr/share/udhcpc var/cache var/lib var/lock var/log var/games var/run var/spool media/cdrom media/flash media/usbdisk
	  do
	    mkdir -p  $WORK_PATH_COMPILER_ROOTFS/$var
	    echo -e "$amarillo directorio:  $var \e[1;32mOK!"$rescolor""
	    sleep 0.5
	done
	chmod 1777 $WORK_PATH_COMPILER_ROOTFS/tmp
	echo -e $amarillo"Aplicando Permisos a $rojo temp  \e[1;32mOK!"$rescolor""
	sleep 1
	clear
}
jerarquia


#creamos los ficheros para configuracion de algunas herramientas
function CrearFicherosAplicaciones {
	echo -e "$verde############################################################"
	echo -e "$verde#            ${rojo}C${amarillo}REANDO ${rojo}F${amarillo}ICHEROS ${rojo}P${amarillo}ARA ${rojo}A${amarillo}PLICACIONES   ${verde}         #"
	echo -e "$verde############################################################"
	touch $WORK_PATH_COMPILER_ROOTFS/etc/ld.so.conf
	if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/ld.so.conf ]; then
		echo -e "\e[1;31mFichero: ld.so.conf no creado error"$rescolor""
		sleep 0.025
	else
	echo -e "$amarillo Fichero: ld.so.conf  \e[1;32mOK!"$rescolor""
	sleep 0.5
	fi
    cp ficheros/rpc $WORK_PATH_COMPILER_ROOTFS/etc
	if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/rpc ]; then
		echo -e "\e[1;31mHubo un error al copiar RPC"$rescolor""
		exitmode
	else
	echo -e "$amarillo Fichero: RPC \e[1;32mOK!"$rescolor""
	sleep 0.5
	fi
	 cp ficheros/profile $WORK_PATH_COMPILER_ROOTFS/etc
	if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/profile ]; then
		echo -e "\e[1;31mHubo un error al copiar PROFILE"$rescolor""
		exitmode
	else
	echo -e "$amarillo Fichero: profile \e[1;32mOK!"$rescolor""
	sleep 0.5
	fi

	echo -e "$amarillo Dispositivos en :  /dev  \e[1;32mOK!"$rescolor""
	sleep 0.5
	clear
    cd $WORK_PATH_COMPILER_ROOTFS/dev


    ##################### creamos los dispositivos del directorio /dev #########################


    # make usfull directories.
    for dis in pts input net usb shm
    do
    	mkdir $dis
    done

    #
    #
    mknod input/event0 c 13 64
    mknod input/event1 c 13 65
    mknod input/event2 c 13 66
    mknod input/mouse0 c 13 32
    mknod input/mice c 13 63
    mknod input/ts0 c 254 0

    # miscellaneous one-of-a-kind stuff.
    #
    mknod logibm c 10 0
    mknod psaux c 10 1
    mknod inportbm c 10 2
    mknod atibm c 10 3
    mknod console c 5 1
    mknod full c 1 7
    mknod kmem c 1 2
    mknod mem c 1 1
    mknod null c 1 3
    mknod port c 1 4
    mknod random c 1 8
    mknod urandom c 1 9
    mknod zero c 1 5
    mknod rtc c 10 135
    mknod sr0 b 11 0
    mknod sr1 b 11 1
    mknod agpgart c 10 175
    mknod dri c 10 63
    mknod ttyS0 c 4 64
    mknod audio c 14 4
    mknod beep c 10 128
    mknod ptmx c 5 2
    mknod nvram c 10 144
    ln -s /proc/kcore core

    # net/tun device
    #
    mknod net/tun c 10 200

    # framebuffer devs.
    #
    mknod fb0 c 29 0
    mknod fb1 c 29 32
    mknod fb2 c 29 64
    mknod fb3 c 29 96
    mknod fb4 c 29 128
    mknod fb5 c 29 160
    mknod fb6 c 29 192

    # usb/hiddev
    #
    mknod usb/hiddev0 c 180 96
    mknod usb/hiddev1 c 180 97
    mknod usb/hiddev2 c 180 98
    mknod usb/hiddev3 c 180 99
    mknod usb/hiddev4 c 180 100
    mknod usb/hiddev5 c 180 101
    mknod usb/hiddev6 c 180 102

    # IDE HD devs
    # with a fiew concievable partitions; you can do
    # more of them yourself as you need 'em.
    #

    # hda devs
    #
    mknod hda b 3 0
    mknod hda1 b 3 1
    mknod hda2 b 3 2
    mknod hda3 b 3 3
    mknod hda4 b 3 4
    mknod hda5 b 3 5
    mknod hda6 b 3 6
    mknod hda7 b 3 7
    mknod hda8 b 3 8
    mknod hda9 b 3 9

    # hdb devs
    #
    mknod hdb b 3 64
    mknod hdb1 b 3 65
    mknod hdb2 b 3 66
    mknod hdb3 b 3 67
    mknod hdb4 b 3 68
    mknod hdb5 b 3 69
    mknod hdb6 b 3 70
    mknod hdb7 b 3 71
    mknod hdb8 b 3 72
    mknod hdb9 b 3 73

    # hdc and hdd with cdrom symbolic link.
    #
    mknod hdc b 22 0
    mknod hdd b 22 64
    ln -s hdc cdrom

    # sda devs
    #
    mknod sda  b 8 0
    mknod sda1 b 8 1
    mknod sda2 b 8 2
    mknod sda3 b 8 3
    mknod sda4 b 8 4
    mknod sda5 b 8 5
    mknod sda6 b 8 6
    mknod sda7 b 8 7
    mknod sda8 b 8 8
    mknod sda9 b 8 9
    ln -s sda1 flash

    # sdb devs
    #
    mknod sdb b 8 16
    mknod sdb1 b 8 17
    mknod sdb2 b 8 18
    mknod sdb3 b 8 19
    mknod sdb4 b 8 20
    mknod sdb5 b 8 21
    mknod sdb6 b 8 22
    mknod sdb7 b 8 23
    mknod sdb8 b 8 24
    mknod sdb9 b 9 25

    # Floppy device.
    #
    mknod fd0 b 2 0

    # loop devs
    #
    for i in `seq 0 7`; do
    	mknod loop$i b 7 $i
    done

    # ram devs
    #
    for i in `seq 0 7`; do
    	mknod ram$i b 1 $i
    done
    ln -s ram1 ram

    # tty devs
    #
    mknod tty c 5 0
    for i in `seq 0 7`; do
    	mknod tty$i c 4 $i
    done

    # virtual console screen devs
    #
    for i in `seq 0 7`; do
    	mknod vcs$i b 7 $i
    done
    ln -s vcs0 vcs

    # virtual console screen w/ attributes devs
    #
    for i in `seq 0 7`; do
    	mknod vcsa$i b 7 $i
    done
    ln -s vcsa0 vcsa


    # Symlinks.
    #
    ln -snf /proc/self/fd fd
    ln -snf /proc/self/fd/0 stdin
    ln -snf /proc/self/fd/1 stdout
    ln -snf /proc/self/fd/2 stderr

    # cambio de permisos.
    #
    echo -e "$amarillo cambiando permisos a dispositivos \e[1;32mOK!"$rescolor""
    chmod 0666 ptmx
    chmod 0666 null
    chmod 0622 console
    chmod 0666 tty*


    # fin del script
    echo -e "$amarillo dispositivos creados exitosmente  \e[1;32mOK!"$rescolor""
    cd $WORK_PATH_ACTUAL

    #########################
}
CrearFicherosAplicaciones

#creamos el fichero del sistema
echo -e "$verde############################################################"
	echo -e "$verde#            ${rojo}C${amarillo}REANDO ${rojo}F${amarillo}ICHEROS ${rojo}P${amarillo}ARA ${rojo}S${amarillo}ISTEMA   ${verde}              #"
	echo -e "$verde############################################################"
function FicheroSistemas {
	#fichero host
	if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/hosts ]; then
    echo "127.0.0.1 localhost" > $WORK_PATH_COMPILER_ROOTFS/etc/hosts
    echo -e "$amarillo Fichero: hosts  \e[1;32mOK!"$rescolor""
    sleep 0.5
else
		echo -e "\e[1;31mEl Fichero: hosts ya existe "$rescolor""
		sleep 0.025

fi
#fichero networks
if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/networks ]; then
    echo "localnet 127.0.0.1" > $WORK_PATH_COMPILER_ROOTFS/etc/networks
    echo -e "$amarillo Fichero: networks \e[1;32mOK!"$rescolor""
    sleep 0.5

else

		echo -e "\e[1;31mEl Fichero:  networks ya existe "$rescolor""
		sleep 0.025

fi
#fichero host.conf
if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/host.conf ]; then
	echo "order hosts,bind" > $WORK_PATH_COMPILER_ROOTFS/etc/host.conf
	echo "multi on" >> $WORK_PATH_COMPILER_ROOTFS/etc/host.conf
		echo -e "$amarillo Fichero: host.conf  \e[1;32mOK!"$rescolor""
        sleep 0.5
else
		echo -e "\e[1;31mEl Fichero: host.conf ya existe "$rescolor""
		sleep 0.025

fi
#fichero hostname
if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/hostname ]; then
    echo "sasaga" > $WORK_PATH_COMPILER_ROOTFS/etc/hostname
    echo -e "$amarillo Fichero: hostname \e[1;32mOK!"$rescolor""
    sleep 0.5
else
		echo -e "\e[1;31mEl Fichero: hostname ya existe "$rescolor""
		sleep 0.025
fi

#fichero nsswitch.conf

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/nsswitch.conf ]; then
    echo """
    # nano etc/nsswitch.conf
    # /etc/nsswitch.conf: GNU Name Service Switch config.
    #
    passwd: files
    group: files
    shadow: files
    hosts: files dns
    networks: files
    """ > $WORK_PATH_COMPILER_ROOTFS/etc/nsswitch.conf
    echo -e "$amarillo Fichero: nsswitch.conf \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero: nsswitch.conf ya existe "$rescolor""
	sleep 0.025
fi

#creamos fichero securetty

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/securetty ]; then
	echo """
# nano etc/securetty
# /etc/securetty: List of terminals on which root is allowed to login.
console
# For people with serial port consoles
ttyS0
# Standard consoles
tty1
tty2
tty3
tty4
tty5
tty6
tty7
""" > $WORK_PATH_COMPILER_ROOTFS/etc/securetty
    echo -e "$amarillo Fichero: securetty \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero:  securetty ya existe "$rescolor""
	sleep 0.025
fi
#creamos ficheros shells

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/shells ]; then

	echo """
 # nano etc/shells
 # /etc/shells: valid login shells.
   /bin/sh
   /bin/ash
   /bin/hush
    """ > $WORK_PATH_COMPILER_ROOTFS/etc/shells
    echo -e "$amarillo Fichero: shells \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero:  shells ya existe "$rescolor""
	sleep 0.025
fi

#creamos fichero issue

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/issue ]; then
	echo "sasaga GNU/Linux 1.0 Kernel \r \l" > $WORK_PATH_COMPILER_ROOTFS/etc/issue
    echo -e "$amarillo Fichero: issue \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero:  issue ya existe "$rescolor""
	sleep 0.025
fi

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/motd ]; then

echo """
# nano etc/motd
(°- { Obtenga la documentacion de construccion  en: /usr/share/doc.
//\ Uso: menos o más para leer los archivos, 'su' ser root}
v_/_ SASAGA
""" > $WORK_PATH_COMPILER_ROOTFS/etc/motd
    echo -e "$amarillo Fichero: motd \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero: motd ya existe "$rescolor""
	sleep 0.025
fi

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/busybox.conf ]; then
 echo """
# /etc/busybox.conf: sasaga GNU/linux Busybox configuration.
#
[SUID]
# Allow command to be run by anyone.
su = ssx root.root
passwd = ssx root.root
loadkmap = ssx root.root
mount = ssx root.root
reboot = ssx root.root
halt = ssx root.root
""" > $WORK_PATH_COMPILER_ROOTFS/etc/busybox.conf
      #chmod 600 $WORK_PATH_COMPILER_ROOTFS/etc/busybox.conf
    echo -e "$amarillo Fichero: busybox.conf \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero: busybox.conf ya existe "$rescolor""
	sleep 0.025
fi


if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/inittab ]; then
echo """
# nano etc/inittab
# /etc/inittab: init configuration for sasaga GNU/Linux.
::sysinit:/etc/init.d/rcS
::respawn:-/bin/sh
tty2::askfirst:-/bin/sh
::ctrlaltdel:/bin/umount -a -r
::ctrlaltdel:/sbin/reboot
""" > $WORK_PATH_COMPILER_ROOTFS/etc/inittab
    echo -e "$amarillo Fichero: inittab \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl  Fichero: inittab ya existe "$rescolor""
	sleep 0.025
fi

#creamos fichero passwd, shadow group gshadow

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/passwd ]; then
    echo "root:x:0:0:root:/root:/bin/sh" > $WORK_PATH_COMPILER_ROOTFS/etc/passwd
    echo -e "$amarillo Fichero: passwd \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero:  passwd ya existe "$rescolor""
	sleep 0.025
fi

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/shadow ]; then
    echo "root::13525:0:99999:7:::" > $WORK_PATH_COMPILER_ROOTFS/etc/shadow
    echo -e "$amarillo Fichero: shadow \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero: shadow ya existe "$rescolor""
	sleep 0.025
fi

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/group ]; then
    echo "root:x:0:" > $WORK_PATH_COMPILER_ROOTFS/etc/group
    echo -e "$amarillo Fichero: group \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero:  group ya existe "$rescolor""
	sleep 0.025
fi

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/gshadow ]; then
    echo "root:*::" > $WORK_PATH_COMPILER_ROOTFS/etc/gshadow
    echo -e "$amarillo Fichero: gshadow \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero: gshadow ya existe "$rescolor""
	sleep 0.025
fi

#aplicamos permisos a gshadow y shadow

for per in shadow gshadow
do
	#chmod 640 $WORK_PATH_COMPILER_ROOTFS/etc/$per
	echo -e "$amarillo Permisos:$per \e[1;32mOK!"$rescolor""


done

#creamos fichero fstab
if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/fstab ]; then
echo """
# /etc/fstab: information about static file system.
#

proc                   /proc                 proc       defaults     0        0
sysfs                  /sys                  sysfs      defaults     0        0
devpts                 /dev/pts              devpts     defaults     0        0
tmpfs                  /dev/shm              tmpfs      defaults     0        0

""" > $WORK_PATH_COMPILER_ROOTFS/etc/fstab
    echo -e "$amarillo Fichero: fstab \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEl Fichero: fstab ya existe "$rescolor""
	sleep 0.025
fi

#creamos enlace simbolico a mtab

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/mtab ]; then
	ln -s /proc/mounts $WORK_PATH_COMPILER_ROOTFS/etc/mtab
    echo -e "$amarillo Enlace a: mtab \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mEnlace a:  mtab  ya existe "$rescolor""
	sleep 0.025
fi

if [ ! -f $WORK_PATH_COMPILER_ROOTFS/usr/share/kmap/fr_CH.kmap ]; then
	$WORK_PATH_COMPILER_ROOTFS/bin/busybox dumpkmap > $WORK_PATH_COMPILER_ROOTFS/usr/share/kmap/fr_CH.kmap
    echo -e "$amarillo Configuracion teclado: KMAP \e[1;32mOK!"$rescolor""
    sleep 0.5
else
	echo -e "\e[1;31mConfiguracion teclado: KMAP  ya existe "$rescolor""
	sleep 0.025
fi

#copiando default.script
if [ ! -f $WORK_PATH_COMPILER_ROOTFS/usr/share/udhcpc/default.script ]; then
    cp ficheros/simple.script $WORK_PATH_COMPILER_ROOTFS/usr/share/udhcpc/default.script
    echo -e "$amarillo defult.script ==> udhcpc \e[1;32mOK!"$rescolor""
    chmod +x $WORK_PATH_COMPILER_ROOTFS/usr/share/udhcpc/default.script
     echo -e "$amarillo Aplicando permisos defult.script ==> udhcpc \e[1;32mOK!"$rescolor""
    sleep 0.025
else
	echo -e "\e[1;31mArchivo defult.script ==> udhcpc  ya existe "$rescolor""
	sleep 1
fi

#creando el archivo de arranque rcS
if [ ! -f $WORK_PATH_COMPILER_ROOTFS/etc/init.d/rcS ]; then
echo """
#! /bin/sh
# /etc/init.d/rcS: rcS initial script.
#
#KMAP=fr_CH
/bin/mount proc
/bin/mount -a
/bin/hostname -F /etc/hostname
/sbin/ifconfig lo 127.0.0.1 up
#/sbin/loadkmap < /usr/share/kmap/fr_CH.kmap

""" >$WORK_PATH_COMPILER_ROOTFS/etc/init.d/rcS
    chmod +x $WORK_PATH_COMPILER_ROOTFS/etc/init.d/rcS
    sleep 0.5
         echo -e "$amarillo Fichero: rcS Demonio \e[1;32mOK!"$rescolor""
else
	echo -e "\e[1;31mFichero:  rcS Demonio  ya existe "$rescolor""
	sleep 0.025
fi

}

FicheroSistemas
#comprimimos el sistema raiz
function compiler {
  cd $WORK_PATH_COMPILER_ROOTFS
 find  . -print | cpio -o -H newc 2>/dev/null | gzip -9 > ../rootfs.gz 2>/dev/null &
 echo -e "$amarillo compresion de rootfs  \e[1;32mOK!"$rescolor""
 sleep 0.5
 cd  $WORK_PATH_ACTUAL
 clear
}
compiler




#funcion que contendra la crecion de los directorios para sistema de arranque
#copiaremos el kernel al directorio boot y rootfs tambien a boot
#configuracion de isolinux
echo -e "$verde############################################################"$rescolor
	echo -e "$verde#            ${rojo}C${amarillo}REANDO ${rojo}D${amarillo}IRECTORIO ${rojo}l${amarillo}IVE   ${verde}                    #" $rescolor                 #"
	echo -e "$verde############################################################"$rescolor
function CreateDirectorioLive {
	if [ ! -d $WORK_PATH_COMPILER/live ]; then
		for work in live  live/boot/ live/boot/isolinux
		do
		mkdir -p $WORK_PATH_COMPILER/$work
		echo -e "$amarillo Directorio: $work \e[1;32mOK!"$rescolor""
		sleep 0.5
		done
		cp kernel/bzImage $WORK_PATH_COMPILER/live/boot/
		echo -e "$amarillo Copiando Kernel  \e[1;32mOK!"$rescolor""
		sleep 0.5
		cp $WORK_PATH_COMPILER/rootfs.gz  $WORK_PATH_COMPILER/live/boot/
		echo -e "$amarillo Copiando rootfs  \e[1;32mOK!"$rescolor""
		sleep 0.5
		cp ficheros/isolinux.bin  $WORK_PATH_COMPILER/live/boot/isolinux
        echo -e "$amarillo Copiando ficheros syslinux \e[1;32mOK!"$rescolor""
        sleep 0.5

		#configuramos el sistema de arranque .cfg
        echo """
        # nano livecd/boot/isolinux/isolinux.cfg
        display display.txt
        default sasaga
        label sasaga
        kernel /boot/bzImage
        append initrd=/boot/rootfs.gz rw root=/dev/null vga=788
        implicit 0
        prompt 1
        timeout 20
        """ > $WORK_PATH_COMPILER/live/boot/isolinux/isolinux.cfg
        echo -e "$amarillo Fichero: isolinux.cfg \e[1;32mOK!"$rescolor""
        sleep 0.5

        #copiando archivo inicial display.txt para el inico del boot
        cp ficheros/display.txt  $WORK_PATH_COMPILER/live/boot/isolinux/
        echo -e "$amarillo Fichero: display.txt \e[1;32mOK!"$rescolor""
        sleep 0.5

		else
		echo -e "\e[1;31mFichero:  $work  ya existe "$rescolor""
		sleep 0.025
fi


}
CreateDirectorioLive


echo -e "$verde############################################################"$rescolor
echo -e "$verde#                    ${rojo}I${amarillo}MAGEN ${rojo}G${amarillo}ENERADA   ${verde}                    #"$rescolor""
echo -e "$verde############################################################"$rescolor

function GenerarISO {
	cd $WORK_PATH_COMPILER
	genisoimage -R -o sasaga.iso -b boot/isolinux/isolinux.bin \
    -c boot/isolinux/boot.cat -no-emul-boot -boot-load-size 4 \
    -V "sasaga" -input-charset iso8859-1 -boot-info-table live 2>/dev/null &
    sleep 0.025
    cp sasaga.iso $WORK_PATH_ACTUAL


}
GenerarISO

function verificarISO {
	if [ ! -f $WORK_PATH_ACTUAL/sasaga.iso ]; then
		echo -e "\e[1;31mError la imagen no se genero"$rescolor""
		exitmode
	fi
	echo -e "$amarillo Fichero: sasaga.iso generada correctamente \e[1;32mOK!"$rescolor""
	echo -e ""
	echo -e "$azul Procederemos a limpiar los temporales \e[1;32mOK!"$rescolor""
	sleep 1

	exitmode

}

verificarISO
