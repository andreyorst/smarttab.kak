# ╭─────────────╥────────────────────────╮
# │ Author:     ║ File:                  │
# │ Andrey Orst ║ smarttab-powerline.kak │
# ╞═════════════╩════════════════════════╡
# │ Smarttab module for powerline.kak    │
# ╞══════════════════════════════════════╡
# │ GitHub.com/andreyorst/smarttab.kak   │
# │ GitHub.com/andreyorst/powerline.kak  │
# ╰──────────────────────────────────────╯

hook global ModuleLoaded powerline %{ require-module powerline_expandtab }

provide-module powerline_expandtab %§

declare-option -hidden bool powerline_module_smarttab true

declare-option -hidden str-list powerline_modules
set-option -add global powerline_modules 'smarttab'

define-command -hidden powerline-smarttab %{ evaluate-commands %sh{
    default=$kak_opt_powerline_base_bg
    next_bg=$kak_opt_powerline_next_bg
    normal=$kak_opt_powerline_separator
    thin=$kak_opt_powerline_separator_thin
    if [ "$kak_opt_powerline_module_smarttab" = "true" ]; then
        fg=$kak_opt_powerline_color18
        bg=$kak_opt_powerline_color20
        if [ ! -z "$kak_opt_smarttab_mode" ]; then
        [ "$next_bg" = "$bg" ] && separator="{$fg,$bg}$thin" || separator="{$bg,${next_bg:-$default}}$normal"
            echo "set-option -add global powerlinefmt %{$separator{$fg,$bg} %opt{smarttab_mode} }"
            echo "set-option global powerline_next_bg $bg"
        fi
    fi
}}

define-command -hidden powerline-toggle-smarttab -params ..1 %{ evaluate-commands %sh{
    [ "$kak_opt_powerline_module_smarttab" = "true" ] && value=false || value=true
    if [ -n "$1" ]; then
        [ "$1" = "on" ] && value=true || value=false
    fi
    echo "set-option global powerline_module_smarttab $value"
    echo "powerline-rebuild"
}}

§
