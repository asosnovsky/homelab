{{ define "homelab.ingress.tailscale" }}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
    name: tailscale-{{.name}}
    namespace: {{ .namespace }}
spec:
  ingressClassName: tailscale
  defaultBackend:
    service:
      name: tailscale-{{.name}}
      port:
        name: main
---
apiVersion: v1
kind: Service
metadata:
    name: tailscale-{{.name}}
    namespace: {{ .namespace }}
spec:
  type: ClusterIP
  ports:
    - name: main
      port: 80
      targetPort: {{.port | default 80}}
  selector:
    {{ .selector | toYaml | nindent 4 }}
{{ end }}