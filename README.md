# homelab

Docker Compose stacks for a TrueNAS SCALE homelab. Container lifecycle is managed by TrueNAS Custom Apps. Secrets are stored in 1Password and injected via the `manage` script using the 1Password CLI Docker image.

## Structure

```
homelab/
├── manage              # Management script
├── .op-token           # 1Password service account token (gitignored)
├── .gitignore
├── <app>/
│   ├── compose.yml
│   ├── env.tpl         # Secret template with op:// references (committed)
│   └── .env            # Injected secrets (gitignored, generated at runtime)
└── ...
```

## Setup

1. Clone this repo onto the TrueNAS host (e.g. `/mnt/storage/homelab`).
2. Create a 1Password service account and save its token to `.op-token`:
   ```
   echo "ops1_..." > .op-token
   chmod 600 .op-token
   ```
3. Inject secrets: `./manage inject`
4. For each app, create a TrueNAS Custom App (Apps → Discover Apps → Custom App → Install via YAML) using the snippet from `./manage yaml <app>`.

## Usage

```
./manage <command> [app]
```

| Command | Description |
|---|---|
| `inject [app]` | Inject secrets from 1Password into `.env` files |
| `yaml [app]` | Print TrueNAS Custom App YAML snippet |
| `logs <app>` | Tail logs (app required) |
| `status` | Show status of all apps |

If `[app]` is omitted, the command runs for all discovered apps.

## Adding an app

1. Create a directory with a `compose.yml`.
2. If the app needs secrets, add an `env.tpl` with `op://` references:
   ```
   DB_PASSWORD=op://homelab/myapp/db-password
   ```
3. Run `./manage inject <app>` to write the `.env` file.
4. Create a TrueNAS Custom App using the YAML from `./manage yaml <app>`.
