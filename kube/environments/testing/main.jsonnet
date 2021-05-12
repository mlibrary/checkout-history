(import 'ksonnet-util/kausal.libsonnet') +
{
  local deployment = $.apps.v1.deployment,
  local container = $.core.v1.container,
  local containerPort = $.core.v1.containerPort,
  local envVar = $.core.v1.envVar,
  local pvc = $.core.v1.persistentVolumeClaim,
  local volume = $.core.v1.volume,
  local volumeMount = $.core.v1.volumeMount,

  local repoName = "circulation-history",
  local webName = "circulation-history-web",
  local dbName = "circulation-history-db",

  circulation_history: {
    web: {
      deployment:
        deployment.new(
          webName,
          replicas=1,
          containers=[
            container.new(
              repoName,
              "docker.pkg.github.com/mlibrary/circulation_history/unstable:latest",
            ) +
            container.withPorts(containerPort.new("web", 3000)) +
            container.withEnvMixin([
              envVar.withName("ALMA_API_HOST") +
              envVar.withValue("https://api-na.hosted.exlibrisgroup.com"),

              envVar.withName("ALMA_API_KEY") +
              envVar.valueFrom.secretKeyRef.withName("credentials") +
              envVar.valueFrom.secretKeyRef.withKey("ALMA_API_KEY"),

              envVar.withName("DATABASE_HOST") +
              envVar.withValue(dbName),

              envVar.withName("MYSQL_ROOT_PASSWORD") +
              envVar.valueFrom.secretKeyRef.withName(dbName) +
              envVar.valueFrom.secretKeyRef.withKey("MYSQL_ROOT_PASSWORD"),
            ]),
          ],
        ) +
        deployment.spec.strategy.withType('Recreate') +
        deployment.spec.selector.withMatchLabels({app: webName}) +
        deployment.spec.template.metadata.withLabels({app: webName}) +
        deployment.spec.template.spec.withImagePullSecrets([{name: "github-packages-read"}]),

      service: $.util.serviceFor(self.deployment),
    },

    db: {
      storage:
        pvc.new(dbName) +
        pvc.spec.withVolumeMode("Filesystem") +
        pvc.spec.resources.withRequests({ storage: "512G" }) +
        pvc.spec.withAccessModes("ReadWriteOnce"),

      deployment:
        deployment.new(
          dbName,
          replicas=1,
          containers=[
            container.new("mysql", "mariadb:10.6") +
            container.withPorts(containerPort.new("mysql", 3306)) +
            container.withEnvMixin([
              envVar.withName("MYSQL_ROOT_PASSWORD") +
              envVar.valueFrom.secretKeyRef.withName(dbName) +
              envVar.valueFrom.secretKeyRef.withKey("MYSQL_ROOT_PASSWORD"),
            ]) +
            container.withVolumeMounts([
              volumeMount.new("mariadb", "/var/lib/mysql"),
            ]),
          ],
        ) +
        deployment.spec.template.spec.withVolumes([
          volume.fromPersistentVolumeClaim("mariadb", dbName),
        ]) +
        deployment.spec.strategy.withType('Recreate') +
        deployment.spec.selector.withMatchLabels({app: dbName}) +
        deployment.spec.template.metadata.withLabels({app: dbName}),

      service: $.util.serviceFor(self.deployment),
    },
  },
}
