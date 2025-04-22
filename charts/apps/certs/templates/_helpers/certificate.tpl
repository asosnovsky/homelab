{{ define "homelab.cert" }}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: cloudflare-wildcard{{.prefix | default ""}}{{ .root }}.{{ .domain }}
spec:
  secretName: cloudflare-wildcard{{.prefix | default ""}}{{ .root }}.{{ .domain }}
  issuerRef:
    name: cloudflare
    kind: Issuer
  commonName: '*{{.prefix | default ""}}{{ .root }}.{{ .domain }}'
  dnsNames:
    -   "*{{.prefix | default ""}}{{ .root }}.{{ .domain }}"
{{ end }}