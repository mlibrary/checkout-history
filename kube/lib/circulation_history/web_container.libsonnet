(import './config_map.libsonnet') +
{
  local config = $._config.circulation_history,
  local images = $._images.circulation_history,
  local container = $.core.v1.container,
  local envVar = $.core.v1.envVar,

  local configMap = $.core.v1.configMap,
  configMap: configMap.new("circulation-history-config") +
             configMap.withData($.configMapData),

  circulation_history_container::  
    container.new(
        config.repoName, 
        images.web
        ) + 
      container.withEnvFrom( {configMapRef: { name: 'circulation-history-config'}} ) +
      container.withEnvMixin([           

          envVar.withName("SECRET_KEY_BASE") +
          envVar.valueFrom.secretKeyRef.withName("rails-secret-key-base") +
          envVar.valueFrom.secretKeyRef.withKey("SECRET_KEY_BASE"),

          envVar.withName("ALMA_API_KEY") +
          envVar.valueFrom.secretKeyRef.withName("credentials") +
          envVar.valueFrom.secretKeyRef.withKey("ALMA_API_KEY"),

          envVar.withName("CIRCULATION_HISTORY_DATABASE_PASSWORD") +
            envVar.valueFrom.secretKeyRef.withName(config.db.name) +
            envVar.valueFrom.secretKeyRef.withKey("CIRCULATION_HISTORY_DATABASE_PASSWORD"),

          envVar.withName("MYSQL_ROOT_PASSWORD") +
            envVar.valueFrom.secretKeyRef.withName(config.db.name + "-root") +
            envVar.valueFrom.secretKeyRef.withKey("MYSQL_ROOT_PASSWORD"),
          ])
  
}
