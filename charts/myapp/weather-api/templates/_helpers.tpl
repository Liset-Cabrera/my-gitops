{{- define "myapp.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "myapp.fullname" -}}
{{ include "myapp.name" . }}
{{- end }}
