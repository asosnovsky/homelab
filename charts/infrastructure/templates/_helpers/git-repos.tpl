{{ define "git-repo" }}
---
apiVersion: v1
kind: Secret
metadata:
  labels:
    argocd.argoproj.io/secret-type: repository
  name: {{ .name }}
  namespace: "{{ .namespace }}"
type: Opaque
stringData:
    name: {{ .name }}
    type: {{ .type | default "git" }}
    url: {{ .url }}
data:
  sshPrivateKey: "{{ .sshkey | b64enc }}"
{{ end }}