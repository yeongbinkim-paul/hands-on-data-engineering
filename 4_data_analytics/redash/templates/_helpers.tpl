{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "redash.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "redash.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 43 chars because some Kubernetes name fields are limited to 64 (by the DNS naming spec),
and we use this as a base for component names (which can add up to 20 chars).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "redash.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 43 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 43 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 43 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified adhocWorker name.
*/}}
{{- define "redash.adhocWorker.fullname" -}}
{{- template "redash.fullname" . -}}-adhocworker
{{- end -}}

{{/*
Create a default fully qualified scheduledworker name.
*/}}
{{- define "redash.scheduledWorker.fullname" -}}
{{- template "redash.fullname" . -}}-scheduledworker
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
*/}}
{{- define "redash.postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified redis name.
*/}}
{{- define "redash.redis.fullname" -}}
{{- printf "%s-%s" .Release.Name "redis-master" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the secret name.
*/}}
{{- define "redash.secretName" -}}
    {{- printf "%s" (include "redash.fullname" .) -}}
{{- end -}}

{{/*
Shared environment block used across each component.
*/}}
{{- define "redash.env" -}}
- name: REDASH_SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "redash.secretName" . }}
      key: secretKey
- name: REDASH_COOKIE_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ include "redash.secretName" . }}
      key: cookieSecret
- name: REDASH_DATABASE_URL
  value: {{ default "" .Values.externalPostgreSQL | quote }}
- name: REDASH_REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-redis
      key: redis-password
- name: REDASH_REDIS_HOSTNAME
  value: {{ include "redash.redis.fullname" . }}
- name: REDASH_REDIS_PORT
  value: "{{ .Values.redis.master.port }}"
- name: REDASH_REDIS_DB
  value: "{{ .Values.redis.databaseNumber }}"
{{- end -}}

{{/*
Common labels
*/}}
{{- define "redash.labels" -}}
helm.sh/chart: {{ include "redash.chart" . }}
{{ include "redash.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "redash.selectorLabels" -}}
app.kubernetes.io/name: {{ include "redash.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "redash.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "redash.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
