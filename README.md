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

## `dir`

Copy a directory to repo root.

```pwsh
gpm repo <repo> a <name> dir <path> [-c]
```

## `file`

Copy a file to repo root

```pwsh
gpm repo <repo> a <name> file <path> [-c]
```
