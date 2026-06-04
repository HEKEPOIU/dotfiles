def --env get-env [name] { $env | get $name }
def --env set-env [name, value] { load-env { $name: $value } }
def --env unset-env [name] { hide-env $name }

let carapace_completer = {|spans|
  load-env {
  	CARAPACE_SHELL_BUILTINS: (help commands | where category != "" | get name | each { split row " " | first } | uniq  | str join "\n")
  	CARAPACE_SHELL_FUNCTIONS: (help commands | where category == "" | get name | each { split row " " | first } | uniq  | str join "\n")
  }

  # if the current command is an alias, get it's expansion
  let expanded_alias = (scope aliases | where name == ($spans | first) | get expansion? | first | default null)

  # overwrite
  let spans = (if $expanded_alias != null  {
    # put the first word of the expanded alias first in the span
    $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1 | str replace --regex  '\.exe$' '')
  } else {
    $spans | skip 1 | prepend (($spans | first) | str replace --regex  '\.exe$' '')
  })

  carapace ($spans | first) nushell ...$spans
  | from json
}

mut current = (($env | default {} config).config | default {} completions)
$current.completions = ($current.completions | default {} external)
$current.completions.external = ($current.completions.external
| default true enable
# force overwrite completer to carapace
| upsert completer { $carapace_completer })

$env.config = $current
    

