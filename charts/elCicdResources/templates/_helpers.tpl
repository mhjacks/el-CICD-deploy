{{/*
General Metadata Template
*/}}
{{- define "elCicdChart.apiObjectHeader" }}
{{- $ := index . 0 }}
{{- $template := index . 1 }}
apiVersion: {{ $template.apiVersion }}
kind: {{ $template.kind }}
{{- include "elCicdChart.apiMetadata" . }}
{{- end }}

{{- define "elCicdChart.apiMetadata" }}
{{- $ := index . 0 }}
{{- $metadataValues := index . 1 }}
metadata:
  {{- if or $metadataValues.annotations $.Values.defaultAnnotations }}
  annotations:
    {{- if $metadataValues.annotations }}
      {{- range $key, $value := $metadataValues.annotations }}
    {{ $key }}: "{{ $value }}"
      {{- end }}
    {{- end }}
    {{- if $.Values.defaultAnnotations}}
      {{- $.Values.defaultAnnotations | toYaml | nindent 4 }}
    {{- end }}
  {{- end }}
  labels:
    {{- include "elCicdChart.labels" . | indent 4 }}
    {{- range $key, $value := $metadataValues.labels }}
    {{ $key }}: "{{ $value }}"
    {{- end }}
    {{- range $key, $value := $.Values.labels }}
    {{ $key }}: "{{ $value }}"
    {{- end }}
    {{- range $key, $value := $.Values.defaultLabels }}
    {{ $key }}: "{{ $value }}"
    {{- end }}
  name: {{ required "Unnamed apiObject Name!" $metadataValues.appName }}
  namespace: {{ $.Values.namespace | default $.Release.Namespace}}
{{- end }}

{{/*
el-CICD Selector
*/}}
{{- define "elCicdChart.selector" }}
{{- $ := index . 0 }}
{{- $template := index . 1 }}
matchExpressions:
- key: app
  operator: Exists
{{- if $template.matchExpressions }}
  {{- $template.matchExpressions | toYaml }}
{{- end }}
matchLabels:
  {{- include "elCicdChart.selectorLabels" . | indent 2 }}
{{- if $template.matchLabels }}
  {{- $template.matchLabels | toYaml | indent 2 }}
{{- end }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "elCicdChart.name" -}}
{{- default $.Chart.Name $.Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "elCicdChart.chart" -}}
{{- printf "%s-%s" $.Chart.Name $.Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "elCicdChart.labels" -}}
{{- $ := index . 0 }}
{{- $template := index . 1 }}
{{- include "elCicdChart.selectorLabels" . }}
helm.sh/chart: {{ include "elCicdChart.chart" $ }}
{{- if $.Chart.AppVersion }}
app.kubernetes.io/version: {{ $.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ $.Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "elCicdChart.selectorLabels" -}}
{{- $ := index . 0 }}
{{- $template := index . 1 }}
app: {{ $template.appName }}
{{- end }}

{{/*
Scale3 Annotations
*/}}
{{- define "elCicdChart.scale3Annotations" -}}
discovery.3scale.net/path: {{ .threeScale.path }}
discovery.3scale.net/port: {{ .threeScale.port }}
discovery.3scale.net/scheme: {{ .threeScale.scheme }}
{{- end }}

{{/*
Scale3 Labels
*/}}
{{- define "elCicdChart.scale3Labels" -}}
discovery.3scale.net: {{ .threeScale.scheme }}
{{- end }}