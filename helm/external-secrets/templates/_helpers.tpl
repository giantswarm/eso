{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "external-secrets.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "external-secrets.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Define namespace of chart, useful for multi-namespace deployments
*/}}
{{- define "external-secrets.namespace" -}}
{{- if .Values.namespaceOverride }}
{{- .Values.namespaceOverride }}
{{- else }}
{{- .Release.Namespace }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "external-secrets.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "external-secrets.labels" -}}
helm.sh/chart: {{ include "external-secrets.chart" . }}
{{ include "external-secrets.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
application.giantswarm.io/team: {{ index .Chart.Annotations "application.giantswarm.io/team" | quote }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{- define "external-secrets-webhook.labels" -}}
helm.sh/chart: {{ include "external-secrets.chart" . }}
{{ include "external-secrets-webhook.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{- define "external-secrets-webhook-metrics.labels" -}}
{{ include "external-secrets-webhook.selectorLabels" . }}
app.kubernetes.io/metrics: "webhook"
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{- define "external-secrets-cert-controller.labels" -}}
helm.sh/chart: {{ include "external-secrets.chart" . }}
{{ include "external-secrets-cert-controller.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{- define "external-secrets-cert-controller-metrics.labels" -}}
{{ include "external-secrets-cert-controller.selectorLabels" . }}
app.kubernetes.io/metrics: "cert-controller"
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "common.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
{{- define "external-secrets.selectorLabels" -}}
app.kubernetes.io/name: {{ include "external-secrets.name" . }}
{{ include "common.selectorLabels" . }}
{{- end }}
{{- define "external-secrets-webhook.selectorLabels" -}}
app.kubernetes.io/name: {{ include "external-secrets.name" . }}-webhook
{{ include "common.selectorLabels" . }}
{{- end }}
{{- define "external-secrets-cert-controller.selectorLabels" -}}
app.kubernetes.io/name: {{ include "external-secrets.name" . }}-cert-controller
{{ include "common.selectorLabels" . }}
{{- end }}
{{/*
Create the name of the service account to use
*/}}
{{- define "external-secrets.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "external-secrets.name" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "external-secrets-webhook.serviceAccountName" -}}
{{- if .Values.webhook.serviceAccount.create }}
{{- default "external-secrets-webhook" .Values.webhook.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.webhook.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "external-secrets-cert-controller.serviceAccountName" -}}
{{- if .Values.certController.serviceAccount.create }}
{{- default "external-secrets-cert-controller" .Values.certController.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.certController.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "crdInstall" -}}
{{- printf "%s-%s" ( include "external-secrets.name" . ) "crd-install" | replace "+" "_" | trimSuffix "-" -}}
{{- end -}}

{{- define "crdInstallJob" -}}
{{- printf "%s-%s-%s" ( include "external-secrets.name" . ) "crd-install" .Chart.AppVersion | replace "+" "_" | replace "." "-" | trimSuffix "-" | trunc 63 -}}
{{- end -}}

{{- define "crdInstallAnnotations" -}}
"helm.sh/hook": "pre-install,pre-upgrade"
"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded,hook-failed"
{{- end -}}

{{/* Create a label which can be used to select any orphaned crd-install hook resources */}}
{{- define "crdInstallSelector" -}}
{{- printf "%s" "crd-install-hook" -}}
{{- end -}}

{{/* Usage:
    {{ include "controllerVolumeName" (merge (dict "volumeName" "hello") .) | quote }}
*/}}
<<<<<<< HEAD
{{- define "controllerVolumeName" -}}
{{- printf "%s-controller-%s-volume" (include "name" .) .volumeName -}}
{{- end -}}

{{- define "resource.vpa.enabled" -}}
{{- if and (or (.Capabilities.APIVersions.Has "autoscaling.k8s.io/v1") (.Values.giantswarm.verticalPodAutoscaler.force)) (.Values.giantswarm.verticalPodAutoscaler.enabled) }}true{{ else }}false{{ end }}
{{- end -}}

{{- define "resource.externalSecrets.resources" -}}
requests:
{{ toYaml .Values.giantswarm.resources.externalSecrets.requests | indent 2 -}}
{{ if eq (include "resource.vpa.enabled" .) "false" }}
limits:
{{ toYaml .Values.giantswarm.resources.externalSecrets.limits | indent 2 -}}
{{- end -}}
{{- end -}}

{{- define "resource.certController.resources" -}}
requests:
{{ toYaml .Values.giantswarm.resources.certController.requests | indent 2 -}}
{{ if eq (include "resource.vpa.enabled" .) "false" }}
limits:
{{ toYaml .Values.giantswarm.resources.certController.limits | indent 2 -}}
{{- end -}}
{{- end -}}

{{- define "resource.webhook.resources" -}}
requests:
{{ toYaml .Values.giantswarm.resources.webhook.requests | indent 2 -}}
{{ if eq (include "resource.vpa.enabled" .) "false" }}
limits:
{{ toYaml .Values.giantswarm.resources.webhook.limits | indent 2 -}}
{{- end -}}
=======
{{- define "external-secrets.image" -}}
{{- if .image.flavour -}}
{{ printf "%s:%s-%s" .image.repository (.image.tag | default .chartAppVersion) .image.flavour }}
{{- else }}
{{ printf "%s:%s" .image.repository (.image.tag | default .chartAppVersion) }}
{{- end }}
{{- end }}

{{/*
Renders a complete tree, even values that contains template.
*/}}
{{- define "external-secrets.render" -}}
  {{- if typeIs "string" .value }}
    {{- tpl .value .context }}
  {{ else }}
    {{- tpl (.value | toYaml) .context }}
  {{- end }}
{{- end -}}

{{/*
Return true if the OpenShift is the detected platform
Usage:
{{- include "external-secrets.isOpenShift" . -}}
*/}}
{{- define "external-secrets.isOpenShift" -}}
{{- if .Capabilities.APIVersions.Has "security.openshift.io/v1" -}}
{{- true -}}
{{- end -}}
{{- end -}}

{{/*
Render the securityContext based on the provided securityContext
  {{- include "external-secrets.renderSecurityContext" (dict "securityContext" .Values.securityContext "context" $) -}}
*/}}
{{- define "external-secrets.renderSecurityContext" -}}
{{- $adaptedContext := .securityContext -}}
{{- if .context.Values.global.compatibility -}}
  {{- if .context.Values.global.compatibility.openshift -}}
    {{- if or (eq .context.Values.global.compatibility.openshift.adaptSecurityContext "force") (and (eq .context.Values.global.compatibility.openshift.adaptSecurityContext "auto") (include "external-secrets.isOpenShift" .context)) -}}
      {{/* Remove OpenShift managed fields */}}
      {{- $adaptedContext = omit $adaptedContext "fsGroup" "runAsUser" "runAsGroup" -}}
      {{- if not .securityContext.seLinuxOptions -}}
        {{- $adaptedContext = omit $adaptedContext "seLinuxOptions" -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- omit $adaptedContext "enabled" | toYaml -}}
>>>>>>> dd64dc8a6aa747a1c1ad375c7f76a295fd73dfd5
{{- end -}}
