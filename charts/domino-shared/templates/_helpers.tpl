{{- /*
Create a secret for accessing a private container image registry.
*/ -}}
{{- define "imagePullSecret" }}
{{- with .Values.image.imageCredentials }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

{{- /*
Common labels.
*/ -}}
{{- define "common.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: "1.0"
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}