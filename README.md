# Rollbar

Error tracking for R

[Rollbar website](https://rollbar.com/)

[![Build Status](https://travis-ci.org/ankane/rollbar.svg?branch=master)](https://travis-ci.org/ankane/rollbar)

## Installation

```r
install.packages("rollbar")
```

or if you use [Jetpack](https://github.com/ankane/jetpack), run:

```r
jetpack::add("rollbar")
```

## Usage

```r
library(rollbar)

rollbar.configure(access_token="secret", env="production")
```

Use your `post_server_item` access token

Alternatively, you can set `ROLLBAR_ACCESS_TOKEN` and `R_ENV` in your environment

Report uncaught errors automatically

```r
rollbar.attach()
```

Report errors manually

```r
rollbar.error(message)
```

Additional methods include

```r
rollbar.info
rollbar.debug
rollbar.warning
rollbar.critical
```

Or use the generic method

```r
rollbar.log(level, message)
```

Pass extra details

```r
rollbar.info("Job successful", list(job_id=123, awesome="yes"))
```

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/rollbar/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/rollbar/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/rollbar.git
cd rollbar
```

In R, do:

```r
install.packages("devtools")
devtools::install_deps(dependencies=TRUE)
devtools::check()
```
