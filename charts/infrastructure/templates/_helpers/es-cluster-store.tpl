{{ define "es-cluster-store" -}}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: secret-manager-{{ .namespace }}
  namespace: {{ .namespace }}
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["list", "get"]
---
apiVersion: v1
automountServiceAccountToken: true
kind: ServiceAccount
metadata:
  name: secret-manager-{{ .namespace }}
  namespace: {{ .namespace }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: secret-manager-{{ .namespace }}
  namespace: {{ .namespace }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: secret-manager-{{ .namespace }}
subjects:
- kind: ServiceAccount
  name: secret-manager-{{ .namespace }}
  namespace: {{ .namespace }}

---
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: {{ .namespace }}
spec:
  provider:
    kubernetes:
      remoteNamespace: {{ .namespace }}
      server:
        caProvider:
          type: ConfigMap
          name: kube-root-ca.crt
          key: ca.crt
          namespace: {{ .namespace }}
      auth:
        serviceAccount:
          name: secret-manager-{{ .namespace }}
          namespace: {{ .namespace }}
{{ end }}