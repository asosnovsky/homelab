{{- define "pg-users.entry" -}}
#!/bin/sh

cp -r /app /tmp/app

cd /tmp/app && \
    terraform init && \
    terraform apply -auto-approve -input=false -var-file="/app/users.tfvars"
{{- end -}}