{{/*
Expand the name of the chart.
*/}}
{{- define "klaytn-safe-txn.name" -}}
{{- default .Chart.Name .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
klaytn-safe-txn service account
*/}}
{{- define "klaytn-safe-txn.serviceAccountName" -}}
{{- default (include "klaytn-safe-txn.name" .) .Values.serviceAccount.name }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "klaytn-safe-txn.fullname" -}}
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
{{- define "klaytn-safe-txn.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "klaytn-safe-txn.labels" -}}
helm.sh/chart: {{ include "klaytn-safe-txn.chart" . }}
{{ include "klaytn-safe-txn.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "klaytn-safe-txn.selectorLabels" -}}
app.kubernetes.io/name: {{ include "klaytn-safe-txn.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
Define klaytn-safe-txn web
*/}}
{{- define "klaytn-safe-txn.web" }}
- name: PYTHONPATH
  value: {{ .Values.web.configuration.pythonPath | quote }}
- name: DJANGO_SETTINGS_MODULE
  value: {{ .Values.web.configuration.djangoSettingsModule | quote }}
- name: DEBUG
  value: {{ .Values.web.configuration.debug | quote }}
- name: ETH_L2_NETWORK
  value: {{ .Values.web.configuration.ethL2Network | quote }}
- name: REDIS_URL
  value: {{ default (printf "redis://%s-redis-master.%s.svc.cluster.local" ( include "klaytn-safe-txn.name" .) .Release.Namespace ) .Values.web.configuration.redisUrl | quote }}
- name: FORCE_SCRIPT_NAME
  value: {{ .Values.web.configuration.forceScriptName | quote }}
- name: CSRF_TRUSTED_ORIGINS
  value: {{ .Values.web.configuration.csrfTrustedOrigins | quote }}
- name: ETHEREUM_NODE_URL
  value: {{ .Values.web.configuration.ethNodeUrl | quote }}
- name: DJANGO_SECRET_KEY
  valueFrom: 
    secretKeyRef:
      name: {{ .Values.web.configuration.secretName }}
      key: djangoSecretKey
- name: POSTGRESQL_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.web.configuration.secretName }}
      key: postgresql-user
- name: POSTGRESQL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.web.configuration.secretName }}
      key: postgresql-password
- name: DATABASE_URL   
  value: "psql://$(POSTGRESQL_USER):$(POSTGRESQL_PASSWORD)@{{ default (printf "%s-postgresql.%s.svc.cluster.local" (include "klaytn-safe-txn.name" .) .Release.Namespace ) .Values.web.configuration.externalDatabase.host }}:5432/{{ .Values.web.configuration.externalDatabase.database}}" 
- name: RABBITMQ_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.web.configuration.secretName }}
      key: rabbitmq-user
- name: RABBITMQ_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.web.configuration.secretName }}
      key: rabbitmq-password
- name: CELERY_BROKER_URL
  value: "amqp://$(RABBITMQ_USER):$(RABBITMQ_PASSWORD)@{{ default (printf "%s-rabbitmq.%s.svc.cluster.local" (include "klaytn-safe-txn.name" .) .Release.Namespace ) .Values.web.configuration.externalRabbitMQ.host }}/" 
{{- end}}

{{/*
Define klaytn-safe-txn indexer worker env
*/}}
{{- define "klaytn-safe-txn.indexerWorker" }}
{{ include "klaytn-safe-txn.web" .}}
- name: RUN_MIGRATIONS
  value: {{ .Values.indexerWorker.configuration.runMigrations | quote }}
- name: WORKER_QUEUES
  value: {{ .Values.indexerWorker.configuration.workerQueues | quote }}
{{- end -}}

{{/*
Define klaytn-safe-txn constracts token worker env
*/}}
{{- define "klaytn-safe-txn.constractsTokenWorker" }}
{{ include "klaytn-safe-txn.web" .}}
- name: RUN_MIGRATIONS
  value: {{ .Values.contractsTokensWorker.configuration.runMigrations | quote }}
- name: WORKER_QUEUES
  value: {{ .Values.contractsTokensWorker.configuration.workerQueues | quote }}
{{- end -}}

{{/*
Define klaytn-safe-txn notifications webhooks worker env
*/}}
{{- define "klaytn-safe-txn.notificationsWebhooksWorker" }}
{{ include "klaytn-safe-txn.web" .}}
- name: RUN_MIGRATIONS
  value: {{ .Values.notificationsWebhooksWorker.configuration.runMigrations | quote }}
- name: WORKER_QUEUES
  value: {{ .Values.notificationsWebhooksWorker.configuration.workerQueues | quote }}
{{- end -}}

{{/*
Define klaytn-safe-txn scheduler env
*/}}
{{- define "klaytn-safe-txn.scheduler" }}
{{ include "klaytn-safe-txn.web" .}}
- name: RUN_MIGRATIONS
  value: {{ .Values.scheduler.configuration.runMigrations | quote }}
- name: WORKER_QUEUES
  value: {{ .Values.scheduler.configuration.workerQueues | quote }}
{{- end -}}

{{/*
Define klaytn-safe-txn flower env
*/}}
{{- define "klaytn-safe-txn.flower" }}
{{ include "klaytn-safe-txn.web" .}}
- name: RUN_MIGRATIONS
  value: {{ .Values.flower.configuration.runMigrations | quote }}
- name: WORKER_QUEUES
  value: {{ .Values.flower.configuration.workerQueues | quote }}
{{- end -}}

{{/*
Healthcheck path
*/}}
{{- define "klaytn-safe-txn.healthcheckPath" -}}
{{ .Values.web.configuration.forceScriptName }}{{ .Values.web.configuration.healthcheckPath }}
{{- end }}
