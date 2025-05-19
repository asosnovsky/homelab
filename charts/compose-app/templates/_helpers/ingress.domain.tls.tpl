{{ define "homelab.ingress.domain.tls"}}
{{ if (.useWildCard | default .global.dns.tls.useWildCard) }}
---
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: "tls-{{.prefix}}{{ .domain }}"
  namespace: {{ .namespace }}
spec:
  refreshInterval: 1h
  secretStoreRef:
    kind: ClusterSecretStore
    name: k8s-ns-certs
  target:
    name: tls-{{.prefix}}{{ .domain }}
    creationPolicy: Owner
    deletionPolicy: Delete
  data:
    - secretKey: tls.crt
      remoteRef:
        key: cloudflare-wildcard{{ .domain }}
        property: tls.crt
    - secretKey: tls.key
      remoteRef:
        key: cloudflare-wildcard{{ .domain }}
        property: tls.key
{{ else }}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: "tls-{{.prefix}}{{ .domain }}"
  namespace: {{ .namespace }}
spec:
  secretName: "tls-{{.prefix}}{{ .domain }}"
  issuerRef: 
    kind: ClusterIssuer
    name: "{{ .global.dns.tls.issuer }}"
  commonName: "{{.prefix}}{{ .domain }}"
  dnsNames:
    - "{{.prefix}}{{ .domain }}"
{{ end }}
{{ end }}