{{- /*
Common labels
*/ -}}
{{- define "common.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.image.tag }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "domino.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
  {{- default .Chart.Name .Values.serviceAccount.name }}
{{- else -}}
  {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}