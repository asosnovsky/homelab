{{ define "homelab.ingress.tailscale" }}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
    name: tailscale-{{.name}}
    namespace: {{ .namespace }}
spec:
  ingressClassName: tailscale
  tls:
    - hosts:
        - {{ .name }}
  rules:
    - http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: tailscale-{{.name}}
                port:
                  number: 80
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