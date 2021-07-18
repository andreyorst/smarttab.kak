# smarttab.kak
![license](https://img.shields.io/github/license/andreyorst/smarttab.kak.svg)

**smarttab.kak** is a plugin for [Kakoune](https://github.com/mawww/kakoune) editor.
It provides three different ways of handling indentation and alignment with tab key.

## Installation

### With [plug.kak](https://github.com/andreyorst/plug.kak) (recommended)
Add this to your `kakrc`:
```kak
plug "andreyorst/smarttab.kak"
```
Source your `kakrc` or restart Kakoune, and execute `:plug-install`. Or if you don't want
to source configuration file or restart Kakoune, simply run `plug-install andreyorst/smarttab.kak`.
It will be enabled automatically.

### Without plugin manager

Clone this repo somewhere
```sh
git clone https://github.com/andreyorst/smarttab.kak.git
```

You can put this repo to your `autoload` directory, or manually `source` the `smarttab.kak` script in your configuration file.

After that you can use **smarttab.kak**.

## Usage

This plugin adds these three commands to toggle different policy when using <kbd>Tab</kbd> and <kbd>></kbd> keys:
* `noexpandtab` - use `tab` for everything.
  <kbd>Tab</kbd> will insert `\t` character, and <kbd>></kbd> will use `\t` character when indenting.
  Aligning cursors with <kbd>&</kbd> uses `\t` character.
* `expandtab` - use `space` for everything.
  <kbd>Tab</kbd> will insert `%opt{indentwidth}` amount of spaces, and <kbd>></kbd> will indent with spaces.
* `smarttab` - indent with `tab`, align with `space`.
  <kbd>Tab</kbd> will insert `\t` character if your cursor is inside indentation area, e.g. before any
  non-whitespace character, and insert spaces if cursor is after any non-whitespace character. Aligning
  cursors with <kbd>&</kbd> uses `space`.
* `autoconfigtab` - choose the above based upon one of the existing settings (see later section).

By default **smarttab.kak** affects only <kbd>Tab</kbd> and <kbd>></kbd> keys. If you want to deindent
lines that are being indented with the spaces by hitting <kbd>Backspace</kbd>, you can set `softtabstop`
option. This option describes how many `space`s should be treated as single `tab` character when deleting
spaces with backspace.

In order to automatically enable different modes for different languages you can use `hook`s like so:

```kak
hook global WinSetOption filetype=c smarttab
hook global WinSetOption filetype=rust expandtab
```

To adjust **smarttab.kak** related options you need to use `ModuleLoaded` hook,
because all options are defined withing the `smarttab` module:

```sh
hook global ModuleLoaded smarttab %{
    set-option global softtabstop 4
    # you can configure text that is being used to represent curent active mode
    set-option global smarttab_expandtab_mode_name 'exp'
    set-option global smarttab_noexpandtab_mode_name 'noexp'
    set-option global smarttab_smarttab_mode_name 'smart'
}
```

If you've used **plug.kak** for installation, it's better to configure
**smarttab.kak** it within the `plug` command, because it can handle lazy
loading of configurations for the plugin, and configure editor behavior:

```sh
plug "andreyorst/smarttab.kak" defer smarttab %{
    # when `backspace' is pressed, 4 spaces are deleted at once
    set-option global softtabstop 4
} config %{
    # these languages will use `expandtab' behavior
    hook global WinSetOption filetype=(rust|markdown|kak|lisp|scheme|sh|perl) expandtab
    # these languages will use `noexpandtab' behavior
    hook global WinSetOption filetype=(makefile|gas) noexpandtab
    # these languages will use `smarttab' behavior
    hook global WinSetOption filetype=(c|cpp) smarttab
}
```

## `autoconfigtab` configuration

If you just want to set the behavior based upon your `editorconfig` settings, you can use the `autoconfigtab` setting:

```kak
hook global BufCreate .* %{
    editorconfig-load
    autoconfigtab
}
```

This config will choose `expandtab` or `noexpandtab` based upon the `indent_style` setting as `space` or `tab` respectively.

If you'd prefer to use `smarttab` instead of `noexpandtab` for `indent_style = tab` (without affecting `indent_style = space`), you can manually override the `aligntab` option to `false` before running `autoconfigtab`, as seen in the below config:

```kak
hook global BufCreate .* %{
    editorconfig-load
    set-option buffer aligntab false
    autoconfigtab
}
```

Currently, `autoconfigtab` does not cover the case where `indentwidth` is nonzero but `aligntab` is set to `true`, as this would mean indenting with spaces and aligning with tabs. In this particular case, tab alignment takes priority and `noexpandtab` is chosen.
