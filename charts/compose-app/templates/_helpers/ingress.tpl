{{- define "homelab.ingress" }}

# 
# Input: = {{ . | toJson }}
#   prefix: str = {{ .prefix }}
#   service: str = {{ .service }}
#   namespace: str = {{ .namespace }}
#   global: map (should be .global) = {{ .global | toJson }}
#   port: int = 80 = {{ .port }}
#   path: str = "/" = {{ .path }}
#   useWildCard: bool = False = {{ .useWildCard }}
#   middleware: str = "https-redirect" = {{ .middleware }}
#   useSecondaryDomain: bool = False = {{ .useSecondaryDomain }}
#   useDirectPrefix: bool = False = {{ .useDirectPrefix }}
#   widget: bool = False = {{ .widget | toJson }}
#   


{{- $splitPrefix := splitList "." .prefix -}}
{{- $prefix := first $splitPrefix -}}
{{- $leadPrefix := join "." (rest $splitPrefix) -}}

{{- $_ := set . "prefix" $prefix -}}
{{- $_ := set . "leadPrefix" $leadPrefix -}}

{{- $domain := (include "homelab.ingress.domain" .) -}}

{{- $_ := set . "domain" $domain -}}

# .domain = {{ .domain }}
# .prefix = {{ .prefix }}
{{ if .global.dns.tls.enabled  }}
{{ include "homelab.ingress.domain.tls" . }}
{{ end }}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: "{{.prefix}}{{ $domain }}"
  namespace: {{ .namespace }}
  annotations:
    homelab-ingress/managing-app-namespace: "apps-ingresses"
    traefik.ingress.kubernetes.io/router.middlewares: {{ .middleware | default "ingress-https-redirect"}}@kubernetescrd
    gethomepage.dev/enabled: "true"
    gethomepage.dev/name: "{{.prefix}}@{{.namespace}}"
    gethomepage.dev/siteMonitor: 'http://{{.service}}.{{ .namespace }}.svc.cluster.local:{{.port | default 80}}{{ .path | default "/" }}{{ .health | default "" }}'
    {{ if .description}}
    gethomepage.dev/description: "{{ .description }}"
    {{ end }}
    gethomepage.dev/group: {{ .group | default "Unassigned" }}
    {{ if .icon }}
    gethomepage.dev/icon: "{{.icon}}"
    {{ else }}
    gethomepage.dev/icon: "homepage.png"
    {{ end }}
    {{ if .widget }}
    {{ range $k, $v := .widget }}
    gethomepage.dev/widget.{{$k}}: {{ $v | quote }}
    {{ end }}
    {{ end }}
  {{ range $k, $v := (.annotations | default (dict )) }}
    {{ $k }}: {{ $v }}
  {{ end }}
spec:
  rules:
  - host: "{{.prefix}}{{ $domain }}"
    http:
      paths:
      - backend:
          service:
            name: "{{.service}}"
            port:
              number: {{.port | default 80}}
        path: {{ .path | default "/" }}
        pathType: Prefix
  {{ if .global.dns.tls.enabled }}
  tls:
    - secretName: "tls-{{.prefix}}{{ $domain }}"
      hosts:
        - "{{.prefix}}{{ $domain }}"
  {{ end }}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: "{{.prefix}}.internal"
  namespace: {{ .namespace }}
  annotations:
    homelab-ingress/managing-app-namespace: "apps-ingresses"
    gethomepage.dev/enabled: "true"
    gethomepage.dev/name: "{{.prefix}}@{{.namespace}}"
    gethomepage.dev/siteMonitor: 'http://{{.service}}.{{ .namespace }}.svc.cluster.local:{{.port | default 80}}{{ .path | default "/" }}{{ .health | default "" }}'
    {{ if .description}}
    gethomepage.dev/description: "{{ .description }}"
    {{ end }}
    gethomepage.dev/group: Internal({{ .group | default "Unassigned" }})
    {{ if .icon }}
    gethomepage.dev/icon: "{{.icon}}"
    {{ else }}
    gethomepage.dev/icon: "homepage.png"
    {{ end }}
    {{ if .widget }}
    {{- range $k, $v := .widget }}
    gethomepage.dev/widget.{{$k}}: {{ $v | quote }}
    {{- end }}
    {{ end }}
  {{ range $k, $v := (.annotations | default (dict )) }}
    {{ $k }}: {{ $v }}
  {{ end }}
spec:
  rules:
  - host: "{{.prefix}}.{{ .global.dns.internalPrefix }}"
    http:
      paths:
      - backend:
          service:
            name: "{{.service}}"
            port:
              number: {{.port | default 80}}
        path: {{ .path | default "/" }}
        pathType: Prefix
{{- end -}}