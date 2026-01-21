{{- define "myapp.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{- define "myapp.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride -}}
{{- else -}}
{{- printf "%s-%s" (include "myapp.name" .) .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}


{{- define "myapp.configmapName" -}}
{{- include "myapp.fullname" . -}}-config
{{- end -}}

{{- define "myapp.apiEndpoint" -}}
/weather/hello
{{- end -}}