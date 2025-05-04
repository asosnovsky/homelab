{{ define "homelab.ingress.tailscale" }}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tailscale-{{.name}}
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
spec:
  type: ClusterIP
  ports:
    - name: main
      port: 80
      targetPort: {{.port}}
{{ end }}