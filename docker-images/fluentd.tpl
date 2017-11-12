{{range .configList}}
<source>
  @type tail
  tag docker.{{ $.containerId }}.{{ .Name }}
  path {{ .HostDir }}/{{ .File }}
  format {{ .Format }}

{{if .FormatConfig}}
{{range $key, $value := .FormatConfig}}
{{ $key }} {{ $value }}
{{end}}
{{end}}
  pos_file /pilot/pos/fluentd.{{ $.containerId }}.pos
  refresh_interval 1
</source>

{{if .LogKey}}
<filter docker.{{ $.containerId }}.{{ .Name }}>
@type json_log
time_key {{ .TimeKey}}
</filter>
{{else}}
<filter docker.{{ $.containerId }}.{{ .Name }}>
@type add_time
time_key {{ .TimeKey}}
</filter>
{{end}}

<filter docker.{{ $.containerId }}.{{ .Name }}>
@type record_transformer
<record>
host "#{Socket.gethostname}"
{{range $key, $value := .Tags}}
{{ $key }} {{ $value }}
{{end}}

@target {{if .Target}}{{.Target}}{{else}}{{ .Name }}{{end}}

{{range $key, $value := $.container}}
{{ $key }} {{ $value }}
{{end}}

</record>
</filter>
{{end}}
