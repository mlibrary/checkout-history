# README

This is the repository for the circulation history app that is attached to My Account. 

## To Set up for Development

1. Clone the github repo
`$ git clone git@github.com:mlibrary/circulation_history.git`

2. Set up the environment variables by copying .env-example
```bash
$ vi cp .env-example .env
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
