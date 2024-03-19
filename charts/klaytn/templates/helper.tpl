{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "klaytn-safe-admin.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
