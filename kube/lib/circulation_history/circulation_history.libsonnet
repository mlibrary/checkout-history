{
  local deployment = $.apps.v1.deployment,
  local container = $.core.v1.container,
  local containerPort = $.core.v1.containerPort,
  local envVar = $.core.v1.envVar,
  local pvc = $.core.v1.persistentVolumeClaim,
  local volume = $.core.v1.volume,
  local volumeMount = $.core.v1.volumeMount,

  local configMap = $.core.v1.configMap,

  local config = $._config.circulation_history,
  local images = $._images.circulation_history,
  

  circulation_history: {
    web: {
      deployment: deployment.new(
        name=config.web.name,
        replicas=1,
        containers=[
          container.new(
            config.repoName, 
            images.web
          ) + 
          container.withPorts( containerPort.new('web', config.web.port)) +
          container.withEnvMixin([           
              envVar.withName("RAILS_ENV") +
              envVar.withValue("production"),

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
            ]),
        ]
      ) + 
      deployment.spec.strategy.withType('Recreate') +
      deployment.spec.selector.withMatchLabels({app: config.web.name}) +
      deployment.spec.template.metadata.withLabels({app: config.web.name}) +
      deployment.spec.template.spec.withImagePullSecrets([{name: "github-packages-read"}]),

      service: $.util.serviceFor(self.deployment), 
    },
    db: {
      storage:
        pvc.new(config.db.name) +
        pvc.spec.withVolumeMode("Filesystem") +
        pvc.spec.resources.withRequests({ storage: "512G" }) +
        pvc.spec.withAccessModes("ReadWriteOnce"),

      deployment:
        deployment.new(
          config.db.name,
          replicas=1,
          containers=[
            container.new("mysql", "mariadb:10.6") +
            container.withPorts(containerPort.new("mysql", 3306)) +
            container.withEnvMixin([
              envVar.withName("MYSQL_ROOT_PASSWORD") +
              envVar.valueFrom.secretKeyRef.withName(config.db.name + "-root") +
              envVar.valueFrom.secretKeyRef.withKey("MYSQL_ROOT_PASSWORD"),
            ]) +
            container.withVolumeMounts([
              volumeMount.new("mariadb", "/var/lib/mysql"),
            ]),
          ],
        ) +
        deployment.spec.template.spec.withVolumes([
          volume.fromPersistentVolumeClaim("mariadb", config.db.name),
        ]) +
        deployment.spec.strategy.withType('Recreate') +
        deployment.spec.selector.withMatchLabels({app: config.db.name}) +
        deployment.spec.template.metadata.withLabels({app: config.db.name}),

      service: $.util.serviceFor(self.deployment),
    },
  },
}
