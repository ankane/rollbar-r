# Rollbar

Exception tracking for R

[Official website](https://rollbar.com/)

## Installation

```r
install.packages("devtools")
devtools::install_github("ankane/rollbar")
```

or if you use [Jetpack](https://github.com/ankane/jetpack), add to your `packages.R`

```r
package("rollbar", github="ankane/rollbar")
```

## Usage

```r
library(rollbar)

rollbar.configure(access_token="secret", env="production")
```

Alternatively, you can set `ROLLBAR_ACCESS_TOKEN` and `R_ENV` in your environment

Report uncaught errors automatically

```r
rollbar.attach()
```

Report errors manually

```r
rollbar.error(message)
rollbar.info(message)
rollbar.debug(message)
rollbar.warning(message)
rollbar.critical(message)
```

Or use the generic method

```r
rollbar.log(level, message)
```
