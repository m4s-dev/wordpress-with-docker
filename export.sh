#!/bin/bash

_os="$(uname)"
_now=$(date +"%m_%d_%Y")
_file="wp-data/data_$_now.sql"

# Export dump
EXPORT_COMMAND='exec mysqldump "$MYSQL_DATABASE" -uroot -p"$MYSQL_ROOT_PASSWORD"'
docker-compose exec db sh -c "$EXPORT_COMMAND" > $_file

case "$_os" in
    "Darwin")
        echo "Detectado macOS."
        sed -i '.bak' 1,1d $_file
        ;;
    "Linux")
        echo "Detectado Linux."
        # Como ejemplo, verificamos si es Ubuntu
        if grep -q "Ubuntu" /etc/os-release; then
            echo "Específicamente, es Ubuntu."
            sed -i 1,1d $_file # Removes the password warning from the file
        else
            # Para otras distribuciones Linux, podemos mantener un comportamiento genérico
            sed -i 1,1d $_file # Removes the password warning from the file
        fi
        ;;
    *)
        echo "Sistema operativo no identificado: $_os"
        sed -i 1,1d $_file # Removes the password warning from the file (comportamiento genérico)
        ;;
esac
