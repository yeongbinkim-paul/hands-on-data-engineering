{{- define "airflow_dags_folder" -}}
/opt/airflow/data-pipeline/dags
{{- end -}}

{{- define "git_sync_image" -}}
{{ printf "%s:%s" .Values.images.gitSync.repository .Values.images.gitSync.tag }}
{{- end -}}

{{- define "airflow_db_conn" -}}
{{ printf "postgresql+psycopg2://postgres:%s@postgresql-%s:5432/airflow" .Values.postgres.postgresPassword .Release.Namespace }}
{{- end -}}

{{- define "airflow_image" -}}
{{ printf "%s:%s" .Values.images.airflow.repository .Values.images.airflow.tag | quote }}
{{- end -}}

{{- define "pod_template_image" -}}
{{ printf "%s:%s" .Values.images.airflow.repository .Values.images.airflow.tag | quote }}
{{- end -}}

{{- define "airflow_liveness_probe_path" -}}
/health
{{- end -}}

{{- define "airflow_dags_mount" }}
- name: dags
  mountPath: {{ template "airflow_dags_folder" . }}
  readOnly: true
{{- end -}}

{{/* Standard Airflow environment variables */}}
{{- define "standard_airflow_environment" }}
  - name: AIRFLOW__CORE__FERNET_KEY
    valueFrom:
      secretKeyRef:
        name: {{ .Chart.Name }}-fernet-key-{{ .Values.env }}
        key: fernet-key
  - name: AIRFLOW__CORE__SQL_ALCHEMY_CONN
    value: {{ template "airflow_db_conn" . }}
  - name: AIRFLOW__DATABASE__SQL_ALCHEMY_CONN
    value: {{ template "airflow_db_conn" . }}
  - name: AIRFLOW_CONN_AIRFLOW_DB
    value: {{ template "airflow_db_conn" . }}
  - name: AIRFLOW__WEBSERVER__SECRET_KEY
    value: b46f1a10f3eed7a79540729f34a7da37
{{- end -}}

{{- define "extra_airflow_environment" }}
  {{ if eq .Values.env "test" }}
  - name: ENVIRONMENT
    value: "test"
  - name: IS_TEST
    value: "true"
  {{ else }}
  - name: ENVIRONMENT
    value: "production"
  - name: IS_TEST
    value: "false"
  {{ end }}
  - name: NAMESPACE
    value: {{ .Release.Namespace | quote }}
{{- end -}}
{{/*  Git ssh key volume */}}
{{- define "git_sync_ssh_key_volume" }}
- name: git-sync-secret
  secret:
    secretName: airflow-git-ssh-secret-{{ .Values.env }}
{{- end -}}

{{/*  Git sync container */}}
{{- define "git_sync_container" }}
- name: git-sync-container
  image: {{ template "git_sync_image" . }}
  imagePullPolicy: {{ .Values.images.gitSync.pullPolicy }}
  env:
    - name: GIT_SSH_KEY_FILE
      value: "/etc/git-secret/ssh"
    - name: GIT_SYNC_SSH
      value: "true"
    - name: GIT_KNOWN_HOSTS
      value: "true"
    - name: GIT_SSH_KNOWN_HOSTS_FILE
      value: "/etc/git-secret/known_hosts"
    - name: GIT_SYNC_REV
      value: {{ .Values.gitSync.rev | quote }}
    - name: GIT_SYNC_BRANCH
      value: {{ .Values.gitSync.branch | quote }}
    - name: GIT_SYNC_REPO
      value: {{ .Values.gitSync.repo | quote }}
    - name: GIT_SYNC_DEPTH
      value: {{ .Values.gitSync.depth | quote }}
    - name: GIT_SYNC_ROOT
      value: "/git"
    - name: GIT_SYNC_DEST
      value: "repo"
    - name: GIT_SYNC_ADD_USER
      value: "true"
    {{- range $i, $config := .Values.gitSync.env }}
    - name: {{ $config.name }}
      value: {{ $config.value | quote }}
    {{- end }}
  resources: {{ toYaml .Values.gitSync.resources | nindent 6 }}
  volumeMounts:
    - name: dags
      mountPath: /git
    - name: git-sync-secret
      mountPath: /etc/git-secret
      readOnly: true
{{- end -}}
