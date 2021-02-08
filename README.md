# README

This is the repository for the my_account module for the library website. It uses the Alma API to get and update patron's library account information. It is a replacement for patron/patron.php.

## To Set up for Development

1. Clone the github repo
`$ git clone git@github.com:mlibrary/my_account.git`
2. Set up the environment variables. 
```bash
$ mkdir -p .env/development
$ vi .env/development/web
```
```ruby
#.env/development/web
ALMA_API_KEY='YOURAPIKEY'
ALMA_API_HOST='https://api-na.hosted.exlibrisgroup.com'
```	
3. Install php unit:
```bash
$ docker-compose run --rm composer require --dev phpunit/phpunit
```
4. Bundle install ruby gems
```bash
$ docker-compose run --rm web bundle install
```

## Tests
For Rails rspec tests run:
```bash
$ docker-compose run web bundle exec rspec
```

For PHPUnit Tests run
```bash
$ docker-compose run phpunit tests
```

For Integration testing of php and rails app, edit 
`php/src/test.php` with the functions you want to try.

To run the test in the command line make sure the rails app is running:

```bash
$ docker-compose up -d web
```
then run the script
```bash
$ docker-compose run --rm php php src/test.php
```
