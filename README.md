# khansohil530.github.io

Personal site built with [Hugo](https://gohugo.io/) and the [Blowfish](https://blowfish.page/) theme.

## Prerequisites

- [Hugo Extended](https://gohugo.io/installation/) `0.158.0` or newer (tested with `0.162.1`)
- Git

### Install Hugo (macOS)

```bash
brew install hugo
hugo version   # should show "extended"
```

Blowfish requires the **extended** build for image processing. If `hugo version` does not include `extended`, reinstall with:

```bash
brew install hugo
```

## Local development

### First-time setup

```bash
# Clone the repo (includes the Blowfish submodule)
git clone --recurse-submodules https://github.com/khansohil530/khansohil530.github.io.git
cd khansohil530.github.io

# Start the dev server
hugo serve
```

Open http://localhost:1313 in your browser. Hugo watches `content/`, `assets/`, `config/`, and `layouts/` for changes and rebuilds automatically.

### Day-to-day

If the theme is already present, just run:

```bash
hugo serve
```

Useful flags:

- `hugo serve -D` — include draft content
- `hugo serve --disableFastRender` — full rebuild on every change (slower, but useful when debugging templates)

## Production build

```bash
hugo --gc --minify
```

Output is written to `public/`.

## Project layout

| Path | Purpose |
|------|---------|
| `config/_default/` | Site and theme configuration |
| `content/` | Markdown pages (home, resume, projects) |
| `assets/` | Images and CSS processed by Hugo |
| `static/` | Files copied as-is (favicons, PDFs) |
| `themes/blowfish/` | Blowfish theme |

## Theme management

Blowfish is included as a **git submodule** (see `.gitmodules`). Do not commit the theme as regular files — that bloats the repo and makes updates painful.

```bash
# First-time clone (pulls the theme submodule too)
git clone --recurse-submodules https://github.com/khansohil530/khansohil530.github.io.git

# If you already cloned without submodules
git submodule update --init --recursive
```

### Updating the theme

```bash
git submodule update --remote themes/blowfish
git add themes/blowfish
git commit -m "chore: update blowfish theme"
```

### Migrating from a vendored theme

If `themes/blowfish/` was previously committed as regular files:

```bash
git rm -r --cached themes/blowfish
rm -rf themes/blowfish
git submodule add -b main https://github.com/nunocoracao/blowfish.git themes/blowfish
git submodule update --init --recursive
```

## Troubleshooting

### `partial "partials/header/basic.html" not found`

The vendored Blowfish theme is too old for Hugo `0.146+`. Update the theme using the commands in [Updating the theme](#updating-the-theme) above.

### `function "slot" not defined`

Do not copy Hugo's internal `_internal/shortcodes/figure.html` into `layouts/shortcodes/`. Use the Blowfish theme's `figure` shortcode instead, or remove any custom override in `layouts/shortcodes/`.

### Hugo version warning

You may see:

```
WARN Module "blowfish" is not compatible with this Hugo version: 0.158.0/0.161.1 extended
```

This is safe to ignore on Hugo `0.162.x` — the site still builds. If you hit template errors, install a supported version:

```bash
brew install hugo
```

### Do not put a `.git` directory inside `layouts/`

Hugo treats everything under `layouts/` as templates. An accidental `git init` there will cause parse errors on `.git/hooks/*.sample` files.
