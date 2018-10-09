# README

## Development - Getting Started

You need the following:

* Ruby-2.5+
* The `config/master.key` file

Perform the following from the command line:

1. `bundle install` - will install any of the missing gems declared in the `Gemfile`
1. `docker-compose up -d` - start up a Redis and PostgreSQL server in a container
1. `rake db:create` - only required the first time, make sure your database is created
1. `rake db:migrate` - run as required, your application will produce a stacktrace of errors if you're not up to date
1. `rake db:seed_fu` - run as required, to seed the database with data
1. `rake test` - run as required, test to make sure your API is behaving
1. `rails s` - to serve the API on [http://localhost:3000](http://localhost:3000)

## Credentials

As of Rails-5.2 secrets are hashed and locked down with the `config/master.key` file.  Run `rails credentials:help` for
more information.

Do you need to create a key?  Use `rake secret`

Do you need to edit some secrets?  Do it from the command line:

```bash
$ rails credentials:edit
```

## Database Seeds

For development, feel free to edit the `db/fixtures/development/001_users.rb` file to add yourself.

Seed the database with:

```bash
$ rake db:seed_fu
```

## Crons/Jobs/Queues

_Coming soon_

## Deployment

_Coming soon_
