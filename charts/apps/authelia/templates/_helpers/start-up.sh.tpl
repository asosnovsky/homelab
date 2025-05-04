
{{ define "authelia.scripts.startUp" }}
#!/bin/sh

users_folder="{{ .authentication_backend.file.path }}"
initial_password=$(authelia crypto hash generate --password admin | sed 's/^Digest: //') 

if [ ! -f ${users_folder} ]; then
    echo "users:" >> $users_folder
    echo "  admin:" >> $users_folder
    echo "      disabled: false" >> $users_folder
    echo "      password: '$initial_password'" >> $users_folder
    echo "      groups:" >> $users_folder
    echo "          - admin" >> $users_folder
fi

{{ end }}