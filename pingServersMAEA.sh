#!/bin/bash

# Nombre: Miguel Ángel Eacaño Alés

# Fecha: 02-11-24

# Descripción: En este script se hará uso de la información de un fichero de texto que contenga una información,
# en formato <nombreservidor>:<ipservidor>, acerca de servidores.
# Se mostrará información acerca de qué servidores están UP y qué servidores están DOWN.
# Se hará un conteo de cuántos servidores hay en total, cuáles están activos y cuáles están inactivos.

# Funciones previas.

fichservers=$2

conexionservers() {

while IFS=:, read -r nombreserver ipserver; do
    # Comprobar si la IP responde al ping.
    if ping -c 1 "$ipserver" >/dev/null 2>&1; then
        echo "$nombreserver: UP"
    else
        echo "$nombreserver: DOWN"
    fi
done < $fichservers

}

# Ejecución del script.

# Esta condición la coloco aquí porque como función siempre hace que salte el error.
# incluso si colocas los dos parámetros que se piden.

if [ ! "$#" -eq 2 ]; then
        echo "No has pasado el número correcto de parámetros."
        exit
fi

if [ "$1" != "-file" ]; then
        echo "Debes pasar como primer parámetro: -file"
	exit
fi

if [ ! -e "$2" ]; then
        echo "El fichero que has pasado no existe."
        exit
fi

# Almaceno la información de la función conexionservers en un fichero de texto con el mismo nombre
# para que luego sea más óptimo utilizar el comando wc -l.

conexionservers > conexionservers.txt

# Los comandos que contengan el comando wc -l deberán de usar el formato $(comando).

conteoservers=$(cat conexionservers.txt | wc -l)

serversactivos=$(grep "UP" conexionservers.txt | wc -l)

serversinactivos=$(grep "DOWN" conexionservers.txt | wc -l)

nombrearchivo="serverStatus-MAEA-$(date +"%d%m%Y-%H:%M").txt"

{
echo "*******************************************"
echo "SERVER STATUS - DATE: $(date +"%d/%m/%Y %H:%M:%S")"
echo "*******************************************"
cat conexionservers.txt
echo "*******************************************"
echo "STATICSTICS"
echo "*******************************************"
echo "$conteoservers --> Servidores analizados"
echo "$serversactivos --> Servidores UP"
echo "$serversinactivos --> Servidores DOWN"
echo "*******************************************"
echo "END REPORT - BY MIGUEL ÁNGEL ESCAÑO ALÉS"
echo "*******************************************"
} | tee -a "$nombrearchivo"

read -p "¿Quieres guardar las líneas de este informe en un fichero? (S/N): " opcion

if [ "$opcion" == "S" ]; then
	echo "Guardando tu informe en un fichero..."
	sleep 0.5
	touch "$nombrearchivo"
	echo "Observa el fichero de tu informe una vez creado:"
	ls $nombrearchivo
else
	echo "No se guardará nada de este informe en ningún fichero."
fi
