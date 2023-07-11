{{- define "airflow_db_conn" -}}
{{ printf "postgresql://postgres:%s@postgresql-%s:5432/postgres?sslmode=disable" .Values.postgres.postgresPassword .Release.Namespace }}
{{- end -}}

{{- define "airflow_image" -}}
{{ printf "%s:%s" .Values.images.airflow.repository .Values.images.airflow.tag }}
{{- end -}}

{{- define "redis_image" -}}
{{ printf "%s:%s" .Values.images.redis.repository .Values.images.redis.tag }}
{{- end -}}

{{- define "postgres_image" -}}
{{ printf "%s:%s" .Values.images.postgres.repository .Values.images.postgres.tag }}
{{- end -}}

{{- define "statsd_image" -}}
{{ printf "%s:%s" .Values.images.statsd.repository .Values.images.statsd.tag }}
{{- end -}}

{{- define "airflow_liveness_probe_path" -}}
/health
{{- end -}}

{{/* Standard Airflow environment variables */}}
{{- define "standard_airflow_environment" }}
  - name: AIRFLOW__CORE__FERNET_KEY
    valueFrom:
      secretKeyRef:
        name: fernet-key
        key: fernet-key
  - name: AIRFLOW__CORE__SQL_ALCHEMY_CONN
    valueFrom:
      secretKeyRef:
        name: airflow-metadata
        key: connection
  - name: AIRFLOW__DATABASE__SQL_ALCHEMY_CONN
    valueFrom:
      secretKeyRef:
        name: airflow-metadata
        key: connection
  - name: AIRFLOW_CONN_AIRFLOW_DB
    valueFrom:
      secretKeyRef:
        name: airflow-metadata
        key: connection
  - name: AIRFLOW__WEBSERVER__SECRET_KEY
    valueFrom:
      secretKeyRef:
        name: webserver-key
        key: webserver-key
  - name: AIRFLOW__CELERY__BROKER_URL
    valueFrom:
      secretKeyRef:
        name: broker-url
        key: connection
{{- end -}}
