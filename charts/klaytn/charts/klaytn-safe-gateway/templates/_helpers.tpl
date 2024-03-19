{{/*
Expand the name of the chart.
*/}}
{{- define "klaytn-safe-gateway.name" -}}
{{- default .Chart.Name .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
klaytn-safe-gateway service account
*/}}
{{- define "klaytn-safe-gateway.serviceAccountName" -}}
{{- default (include "klaytn-safe-gateway.name" .) .Values.serviceAccount.name }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "klaytn-safe-gateway.fullname" -}}
{{- $name := default .Chart.Name }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "klaytn-safe-gateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "klaytn-safe-gateway.labels" -}}
helm.sh/chart: {{ include "klaytn-safe-gateway.chart" . }}
{{ include "klaytn-safe-gateway.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "klaytn-safe-gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "klaytn-safe-gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
Define klaytn-safe-gateway web
*/}}
{{- define "klaytn-safe-gateway.web" }}
- name: CONFIG_SERVICE_URI
  value: "http://{{ default (printf "klaytn-safe-config-web.%s.svc.cluster.local" .Release.Namespace ) .Values.web.configuration.configServiceUri }}/cfg" 
- name: FEATURE_FLAG_NESTED_DECODING
  value: {{ .Values.web.configuration.featureFlagNestedDecoding | quote }}
- name: ROCKET_LOG_LEVEL
  value: {{ .Values.web.configuration.rocketLogLevel | quote }}
- name: ROCKET_PORT
  value: {{ .Values.web.configuration.rocketPort | quote }}
- name: ROCKET_ADDRESS
  value: {{ .Values.web.configuration.rocketAddress | quote }}
- name: SCHEME
  value: {{ .Values.web.configuration.scheme | quote }}
- name: RUST_LOG
  value: {{ .Values.web.configuration.rustLog | quote }}
- name: LOG_ALL_ERROR_RESPONSES
  value: {{ .Values.web.configuration.logAllErrorResponses | quote }}
- name: INTERNAL_CLIENT_CONNECT_TIMEOUT
  value: {{ .Values.web.configuration.internalClientConnectTimeout | quote }}
- name: SAFE_APP_INFO_REQUEST_TIMEOUT
  value: {{ .Values.web.configuration.safeAppInfoRequestTimeout | quote }}
- name: CHAIN_INFO_REQUEST_TIMEOUT
  value: {{ .Values.web.configuration.chainInfoRequestTimeout | quote }}
- name: REDIS_URI_MAINNET
  value: {{ default (printf "redis://%s-redis-master.%s.svc.cluster.local" ( include "klaytn-safe-gateway.name" .) .Release.Namespace ) .Values.web.configuration.redisUriMainnet | quote }}
- name: REDIS_URI
  value: {{ default (printf "redis://%s-redis-master.%s.svc.cluster.local" ( include "klaytn-safe-gateway.name" .) .Release.Namespace ) .Values.web.configuration.redisUri | quote }}
- name: EXCHANGE_API_BASE_URI
  value: {{ .Values.web.configuration.exchangeApiBaseUri | quote }}
- name: ROCKET_SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ .Values.web.configuration.secretName }}
      key: rocketSecretKey
- name: WEBHOOK_TOKEN
  valueFrom:
    secretKeyRef:
      name: {{ .Values.web.configuration.secretName }}
      key: webhookToken
- name: EXCHANGE_API_KEY
  valueFrom:
    secretKeyRef:
      name: {{ .Values.web.configuration.secretName }}
      key: exchangeApiKey
{{- end}}

{{/*
Healthcheck path
*/}}
{{- define "klaytn-safe-gateway.healthcheckPath" -}}
{{ .Values.web.configuration.forceScriptName }}{{ .Values.web.configuration.healthcheckPath }}
{{- end }}
