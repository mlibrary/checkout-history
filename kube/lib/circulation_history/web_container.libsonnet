{
  local config = $._config.circulation_history,
  local images = $._images.circulation_history,
  local container = $.core.v1.container,
  local envVar = $.core.v1.envVar,

  circulation_history_container::  
    container.new(
        config.repoName, 
        images.web
        ) + 
      container.withEnvMixin([           
          envVar.withName("RAILS_ENV") +
          envVar.withValue("production"),

          envVar.withName("CIRC_REPORT_PATH") +
          envVar.withValue("/shared/University of Michigan 01UMICH_INST/Reports/apps/circ-history/circ-history"),

          envVar.withName("PATRON_REPORT_PATH") +
          envVar.withValue("/shared/University of Michigan 01UMICH_INST/Reports/apps/circ-history/non-expired-patrons"),

          envVar.withName("SECRET_KEY_BASE") +
          envVar.valueFrom.secretKeyRef.withName("rails-secret-key-base") +
          envVar.valueFrom.secretKeyRef.withKey("SECRET_KEY_BASE"),

          envVar.withName("ALMA_API_HOST") +
          envVar.withValue("https://api-na.hosted.exlibrisgroup.com"),

          envVar.withName("ALMA_API_KEY") +
          envVar.valueFrom.secretKeyRef.withName("credentials") +
          envVar.valueFrom.secretKeyRef.withKey("ALMA_API_KEY"),

          envVar.withName("DATABASE_HOST") +
            envVar.withValue(config.db.name),

          envVar.withName("CIRCULATION_HISTORY_DATABASE_PASSWORD") +
            envVar.valueFrom.secretKeyRef.withName(config.db.name) +
            envVar.valueFrom.secretKeyRef.withKey("CIRCULATION_HISTORY_DATABASE_PASSWORD"),

          envVar.withName("MYSQL_ROOT_PASSWORD") +
            envVar.valueFrom.secretKeyRef.withName(config.db.name + "-root") +
            envVar.valueFrom.secretKeyRef.withKey("MYSQL_ROOT_PASSWORD"),
          ])
  
}
