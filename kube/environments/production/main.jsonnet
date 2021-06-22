{
  _config+:: {
    circulation_history: {
      repoName: 'circulation-history',
      web: {
        name: 'circulation-history-web',
        port: 3000,
      },
      db: {
        name: 'circulation-history-db',
      }
    },
  },

  _images+:: {
    circulation_history: {
      web: 'ghcr.io/mlibrary/circulation_history:latest',
    },
  },
} +
(import 'ksonnet-util/kausal.libsonnet') +
(import 'circulation_history/circulation_history.libsonnet')
+ 
{
  local cronJob = $.batch.v1beta1.cronJob,
  local cronJobTemplateSpec = cronJob.spec.jobTemplate.spec.template.spec,
  local cronJobSecurityContext = cronJobTemplateSpec.securityContext,
  local cronJobSchedule(schedule) = { spec+: { schedule: schedule } },

    loader: cronJob.new( name='circulation-history-loader', 
      containers=[ 
      $.circulation_history_container + 
        {command: ['bundle', 'exec', 'rake', 'alma_circ_history:load']}])
       + cronJob.spec.withConcurrencyPolicy('Forbid')
       + cronJob.spec.withSchedule("30 2 * * *")
       + cronJobTemplateSpec.withRestartPolicy('OnFailure'),
}
