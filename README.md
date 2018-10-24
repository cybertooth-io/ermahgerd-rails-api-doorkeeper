# README

## Development - Getting Started

You need the following:

* Ruby-2.3+ (suggest Ruby-2.5 but check your production environment to be sure -- e.g. AWS EB)
* The `config/master.key` file

### First Time Setting Up

Perform the following from the command line:

1. `bundle install` - will install any of the missing gems declared in the `Gemfile`
1. `docker-compose up -d` - start up a Redis and PostgreSQL server in a container
1. `rake db:create` - only required the first time, make sure your database is created
1. `rake db:migrate` - run as required, your application will produce a stacktrace of errors if you're not up to date
1. `rake db:seed_fu` - run as required, to seed the database with data
1. `rake test` - run as required, test to make sure your API is behaving

### Running The Server

`rails s` - to serve the API on [http://localhost:3000](http://localhost:3000)


### Database Seeds

For development, feel free to edit the `db/fixtures/development/002_users.rb` file to add yourself.

Seed the database with:

```bash
$ rake db:seed_fu
```

### Crons/Jobs/Queues

_Coming soon_

### Development Workflow

1. Create a model with its **singular name**: `rails g model role key:string name:string notes:text`
    1. Edit the migration to ensure the `default` and `null` values are defined
    1. Add validations, relationships, scopes, etc. to the new model class
    1. Add test fixture data accordingly to `test/fixtures/*.yml` (keep it general and un-crazy)
    1. Unit test accordingly
    1. Add the model information to the `config/locales/*.yml` file(s)
1. Create the pundit policy with the **model's singular name**: `rails g pundit:policy role`
    1. Make sure your policy file extends `ApplicationPolicy` (it should by default)
    1. Override `create?`, `destroy?`, `index?`, `show?`, and `update?` accordingly
    1. Unit test accordingly
    1. Add the policy error messages to the `config/locales/*.yml` if so desired
1. Create the protected resource using the **model's singular name** at the appropriate api path: 
`rails g jsonapi:resource api/v1/protected/role`
    1. Make sure the resource extends `BaseResource`
    1. Add the appropriate attributes from the model that will be serialized in the JSONAPI payload
    1. Make sure all relationships you want exposed are added
    1. Add any filters that use model scopes
    1. Unit test accordingly through the controller (next step)
1. Create the protected controller using the **model's plural name** at the appropriate api path:
`rails g controller api/v1/protected/roles`
    1. Make sure the controller extends `BaseResourceController`
    1. Add the controller's end points to the `config/routes.rb` file; use `jsonapi_resources` helper :-)
    1. Unit test accordingly (e.g. confirm returned payload only contains the fields specified in the resource)

----

## Credentials

As of Rails-5.2 secrets are hashed and locked down with the `config/master.key` file.  Run `rails credentials:help` for
more information.

Do you need to create a key?  Use `rake secret`

Do you need to edit some secrets?  Do it from the command line:

```bash
$ rails credentials:edit
```

----

## Deployment

_Coming soon_
