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

And `source` the `smarttab.kak` script from it.

After that you can use **smarttab.kak**.

## Usage

This plugin adds these three commands to toggle different policy when using <kbd>Tab</kbd> and <kbd>></kbd> keys: 
* `noexpandtab` - use `tab` for everything.  
  <kbd>Tab</kbd> will insert `\t` character, and <kbd>></kbd> will use `\t` character when indenting.  
  Aligning cursors with <kbd>&</kbd> uses `\t` character.
* `expandtab` - use `space` for everything.  
  <kbd>Tab</kbd> will insert `%opt{tabstop}` amount of spaces, and <kbd>></kbd> will indent with spaces.
* `smarttab` - indent with `tab`, align with `space`.  
  <kbd>Tab</kbd> will insert `\t` character if your cursor is inside indentation area, e.g. before any  
  non-whitespace character, and insert spaces if cursor is after any non-whitespace character. Aligning  
  cursors with <kbd>&</kbd> uses `space`.

By default **smarttab.kak** affects only <kbd>Tab</kbd> and <kbd>></kbd> keys. If you want to deindent
lines that are being indented with the spaces by hitting <kbd>Backspace</kbd>, you can set `softtabstop`
option. This option describes how many `space`s should be treated as single `tab` character when deleting
spaces with backspace.

If you've used **plug.kak** for installation, you can set it within the `plug` command:
```kak
plug "andreyorst/smarttab.kak" %{
    set-option global softtabstop 4 # or other preferred value
}
```

