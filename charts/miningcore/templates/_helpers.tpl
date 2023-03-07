{{/*
Expand the name of the chart.
*/}}
{{- define "miningcore.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "miningcore.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create unified labels for miningcore components
*/}}
{{- define "miningcore.common.matchLabels" -}}
app: {{ template "miningcore.name" . }}
release: {{ .Release.Name }}
{{- end -}}

{{- define "miningcore.common.metaLabels" -}}
chart: {{ template "miningcore.chart" . }}
heritage: {{ .Release.Service }}
{{- end -}}

{{- define "miningcore.common.labels" -}}
{{ include "miningcore.common.matchLabels" . }}
{{ include "miningcore.common.metaLabels" . }}
{{- end -}}


{{- define "miningcore.stratum.labels" -}}
{{ include "miningcore.stratum.matchLabels" . }}
{{ include "miningcore.common.metaLabels" . }}
{{- end -}}

{{- define "miningcore.stratum.matchLabels" -}}
component: {{ .Values.stratum.name | quote }}
{{ include "miningcore.common.matchLabels" . }}
{{- end -}}

{{- define "miningcore.payout.labels" -}}
{{ include "miningcore.payout.matchLabels" . }}
{{ include "miningcore.common.metaLabels" . }}
{{- end -}}

{{- define "miningcore.payout.matchLabels" -}}
component: {{ .Values.payout.name | quote }}
{{ include "miningcore.common.matchLabels" . }}
{{- end -}}

{{- define "miningcore.stats.labels" -}}
{{ include "miningcore.stats.matchLabels" . }}
{{ include "miningcore.common.metaLabels" . }}
{{- end -}}

{{- define "miningcore.stats.matchLabels" -}}
component: {{ .Values.stats.name | quote }}
{{ include "miningcore.common.matchLabels" . }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "miningcore.fullname" -}}
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
Create a fully qualified stratum proxy name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "miningcore.stratum.fullname" -}}
{{- if .Values.stratum.fullnameOverride -}}
{{- .Values.stratum.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.stratum.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.stratum.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified payout manager name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "miningcore.payout.fullname" -}}
{{- if .Values.payout.fullnameOverride -}}
{{- .Values.payout.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.payout.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.payout.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified stats collector name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "miningcore.stats.fullname" -}}
{{- if .Values.stats.fullnameOverride -}}
{{- .Values.stats.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.stats.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.stats.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Merge global pool config with a possible stratum specific pool config.
*/}}
{{- define "miningcore.stratum.poolcfg" -}}
{{- $poolcfg := .Values.config.pool -}}
{{- if and .Values.stratum.config .Values.stratum.config.pool -}}
{{- $poolcfg = merge .Values.stratum.config.pool .Values.config.pool -}}
{{- end -}}
{{ $poolcfg | toJson }}
{{- end -}}

{{/*
Merge global pool config with a possible payout specific pool config.
*/}}
{{- define "miningcore.payout.poolcfg" -}}
{{- $poolcfg := .Values.config.pool -}}
{{- if and .Values.payout.config .Values.payout.config.pool -}}
{{- $poolcfg = merge .Values.payout.config.pool .Values.config.pool -}}
{{- end -}}
{{ $poolcfg | toJson }}
{{- end -}}

{{/*
Merge global pool config with a possible stats specific pool config.
*/}}
{{- define "miningcore.stats.poolcfg" -}}
{{- $poolcfg := .Values.config.pool -}}
{{- if and .Values.stats.config .Values.stats.config.pool -}}
{{- $poolcfg = merge .Values.stats.config.pool .Values.config.pool -}}
{{- end -}}
{{ $poolcfg | toJson }}
{{- end -}}


