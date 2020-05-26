{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "apps-generic-chart.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "apps-generic-chart.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "apps-generic-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Function to create hostname
*/}}

{{- define "apps-generic-chart.hostname" -}}
{{- $name :=  .Root.Release.Name | replace "+" "-" | replace "." "-" | trunc 63 | trimSuffix "-" -}}
{{- if (ne .Root.Values.hostNameOverride "") -}}
{{- $name = .Root.Values.hostNameOverride }}
{{- end -}}
{{- if (eq .Ingress.host "") -}}
{{- if .Ingress.suffix -}}
{{- printf "%s-%s-%s.%s" $name .Root.Release.Namespace .Suffix .Ingress.clusterFqdn -}}
{{- else -}}
{{- printf "%s-%s.%s" $name .Root.Release.Namespace .Ingress.clusterFqdn -}}
{{- end -}}
{{- end -}}
{{- end -}}
