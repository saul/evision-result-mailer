# eVision Results

A small Ruby script that scrapes assessment results on eVision and sends diffs via email.

## Installation

To install the dependencies:

```
bundle install
```

### PhantomJS

PhantomJS must be installed on your machine and the `phantomjs` executable on your PATH.

For Ubuntu/Debian, run `sudo apt-get install phantomjs`

For Mac OS X and Windows, download from the [PhantomJS static build page](http://phantomjs.org/download.html).

### Configuration

Before running the script, a `.env` file should be created (or the appropriate environment variables set). See below
for an example `.env` file:

```
EVISION_HOST=https://evision.york.ac.uk
EVISION_USERNAME=Username
EVISION_PASSWORD=Base64 Encoded Password Here

GMAIL_EMAIL=my.address@gmail.com
GMAIL_PASSWORD=gmail password
```

**Notes**:

* `EVISION_PASSWORD` must be Base64 encoded
* `GMAIL_EMAIL` is used as the *To* and *From* for the diff email
* `GMAIL_PASSWORD` should be an app-specific password for users with two-factor authentication

## Running the script

```
rake mail_diff
```

A `last_results.cache` file will be updated on each run, which is a JSON representation of assessment results for the
latest academic year.

### Running on a schedule

As described in `config/schedule.rb`, a Crontab can be setup to execute `rake mail_diff` every 15 minutes by executing:

```
whenever --update-crontab
```