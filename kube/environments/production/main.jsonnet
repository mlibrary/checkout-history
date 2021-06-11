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
