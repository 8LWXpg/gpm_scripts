# Scripts

## `exe`

Download latest release of a executable from GitHub repository.

```pwsh
gpm repo <repo> a <exe> exe <user/repo> <target_assets>
```

- `<exe>`: The file name of the executable.
- `<user/repo>`: The GitHub repository to download from.
- `<target_assets>`: The target assets pattern, like `x86_64-pc-windows`

## `zip_exe`

Download latest release of a executable in zip from GitHub repository.

```pwsh
gpm repo <repo> a <exe> zip_exe <user/repo> <target_assets>
```

- `<exe>`: The file name of the executable.
- `<user/repo>`: The GitHub repository to download from.
- `<target_assets>`: The target assets pattern, like `x86_64-pc-windows`

## `ptr`

Download latest release of a PowerToys Run Plugin from GitHub repository.

```pwsh
gpm repo <repo> a <plugin> ptr <user/repo>
```

- `<plugin>`: The name of the plugin, must be the same as the folder name.
- `<user/repo>`: The GitHub repository to download from.

## `dir`

Copy a directory to repo root.

```pwsh
gpm repo <repo> a <name> dir <path> [-c]
```
