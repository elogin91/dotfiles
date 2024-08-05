#!/bin/bash

# Función para mostrar el menú
mostrar_menu() {
    echo "----------------------------------------"
    echo "      Bienvenido al script de actividad"
    echo "----------------------------------------"
    echo "1. Iniciar el script"
    echo "2. Parar el script"
    echo "3. Ver el registro del archivo"
    echo "4. Eliminar el archivo"
    echo "5. Salir"
    echo "----------------------------------------"
}

# Variable para controlar el bucle
ejecutando=false

# Ruta del archivo temporal
archivo="/tmp/actividad_script.txt"

# Asegúrate de que el script se pueda interrumpir limpiamente con Ctrl+C
trap "echo 'Script terminado por el usuario'; exit" SIGINT

# Función para emular la actividad
emular_actividad() {
    while $ejecutando
    do
        # Escribe un mensaje con la fecha y hora actuales en un archivo temporal
        echo "Manteniendo el sistema activo... $(date)" > "$archivo"
        sync  # Asegura que se escriba al disco
        sleep 300  # Espera 5 minutos (300 segundos)
    done
}

# Bucle del menú
while true
do
    if ! $ejecutando; then
        mostrar_menu
    fi

    read -p "Selecciona una opción [1-5]: " opcion

    case $opcion in
        1)
            if $ejecutando; then
                echo "El script ya está en ejecución."
            else
                echo "Iniciando el script..."
                echo "Para pausar el script, selecciona la opción 2 del menú."
                ejecutando=true

                # Inicia la función de emulación de actividad en segundo plano
                emular_actividad &

                # Guarda el PID del subproceso
                script_pid=$!
            fi
            ;;
        2)
            if $ejecutando; then
                echo "Parando el script..."
                ejecutando=false

                # Mata el subproceso
                kill $script_pid
            else
                echo "El script no está en ejecución."
            fi
            ;;
        3)
            if [ -f "$archivo" ]; then
                echo "Contenido del archivo:"
                cat "$archivo"
            else
                echo "El archivo no existe."
            fi
            ;;
        4)
            if [ -f "$archivo" ]; then
                echo "Eliminando el archivo..."
                rm "$archivo"
            else
                echo "El archivo no existe."
            fi
            ;;
        5)
            echo "Saliendo..."
            if $ejecutando; then
                ejecutando=false
                kill $script_pid
            fi
            exit 0
            ;;
        *)
            echo "Opción no válida. Por favor, selecciona 1, 2, 3, 4 o 5."
            ;;
    esac
done
