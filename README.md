# README

This is the repository for the circulation history app that is attached to My Account. 

## To Set up for Development

1. Clone the github repo
`$ git clone git@github.com:mlibrary/circulation_history.git`

2. Set up the environment variables by copying .env-example
```bash
$ cp .env-example .env
$ vi .env
```

```ruby
#.env
ALMA_API_KEY='YOURAPIKEY'
```	

Build the image:
```
$ docker-compose build
```
 Bundle install ruby gems
 
```bash
$ docker-compose run --rm web bundle install
```

To run the app:
```bash
$ docker-compose up
```

## Tests
For Rails rspec tests make sure then database is running. Then run the tests:
```bash
$ docker-compose up -d database
$ docker-compose run --rm web bundle exec rspec
```

## Test database
`lib/dev_db/Dockerfile` has instructions for creating an image of the database that's preloaded with fake data. It's intended for use with [patron_account/My Account](https://github.com/mlibrary/patron_account). 

## Circ History Load monitoring
When the rake task alma_circ_history:load runs a get request is made to a [pushmon](https://www.pushmon.com/) url. At the moment the pushmon account is owned by [niquerio](https://github.com/niquerio) 

## Kubernetes Configuration
Kubernetes Configuration lives in [patron-account-kube](https://github.com/mlibrary/patron-account-kube)

## Alma Analytics Report Backups
Backup xml files of the analytics reports are located in `./config/alma_analytics_reports/`
