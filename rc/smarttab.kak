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

declare-option -docstring "amount of spaces that should be treated as single tab character when deleting spaces" \
int softtabstop -1

declare-option -hidden int oldindentwidth %opt{indentwidth}
define-command -hidden smarttab-set %{ evaluate-commands %sh{
    if [ $kak_opt_indentwidth -eq 0 ]; then
        echo "set-option window indentwidth $kak_opt_oldindentwidth"
    else
        echo "set-option window oldindentwidth $kak_opt_indentwidth"
    fi
    if [ $kak_opt_softtabstop -lt 0 ]; then
        echo "set-option window softtabstop $kak_opt_tabstop"
    fi
}}

define-command -docstring "noexpandtab: use tab character to indent and align" \
noexpandtab %{
    remove-hooks window tabmode
    smarttab-set
    set-option window indentwidth 0
    set-option window aligntab true
    hook -group tabmode window InsertDelete ' ' %{ try %sh{
        if [ $kak_opt_softtabstop -gt 1 ]; then
            echo 'execute-keys -draft <a-h><a-k> "^\h+.\z" <ret>I<space><esc><lt>'
        fi
    } catch %{
        try %{ execute-keys -draft h %opt{softtabstop}<s-h> 2<s-l> s "\h+\z" <ret>d }
    }}
}

define-command -docstring "expandtab: use space character to indent and align" \
expandtab %{
    remove-hooks window tabmode
    smarttab-set
    set-option window aligntab false
    hook -group tabmode window InsertChar '\t' %{ execute-keys -draft h@ }
    hook -group tabmode window InsertDelete ' ' %{ try %sh{
        if [ $kak_opt_softtabstop -gt 1 ]; then
            echo 'execute-keys -draft <a-h><a-k> "^\h+.\z" <ret>I<space><esc><lt>'
        fi
    } catch %{
        try %{ execute-keys -draft h %opt{softtabstop}<s-h> 2<s-l> s "\h+\z" <ret>d }
    }}
}

define-command -docstring "smarttab: use tab character for indentation and space character for alignment" \
smarttab %{
    remove-hooks window tabmode
    smarttab-set
    set-option window indentwidth 0
    set-option window aligntab false
    hook -group tabmode window InsertChar '\t' %{ try %{
        execute-keys -draft <a-h><a-k> "^\h*.\z" <ret>
    } catch %{
        execute-keys -draft h@
    }}
    hook -group tabmode window InsertDelete ' ' %{ try %sh{
        if [ $kak_opt_softtabstop -gt 1 ]; then
            echo 'execute-keys -draft <a-h><a-k> "^\h+.\z" <ret>I<space><esc><lt>'
        fi
    } catch %{
        try %{ execute-keys -draft h %opt{softtabstop}<s-h> 2<s-l> s "\h+\z" <ret>d }
    }}
}

