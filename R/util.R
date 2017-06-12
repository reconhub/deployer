yaml_load <- function(string) {
  ## More restrictive true/false handling.  Only accept if it maps to
  ## full true/false:
  handlers <- list("bool#yes" = function(x) {
    if (identical(toupper(x), "TRUE")) TRUE else x},
                   "bool#no" = function(x) {
    if (identical(toupper(x), "FALSE")) FALSE else x})
  yaml::yaml.load(string, handlers = handlers)
}

yaml_read <- function(filename) {
  catch_yaml <- function(e) {
    stop(sprintf("while reading '%s'\n%s", filename, e$message),
         call. = FALSE)
  }
  tryCatch(yaml_load(read_lines(filename)),
           error = catch_yaml)
}

read_lines <- function(...) {
  paste(readLines(...), collapse = "\n")
}

squote <- function(x) {
  sprintf("'%s'", x)
}

assert_character_or_null <- function(x, name) {
  if (!(is.null(x) || (is.character(x) && length(x) > 0L))) {
    stop(sprintf("'%s' must be a character vector (or NULL)", name))
  }
}

assert_scalar_logical_or_null <- function(x, name) {
  if (!(is.null(x) || (is.character(x) && length(x) > 0L))) {
    assert_scalar_logical(x, name)
  }
}

assert_scalar_logical <- function(x, name) {
  if (!is.logical(x)) {
    stop(sprintf("'%s' must be logical", name))
  }
  if (length(x) != 1L) {
    stop(sprintf("'%s' must be a scalar", name))
  }
  if (is.na(x)) {
    stop(sprintf("'%s' must not be missing", name))
  }
}

`%||%` <- function(a, b) {
  if (is.null(a)) b else a
}
