# Ruby on Rails Car Forum

This application is based on
[*Ruby on Rails Tutorial:
Learn Web Development with Rails*](http://www.railstutorial.org/)
by [Michael Hartl](http://www.michaelhartl.com/). And the final interpretation is owned by Team-431 from UCAS.


## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ git clone https://github.com/saintube/rails_sample_app.git
$ cd rails_sample_app
$ (optional) gem install bundler
$ bundle install
$ (optional) bundle update
```

Next, migrate the database:

```
$ rails db:migrate
```

Third, generate the seed data:

```
$ rails db:seed
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a Cloud9 workspace server:

```
$ rails server -b $IP -p $PORT
```

## Administrator (provided by seeds)

```
name: example@railstutorial.org
password: foobar
```

## More info
For more information, see the
[*Ruby on Rails Tutorial* book](http://www.railstutorial.org/book).
