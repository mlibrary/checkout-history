(import './circulation_history/web_container.libsonnet') +
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
        containers=[ $.circulation_history_container +
          container.withPorts( containerPort.new('web', config.web.port)) 
        ]
      ) + 
      deployment.spec.strategy.withType('Recreate') +
      deployment.spec.selector.withMatchLabels({app: config.web.name}) +
      deployment.spec.template.metadata.withLabels({app: config.web.name}),
      

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
