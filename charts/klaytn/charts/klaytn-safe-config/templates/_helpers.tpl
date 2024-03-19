{{/*
Expand the name of the chart.
*/}}
{{- define "klaytn-safe-config.name" -}}
{{- default .Chart.Name .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
klaytn-safe-config service account
*/}}
{{- define "klaytn-safe-config.serviceAccountName" -}}
{{- default (include "klaytn-safe-config.name" .) .Values.serviceAccount.name }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "klaytn-safe-config.fullname" -}}
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
{{- define "klaytn-safe-config.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "klaytn-safe-config.labels" -}}
helm.sh/chart: {{ include "klaytn-safe-config.chart" . }}
{{ include "klaytn-safe-config.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "klaytn-safe-config.selectorLabels" -}}
app.kubernetes.io/name: {{ include "klaytn-safe-config.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
Define klaytn-safe-config web
*/}}
{{- define "klaytn-safe-config.web" }}
- name: PYTHONDONTWRITEBYTECODE
  value: {{ .Values.web.configuration.pythonDontWriteByteCode | quote }}
- name: DEBUG
  value: {{ .Values.web.configuration.debug | quote }}
- name: ROOT_LOG_LEVEL
  value: {{ .Values.web.configuration.rootLogLevel | quote }}
- name: DJANGO_ALLOWED_HOSTS
  value: {{ .Values.web.configuration.djangoAllowedHosts | quote }}
- name: FORCE_SCRIPT_NAME
  value: {{ .Values.web.configuration.forceScriptName | quote }}
- name: GUNICORN_BIND_PORT
  value: {{ .Values.web.configuration.gunicornBindPort | quote }}
- name: DEFAULT_FILE_STORAGE
  value: {{ .Values.web.configuration.defaultFileStorage | quote }}
- name: GUNICORN_WEB_RELOAD
  value: {{ .Values.web.configuration.gunicornWebReload | quote }}
- name: DOCKER_NGINX_VOLUME_ROOT
  value: {{ .Values.web.configuration.dockerNginxVolumeRoot | quote }}
- name: GUNICORN_BIND_SOCKET
  value: {{ .Values.web.configuration.gunicornBindSocket | quote }}
- name: DJANGO_SUPERUSER_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.web.configuration.secretName }}
      key: djangoSuperUserPassword
- name: DJANGO_SUPERUSER_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ .Values.web.configuration.secretName }}
      key: djangoSuperUserUserName
- name: DJANGO_SUPERUSER_EMAIL
  valueFrom:
    secretKeyRef:
      name: {{ .Values.web.configuration.secretName }}
      key: djangoSuperUserEmail
- name: DJANGO_OTP_ADMIN
  value: {{ .Values.web.configuration.djangoSuperAdmin.enable | quote }} 
- name: CSRF_TRUSTED_ORIGINS
  value: {{ .Values.web.configuration.csrfTrustedOrigins | quote }} 
- name: CGW_URL
  value: {{ .Values.web.configuration.configGatewayConfig.cgwUrl | quote }} 
- name: CGW_FLUSH_TOKEN
  valueFrom:
    secretKeyRef:
      name: {{ .Values.web.configuration.secretName }}
      key: cgwFlushToken
- name: POSTGRES_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.web.configuration.secretName }}
      key: postgresql-user
- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.web.configuration.secretName }}
      key: postgresql-password
- name: POSTGRES_HOST   
  value: "{{ default (printf "%s-postgresql.%s.svc.cluster.local" (include "klaytn-safe-config.name" .) .Release.Namespace ) .Values.web.configuration.externalDatabase.host }}" 
- name: SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ .Values.web.configuration.secretName }}
      key: secretKey
- name: POSTGRES_NAME
  value: {{ .Values.web.configuration.externalDatabase.database | quote }}
{{- end}}

{{/*
Healthcheck path
*/}}
{{- define "klaytn-safe-config.healthcheckPath" -}}
{{ .Values.web.configuration.forceScriptName }}{{ .Values.web.configuration.healthcheckPath }}
{{- end }}
