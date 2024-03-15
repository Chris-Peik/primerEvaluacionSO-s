#!/bin/bash
control=0

function printSyslog {
    echo "Invirtiendo e Imprimiendo el Syslog..."
    sleep 1
    echo ""
    (tail -15 /var/log/syslog | sort -r) > syslog.txt 2> /dev/null
    cat syslog.txt
}

function varOperation {
    a=10
    echo a = $a
    echo ""
    b=$((2*10))
    echo "b = 2*10"
    echo b = $b
    echo ""
    c=$(echo "scale=2; $a+($b/2)" | bc)
    echo "c = a+b/2"
    echo c = $c
    echo ""
    d=$(((2+3)*10))
    echo "d = (2+3)*10"
    echo d = $d
    echo ""
    div=$(echo "scale=2; $c/2" | bc)
    echo "div = c/2"
    echo div = $div
    echo ""
    res=$(echo "scale=0; $b % $c" | bc)
    echo "res = b % c"
    echo res = $res
}

function validarArchivos {
if test -r $1
then
    echo $1 "Existe y tiene permisos de LECTURA"
else
    echo $1 "No existe o no tiene permisos de LECTURA"
fi
if test -x $2
then
    echo $2 "Existe y tiene permisos de ejecución"
else
    echo $2 "No existe o no tiene permisos de ejecución"
fi
if test -G $archivo3
then
    echo "El dueño de $3 es: "
    stat -c '%U' ./$archivo3
else
    echo $3 "No existe"
fi
echo "El archivo más antiguo en creación es:"
if test $1 -ot $2
then
	if test $1 -ot $3
	then
		echo $1
	else
		echo $3
	fi
else 
	if test $2 -ot $3
	then
		echo $2
	else
		echo $3
	fi
fi
}

function validarArgumentos {
    if test $# -ne 0
    then
        echo "Hay $# argumentos cuyos valores son:"
        echo $*
    else
        echo "Sin argumentos"
    fi

}

function copyFiles {
    echo "Ingresa el nombre del archivo a leer, recuerda usar la extensión"
    read copy

if test -e $copy && test -n "$copy"
    then
        echo "Archivo Válido"
    else
    echo "El archivo no existe"
    return
    fi

    echo "Ingresa el directorio de destino (Se cuidadoso)"
    read dir

    if test -d $dir
        then
        echo "Directorio Válido"
        else
        echo "El directorio no existe"
        return
        fi
while read -r line
    do 
    if test -e $line
    then
    cp $line $dir
    echo $line" copiado correctamente"
    else 
    echo "El archivo: $line no existe"
    fi
    done < $copy

    echo "Copia Terminada"
}

function findRec {

    echo "Ingresa el directorio de búsqueda:"
    read dir

    if test ! -d $dir 
    then
    echo "El directorio no existe"
    return
    fi

    echo "Ingresa el patrón que deseas buscar:"
    read patt

    resumen="resumen.txt"
    touch $resumen

    grep -r -n --exclude="$resumen" "$patt" > $resumen

    echo "Busqueda completada. El resultado se encuentra en: $resumen"
}


while test $control -eq 0 ;do
clear
echo "######                                                                  ";
echo "#     # #####    ##    ####  ##### #  ####    ##                        ";
echo "#     # #    #  #  #  #    #   #   # #    #  #  #                       ";
echo "######  #    # #    # #        #   # #      #    #                      ";
echo "#       #####  ###### #        #   # #      ######                      ";
echo "#       #   #  #    # #    #   #   # #    # #    #                      ";
echo "#       #    # #    #  ####    #   #  ####  #    #                      ";
echo " #####                                                                  ";
echo "#     # #    # ###### #      #       ####   ####  #####  # #####  ##### ";
echo "#       #    # #      #      #      #      #    # #    # # #    #   #   ";
echo " #####  ###### #####  #      #       ####  #      #    # # #    #   #   ";
echo "      # #    # #      #      #           # #      #####  # #####    #   ";
echo "#     # #    # #      #      #      #    # #    # #   #  # #        #   ";
echo " #####  #    # ###### ###### ######  ####   ####  #    # # #        #   ";
echo "                                                                        ";
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ";
echo "                                                                        ";
echo "Menú: Escoge un programa"
echo "1)Imprimir Syslog Invertido"
echo "2)Variables y Operaciones"
echo "3)Validar Archivos"
echo "4)Validar Argumentos"
echo "5)Copiar archivos leidos de un archivo"
echo "6)Búsqueda Recursiva de Patrones"
echo "7)Salir"
read app
echo ""

case $app in
1)
printSyslog
;;
2)
varOperation
;;
3)
archivo1="archivo1.sh"
archivo2="archivo2.sh"
archivo3="archivo3.sh"
validarArchivos $archivo1 $archivo2 $archivo3
;;
4)
x=1
y=2
z=3
validarArgumentos $x $y $z
;;
5)
copyFiles
;;
6)
findRec
;;
7)
control=1
echo "Estas saliendo del programa..."
sleep 1
;;
*)
echo "No ingresaste una opción válida"
;;
esac
echo ""
echo "Presiona Enter para continuar..."
read
done