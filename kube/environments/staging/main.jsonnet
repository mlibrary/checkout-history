{
  _config+:: {
    circulation_history: {
      repoName: 'circulation-history',
      web: {
        name: 'circulation-history-web',
        port: 3000,
        host: 'staging.circulation-history.kubernetes.lib.umich.edu',
      },
      db: {
        name: 'circulation-history-db',
      }
    },
  },

  _images+:: {
    circulation_history: {
      web: 'docker.pkg.github.com/mlibrary/circulation_history/unstable:latest',
    },
  },
} +
(import 'ksonnet-util/kausal.libsonnet') +
(import 'circulation_history/circulation_history.libsonnet')
