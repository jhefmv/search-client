# README

This project provides a simple Ruby command-line application which offers two commands for searching clients in a given JSON dataset.


## Requirements

* [Ruby](https://www.ruby-lang.org/en/documentation/installation/)

## Installation

```
gem install bundler
bundle install
```


## Running commands

### Search clients

Search clients by name:

```
bin/search_client query --field=name --value=Smith
```

Search clients by email:

```
bin/search_client query --field=email --value=smith@clients.com
```

Search clients in a JSON file:

```
bin/search_client query --field=name|email --value=smith@clients.com --file=path_to_file.json
```

### Find duplicate clients:

By field:

```
bin/search_client find_duplicates --field=name|email
```

In a fiven JSON file:
```
bin/search_client find_duplicates --field=FIELD --file=path_to_file.json
```

## Running tests

[RSpec](https://rspec.info/) tests are available. To run the tests, issue either one the commands below:

```
rspec
rspec --format=documentation
bundle exec rspec --format=documentation
```
