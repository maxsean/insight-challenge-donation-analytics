# Donation Analytics
Insight Data Coding Challenge

## Introduction
The task is to analyze loyalty trends in campaign contributions to political candidates by identifying areas of repeat donors and calculating how much they're spending.

The data comes from the Federal Election Commission's publications of campaign contributions, and it is assumed the data follows the FEC's [data dictionary](https://classic.fec.gov/finance/disclosure/metadata/DataDictionaryContributionsbyIndividuals.shtml).

## Assumptions
1) Only the latest donations by year from a repeat donor are considered (derived from the provided FAQ about order of data). In that year, all donations from the aforementioned repeat donor to different recipients or the same recipient will be considered in the total transaction amount and percentile calculations for a given recipient for that year and donor's zip code.

2) Transaction amounts may be negative (which would be considered a withdrawal).

## Setup
The solution is written in Ruby (2.3.3) and the unit tests use the RSpec framework. The tests are run with Rake. Dependencies are specified in the `Gemfile` and, if bundler is installed, running `bundle install` on the terminal while within the directory should install them.

If all is good, feel free to skip to Running the Code.

In case an error occurs, this is how I set up my environment for Unix systems (e.g. OS X) from scratch (unfortunately I am as familiar with the Linux environment, but I am working on it):

### Install Homebrew
Homebrew is a package management system.
Run this command in the terminal
```
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/install/master/install)"
```
Verify successful installation, run in terminal
```
brew doctor
```
You should see
```
Your system is ready to brew
```

### Install Ruby versions
Install the Ruby version with the command below
```
brew install ruby-install
```
Install Ruby 2.3.3
```
ruby-install ruby 2.3.3
```
Set Ruby 2.3.3 as your default Ruby
```
echo "ruby-2.3.3" > ~/.ruby-version
```
Last step to help avoid issues in future assignments:
```
gem install bundler
```

## Running the Code
While at the topmost directory in the file structure, and make sure the command `bundle install` was successful, you should be able to run
```
./run.sh
```
The terminal should receive a message saying how long the code took to run.

If an error with a gem occurs, you may need to run `gem pristine --all`.

## Running the Tests
Apart from the provided insight test suite, the unit tests can be run with this command while at the topmost directory of the project:
```
rake
```
This will look for a `Rakefile` which should be at the topmost directory.

The unit tests can be found at `/insight_testsuite/tests/spec/`.
