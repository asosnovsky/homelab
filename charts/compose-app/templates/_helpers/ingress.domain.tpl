{{- define "homelab.ingress.domain" -}}
  {{- $rootPrefix := empty .leadPrefix | ternary "" (printf "%s." .leadPrefix) -}}
  {{- if .useSecondaryDomain -}}
{{$rootPrefix}}{{.global.dns.secondary.root}}.{{.global.dns.secondary.domain}}
  {{- else -}}
    {{- if .useDirectPrefix -}}
{{$rootPrefix}}{{.global.dns.primary.domain}}
    {{- else -}}
{{$rootPrefix}}{{.global.dns.primary.root}}.{{.global.dns.primary.domain}}
    {{- end -}}
  {{- end -}}
{{- end -}}