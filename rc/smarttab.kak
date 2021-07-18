# ╭─────────────╥──────────────────────╮
# │ Author:     ║ File:                │
# │ Andrey Orst ║ smarttab.kak         │
# ╞═════════════╩══════════════════════╡
# │ Extends tab handling by adding     │
# │ three different commands for       │
# │ each mode.                         │
# ╞════════════════════════════════════╡
# │ Rest of .dotfiles:                 │
# │ GitHub.com/andreyorst/smarttab.kak │
# ╰────────────────────────────────────╯

define-command -docstring "noexpandtab: use tab character to indent and align" \
noexpandtab %{ require-module smarttab; noexpandtab-impl }

define-command -docstring "expandtab: use space character to indent and align" \
expandtab %{ require-module smarttab; expandtab-impl }

define-command -docstring "smarttab: use tab character for indentation and space character for alignment" \
smarttab %{ require-module smarttab; smarttab-impl }

# note: there is no space-indent, tab-align setting; this is assumed to be equivalent to noexpandtab
define-command -docstring "autoconfigtab: use tab or space character to indent and align based upon existing settings (e.g. via editorconfig)" \
autoconfigtab %{ require-module smarttab; autoconfigtab-impl }

provide-module smarttab %§

# Options
# ‾‾‾‾‾‾‾

declare-option -docstring "amount of spaces that should be treated as single tab character when deleting spaces" \
int softtabstop 0

declare-option -docstring "displays current tab handling mode" \
str smarttab_mode ''

declare-option -docstring 'what text to display in ''%opt{smarttab_mode}'' when expandtab mode is on' \
str smarttab_expandtab_mode_name 'expandtab'

declare-option -docstring 'what text to display in ''%opt{smarttab_mode}'' when expandtab mode is on' \
str smarttab_noexpandtab_mode_name 'noexpandtab'

declare-option -docstring 'what text to display in ''%opt{smarttab_mode}'' when expandtab mode is on' \
str smarttab_smarttab_mode_name 'smarttab'

declare-option -hidden int oldindentwidth %opt{indentwidth}

# Commands
# ‾‾‾‾‾‾‾‾

define-command -hidden noexpandtab-impl %{
    set-option buffer smarttab_mode %opt{smarttab_noexpandtab_mode_name}
    remove-hooks buffer smarttab-mode
    smarttab-set
    set-option buffer indentwidth 0
    set-option buffer aligntab true
    hook -group smarttab-mode buffer InsertDelete ' ' %{ try %sh{
        if [ $kak_opt_softtabstop -gt 1 ]; then
           printf "%s\n" 'execute-keys -draft "<a-h><a-k>^\h+.\z<ret>I<space><esc><lt>"'
        fi
    } catch %{ try %{
        execute-keys -itersel -draft "h%opt{softtabstop}<s-h>2<s-l>s\h+\z<ret>d"
    }}}
}

define-command -hidden expandtab-impl %{
    set-option buffer smarttab_mode %opt{smarttab_expandtab_mode_name}
    remove-hooks buffer smarttab-mode
    smarttab-set
    set-option buffer aligntab false
    hook -group smarttab-mode buffer InsertChar '\t' %{ execute-keys -draft "h%opt{indentwidth}@" }
    hook -group smarttab-mode buffer InsertDelete ' ' %{ try %sh{
        if [ $kak_opt_softtabstop -gt 1 ]; then
            printf "%s\n" 'execute-keys -draft -itersel "<a-h><a-k>^\h+.\z<ret>I<space><esc><lt>"'
        fi
    } catch %{ try %{
        execute-keys -itersel -draft "h%opt{softtabstop}<s-h>2<s-l>s\h+\z<ret>d"
    }}}
}

define-command -hidden smarttab-impl %{
    set-option buffer smarttab_mode %opt{smarttab_smarttab_mode_name}
    remove-hooks buffer smarttab-mode
    smarttab-set
    set-option buffer indentwidth 0
    set-option buffer aligntab false
    hook -group smarttab-mode buffer InsertChar '\t' %{ try %{
        execute-keys -draft "<a-h><a-k>^\h*.\z<ret>"
    } catch %{
        execute-keys -draft "h@"
    }}
    hook -group smarttab-mode buffer InsertDelete ' ' %{ try %sh{
        if [ $kak_opt_softtabstop -gt 1 ]; then
            printf "%s\n" 'execute-keys -draft "<a-h><a-k>^\h+.\z<ret>I<space><esc><lt>"'
        fi
    } catch %{ try %{
        execute-keys -itersel -draft "h%opt{softtabstop}<s-h>2<s-l>s\h+\z<ret>d"
    }}}
}

define-command -hidden autoconfigtab-impl %{ evaluate-commands %sh{
    if [ $kak_opt_aligntab = true ]; then
        echo "noexpandtab"
    elif [ $kak_opt_indentwidth -eq 0 ]; then
        echo "smarttab"
    else
        echo "expandtab"
    fi
}}

define-command -hidden smarttab-set %{ evaluate-commands %sh{
    if [ $kak_opt_indentwidth -eq 0 ]; then
        printf "%s\n" "set-option buffer indentwidth $kak_opt_oldindentwidth"
    else
        printf "%s\n" "set-option buffer oldindentwidth $kak_opt_indentwidth"
    fi
}}

§
