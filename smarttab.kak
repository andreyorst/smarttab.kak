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
int softtabstop %opt{tabstop}

declare-option -hidden int old_indentwidth %opt{indentwidth}

define-command -docstring "noexpandtab: use tab character to indent and align" \
noexpandtab %{
    remove-hooks window tabmode
    evaluate-commands %sh{
        [ ! $kak_opt_indentwidth -eq 0 ] && echo "set-option window old_indentwidth $kak_opt_indentwidth"
    }
    set-option window indentwidth 0
    set-option window aligntab true
}

define-command -docstring "expandtab: use space character to indent and align" \
expandtab %{
    remove-hooks window tabmode
    set-option window indentwidth %opt{old_indentwidth}
    set-option window softtabstop %opt{tabstop}
    hook -group tabmode window InsertChar '\t' %{ execute-keys -draft h@ }
    hook -group tabmode window InsertDelete ' ' %{ try %{
        execute-keys -draft <a-h><a-k> "^\h+.\z" <ret>I<space><esc><lt>
    } catch %{
        try %{ execute-keys -draft h %opt{softtabstop}<s-h> 2<s-l> s "\h+\z" <ret>d }
    }}
    set-option window aligntab false
}

define-command -docstring "smarttab: use tab character for indentation and space character for alignment" \
smarttab %{
    remove-hooks window tabmode
    set-option window softtabstop %opt{tabstop}
    evaluate-commands %sh{
        [ ! $kak_opt_indentwidth -eq 0 ] && echo "set-option window old_indentwidth $kak_opt_indentwidth"
    }
    set-option window indentwidth 0
    hook -group tabmode window InsertChar '\t' %{ try %{
        execute-keys -draft <a-h><a-k> "^\h*.\z" <ret>
    } catch %{
        execute-keys -draft h@
    }}
    hook -group tabmode window InsertDelete ' ' %{ try %{
        execute-keys -draft <a-h><a-k> "^\h+.\z" <ret>I<space><esc><lt>
    } catch %{
        try %{ execute-keys -draft h %opt{softtabstop}<s-h> 2<s-l> s "\h+\z" <ret>d }
    }}
    set-option window aligntab false
}

