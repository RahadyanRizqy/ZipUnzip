#!/bin/bash
echo "Selamat datang di Program Ekstrak/Kommpres ZIP"
echo "Menggunakan Shell Script"
echo "==============================================="
echo ""

actionCheck() {
    read -p "Aksi: [kompres/ekstrak/keluar]: " action

    if [ $action = "kompres" ]; then
        return 0

    elif [ $action = "ekstrak" ]; then
        return 0
        
    elif [ $action = "keluar" ]; then
        return 0
    else
        # FALSE
        echo "Input tidak valid"
        echo ""
        return 1
    fi
}

outputCheck() {
    read -p "Nama Output File: " output

    if [ -z "$output" ]; then
        output=$(date +'%Y-%m-%d_%H-%M-%S')
        echo "File output default $output.tar.gz"
        echo ""
        return 0
    else
        echo ""
    fi
}


destinationCheck() {
    read -p "Destinasi (opsional): " destination

    if [ $action = "kompres" ]; then
        if [ -z "$destination" ]; then
            echo "Destinasi default ./"

            echo ""
            echo "List file terkompresi: "
            tar -cvf $output.tar $location
            gzip $output.tar

            echo ""
            echo "File terkompresi: "
            ls -o | grep $output.tar.gz
            echo ""

            return 0
            
        elif [ -d "$destination" ]; then
            echo ""
            echo "List file terkompresi: "
            tar -cvf $output.tar $location
            gzip $output.tar
            mv $output.tar.gz $destination
            
            echo ""
            echo "File terkompresi: "
            ls -o $destination | grep $output.tar.gz
            echo ""
            return 0
        else
            echo "Destinasi tidak ditemukan"
            echo ""
            return 1
        fi
    
    elif [ $action = "ekstrak" ]; then
        if [ -z "$destination" ]; then
            echo "Destinasi default ./"
            cp $location $location.bak
            gzip -d $location

            echo ""
            echo "List file terekstraksi "
            string=$location
            slice_length=${#string}

            end_index=$(( ${#string} - 3 ))
            slice="${string:0:end_index}"

            tar -xvf $slice
            rm $slice
            mv $location.bak $location
            echo ""
            return 0

        elif [ -d "$destination" ]; then
            cp $location $location.bak
            gzip -d $location

            echo ""
            echo "List file terekstraksi ($destination/) : "
            string=$location
            slice_length=${#string}

            end_index=$(( ${#string} - 3 ))
            slice="${string:0:end_index}"

            tar -xvf $slice -C $destination
            rm $slice
            mv $location.bak $location
            ls -o $destination | grep $output.tar.gz
            echo ""
            return 0

        else
            echo "Destinasi tidak ditemukan"
            echo ""
            return 1
        fi
    fi
}

locationCheck() {
    if [ $action = "kompres" ]; then
        read -p "File/folder bila > 1 pisah dgn spasi: " location

        IFS=' ' read -ra files <<< "$location"

        semuafile=true

        for file in "${files[@]}"; do

            if ! ls | grep -qE "^${file//\./\\.}[0-9]*\$"; then
                semuafile=false
                break
            fi
        done

        if $semuafile; then
            echo ""
            return 0
        else
            echo "File/folder tidak ditemukan"
            echo ""
            return 1
        fi

    elif [ $action = "ekstrak" ]; then
        read -p "Nama/Lokasi File GZ: " location

        if [ -e "$location" ]; then
            echo ""
            return 0
        else
            echo "File GZ tidak ditemukan"
            echo ""
            return 1
        fi
    fi
        
}

deleteFile() {
    read -p "Hapus file GZ? [y/t] " delete
    if [ $delete == 'y' ]; then
        rm $location
        echo "File terhapus"
        echo ""
        return 0
    elif [ $delete == 't' ]; then
        echo "File tidak terhapus"
        echo ""
        return 0
    else
        echo "Input tidak valid"
        echo ""
        return 1
    fi
}


while true; do
    if actionCheck; then
        if [ "$action" = "kompres" ]; then
            echo ""
            while true; do
                if locationCheck; then
                    if outputCheck; then
                        while true; do
                            if destinationCheck; then
                                break
                            fi
                        done
                    fi
                    break # BREAK KARENA OUTPUT CHECK MEMILIKI BENTUK DEFAULT
                fi
            done

        elif [ "$action" = "ekstrak" ]; then
            echo ""
            while true; do
                if locationCheck; then
                    while true; do
                        if destinationCheck; then
                                while true; do
                                    if deleteFile; then
                                        break
                                    fi
                                done                            
                                break
                        fi
                    done
                    break # BREAK KARENA OUTPUT CHECK MEMILIKI BENTUK DEFAULT
                fi
            done
        
        elif [ "$action" = "keluar" ]; then
            echo "Keluar dari program..."
            echo ""
            break
        fi
    fi
done