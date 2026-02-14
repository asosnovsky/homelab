{{ define "git-repo" }}
---
apiVersion: v1
kind: Secret
metadata:
  labels:
    argocd.argoproj.io/secret-type: repository
  name: argocd-repo-{{ .name }}
  namespace: "{{ .namespace }}"
type: Opaque
data:
    "name": "{{ .name | b64enc }}"
    "type": "{{ .type | default "git" | b64enc }}"
    "url": "{{ .url | b64enc }}"
    {{ range $k, $v := .data }}
    "{{ $k }}": |-
      {{ $v | b64enc }}
    {{ end }}
{{ end }}
