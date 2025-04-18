{{ define "homelab.cert" }}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: cloudflare-wildcard{{.prefix}}.{{ .root }}.{{ .domain }}
spec:
  secretName: cloudflare-wildcard{{.prefix}}.{{ .root }}.{{ .domain }}
  issuerRef:
    name: cloudflare
    kind: Issuer
  commonName: '*{{.prefix}}.{{ .root }}.{{ .domain }}'
  dnsNames:
    -   "*{{.prefix}}.{{ .root }}.{{ .domain }}"
{{ end }}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: cloudflare-wildcard.{{ .domain }}
spec:
  secretName: cloudflare-wildcard.{{ .domain }}
  issuerRef:
    name: cloudflare
    kind: Issuer
  commonName: '*.{{ .domain }}'
  dnsNames:
    -   "*.{{ .domain }}"
{{ end }}