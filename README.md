# OSUPrinter

[![Build Status](https://travis-ci.org/kylekthompson/OSUPrinter.svg?branch=master)](https://travis-ci.org/kylekthompson/OSUPrinter)

OSUPrinter is a [Ruby on Rails](http://rubyonrails.org/) application designed to simplify the printing process for OSU's CSE and ECE printers.

## How it works

After selecting ECE or CSE, you will be prompted for a username and password (note: this is the login for your ECE or CSE account). After providing those details, you will be prompted to select the file(s) for printing. Finally, you will select a printer and printing options. Click print, and you're done!

## Hacking on OSUPrinter

### Get started

New to Ruby? No worries! You can follow these instructions to install a local server.

#### Installing a Local Server

First things first, you'll need to install Ruby 2.2.3. We recommend using [rbenv](https://github.com/sstephenson/rbenv).

```bash
rbenv install 2.2.3
rbenv global 2.2.3
```

Note: If you don't have rbenv, install it like this: `brew install rbenv`

Next, you'll need to make sure that you have PostgreSQL installed. This can be
done easily on OSX using [Homebrew](http://brew.sh)

```bash
brew install postgresql
```

You will want to set postgresql to autostart at login via launchctl, if not already. See `brew info postgresql`.

Now, let's install the gems from the `Gemfile` ("Gems" are synonymous with libraries in other languages).

```bash
gem install bundler && rbenv rehash
```

### Setup OSUPrinter

Once bundler is installed go ahead and run the `setup` script

```bash
script/setup
```

### Running the application

Just run `rails server` and that's it! You should have a working instance of OSUPrinter located [here](http://localhost:3000)

## Deployment

We strongly encourage you to use [https://osuprinter.herokuapp.com](https://osuprinter.herokuapp.com), but if you would like your own version, OSUPrinter can be easily deployed to Heroku.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Contributing

We'd love to have you participate. Please check out our [contributing guidelines](CONTRIBUTING.md).

## Contributors

OSUPrinter is developed by these [contributors](https://github.com/kylekthompson/OSUPrinter/graphs/contributors).

## Thanks

Thanks to [Classroom for GitHub](https://github.com/education/classroom) for the lovely README and scripts!
