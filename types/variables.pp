# Datatype for variables in Postfix
# Variable names can only contain characters matching [a-zA-Z0-9_].
# Can be surrounded by { } and contain some expressions.
# See https://www.postfix.org/postconf.5.html for full context.
type Postfix::Variables = Pattern[
  # $variable
  /\A\$[a-zA-Z0-9_]+\Z/,
  # ${variable}, ${variable:var}, ${variable?var}
  /\A\$\{[a-zA-Z0-9_]+[:?]?[a-zA-Z0-9_]+}\Z/,
  # ${variable?{var1}}, ${variable?{var1}:{var2}}
  /\A\$\{[a-zA-Z0-9_]+\?\{[a-zA-Z0-9_]+\}(:\{([a-zA-Z0-9_]+\})){0,1}\}\Z/,
]
