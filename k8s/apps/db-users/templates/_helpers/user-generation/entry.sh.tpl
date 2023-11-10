{{- define "pg-users.entry" -}}
#!/bin/sh

cp -r /app /tmp/app

cd /tmp/app && \
    terraform init && \
    terraform apply -auto-approve -input=false \
        -var-file="/app/users.tfvars" \
        -var-file="/app/db_users_dbs.tfvars" \
        -lock=false
{{- end -}}