#' @export
rollbar.attach <- function() {
  if (!interactive()) {
    prev <- getOption("error")
    options(error = function() {
      message <- geterrmessage()
      rollbar::rollbar.error(message)

      if (is.language(prev)) {
        eval(prev)
      }

      write("Execution halted", stderr())
      q("no", status = 1, runLast = FALSE)
    })
  }
}

#' @export
rollbar.configure <- function(access_token = NULL, env = NULL, root = NULL) {
  if (!missing(access_token)) {
    access_token <<- access_token
  }
  if (!missing(env)) {
    env <<- env
  }
  if (!missing(root)) {
    root <<- root
  }
}

#' @export
rollbar.critical <- function(message, extra = NULL) {
  rollbar::rollbar.log("critical", message, extra)
}

#' @export
rollbar.debug <- function(message, extra = NULL) {
  rollbar::rollbar.log("debug", message, extra)
}

#' @export
rollbar.error <- function(message, extra = NULL) {
  rollbar::rollbar.log("error", message, extra)
}

#' @export
rollbar.info <- function(message, extra = NULL) {
  rollbar::rollbar.log("info", message, extra)
}

#' @export
rollbar.warning <- function(message, extra = NULL) {
  rollbar::rollbar.log("warning", message, extra)
}

#' @export
rollbar.log <- function(level, message, extra = NULL) {
  if (!exists("access_token") || nchar(access_token) < 1) {
    access_token <- Sys.getenv("ROLLBAR_ACCESS_TOKEN")
  }
  if (!exists("env") || nchar(env) < 1) {
    env <- Sys.getenv("R_ENV")
    if (nchar(env) < 1) {
      env <- "unknown"
    }
  }
  if (!exists("root")) {
    root <- ""
  }

  if (nchar(access_token) > 0) {
    url <- "https://api.rollbar.com/api/1/item/"
    host <- Sys.info()["nodename"]
    path <- sub(".*=", "", commandArgs()[4])
    filename <- normalizePath(paste0(dirname(path), "/", path))
    if (nchar(root) > 0) {
      filename <- sub(paste0(root, "/"), "", filename)
    }

    msg <- list(body = message)
    if (!is.null(extra)) {
      msg$extra <- extra
    }

    payload <- list(
      access_token = access_token,
      data = list(
        environment = env,
        body = list(
          message = msg
        ),
        level = level,
        language = "R",
        server = list(
          host = host,
          root = root
        ),
        context = filename
      )
    )

    send <- function() {
      response <- httr::POST(url, body = payload, encode = "json")
      body <- httr::content(response, "parsed")
      write("[Rollbar] Scheduling payload", stderr())
      write(paste0("[Rollbar] Details: https://rollbar.com/instance/uuid?uuid=", body$result$uuid, " (only available if report was successful)"), stderr())
    }
    try(send())
  } else {
    write("[Rollbar] Not enabled in this environment", stderr())
  }
}
