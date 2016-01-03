# eVision Results

A small Ruby script that scrapes assessment results on eVision and sends diffs via email.

## Installation

To install the dependencies:

```
bundle install
```

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
ruby diff_mailer.rb
```

A `last_results.cache` file will be updated on each run, which is a JSON representation of assessment results for the
latest academic year.
