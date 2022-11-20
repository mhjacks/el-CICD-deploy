# SPDX-License-Identifier: LGPL-2.1-or-later

{{- define "elCicdRenderer.render" }}
  {{- $ := . }}

  {{- include "elCicdRenderer.initElCicdRenderer" . }}

  {{- include "elCicdRenderer.mergeProfileDefs" (list $ $.Values $.Values.elCicdDefs) }}

  {{- include "elCicdRenderer.generateAllTemplates" . }}

  {{- include "elCicdRenderer.processTemplates" (list $ $.Values.allTemplates $.Values.elCicdDefs) }}

  {{- include "elCicdRenderer.createNamespaces" . }}

  {{- $skippedList := list }}
  {{- range $template := $.Values.allTemplates  }}
    {{- $templateName := $template.templateName }}
    {{- if not (contains "." $templateName) }}
      {{- $templateName = printf "%s.%s" $.Values.defaultRenderChart $template.templateName }}
    {{- end }}
---
    {{- include $templateName (list $ $template) }}
# Rendered -> {{ $template.templateName }} {{ $template.appName }}
  {{- end }}

  {{- range $yamlMapKey, $rawYamlValue := $.Values }}
    {{- if and (hasPrefix "elCicdRawYaml" $yamlMapKey) (kindIs "map" $rawYamlValue) }}
      {{- range $yamlKey, $rawYaml := $rawYamlValue }}
---
        {{- $rawYaml | toYaml }}
# Rendered From {{ $yamlMapKey }} -> {{ $yamlKey }}
      {{- end }}
    {{- end }}
  {{- end }}

  {{- if $.Values.renderValuesForKust }}
---
# __VALUES_START__
{{ $.Values | toYaml }}
# __VALUES_END__
  {{- end }}
---
# Profiles: {{ $.Values.profiles }}
  {{- range $skippedTemplate := $.Values.skippedTemplates }}
    {{- include "elCicdRenderer.skippedTemplateLog" $skippedTemplate }}
  {{- end }}
{{- end }}
