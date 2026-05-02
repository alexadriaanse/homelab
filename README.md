# homelab

Docker Compose stacks for a TrueNAS SCALE homelab, managed via a single `manage` script. Secrets are stored in 1Password and injected at runtime using the 1Password CLI Docker image.

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

1. Clone this repo onto the TrueNAS host.
2. Create a 1Password service account and save its token to `.op-token`:
   ```
   echo "ops1_..." > .op-token
   chmod 600 .op-token
   ```
3. Register `manage up` as a post-init script and `manage down` as a pre-shutdown script in TrueNAS (System → Advanced → Init/Shutdown Scripts). This ensures containers start after ZFS datasets are mounted and databases shut down cleanly before the system powers off.

## Usage

```
./manage <command> [app]
```

| Command | Description |
|---|---|
| `up [app]` | Inject secrets and start containers |
| `down [app]` | Stop containers |
| `restart [app]` | Inject secrets and restart containers |
| `recreate [app]` | Inject secrets and force-recreate containers |
| `update [app]` | Pull latest images, inject secrets, and restart |
| `logs <app>` | Tail logs (app required) |
| `status` | Show status of all apps |

If `[app]` is omitted, the command runs for all discovered apps.

## Adding an app

1. Create a directory with a `compose.yml`.
2. If the app needs secrets, add an `env.tpl` with `op://` references:
   ```
   DB_PASSWORD=op://homelab/myapp/db-password
   ```
3. Run `./manage up <app>`.
