# kopia

Backs up ZFS datasets to Backblaze B2 using read-only auto-snapshots.

## First-time setup

### 1. Create or connect to a B2 repository

To create a new repository:

```bash
./kopia/kopia repository create s3 \
  --endpoint=s3.us-west-001.backblazeb2.com \
  --bucket=<bucket> \
  --access-key=<b2-key-id> \
  --secret-access-key=<b2-app-key> \
  --override-hostname=nas \
  --retention-mode=COMPLIANCE \
  --retention-period=30d

./kopia policy set /backup \
  --add-ignore /backups/timemachine \
  --add-ignore /backups/kopia
```

To connect to an existing repository:

```bash
./kopia/kopia repository connect s3 \
  --endpoint=s3.us-west-001.backblazeb2.com \
  --bucket=<bucket> \
  --access-key=<b2-key-id> \
  --secret-access-key=<b2-app-key> \
  --override-hostname=nas
```

### 2. Run a backup

```bash
./kopia/backup
```

## Scheduling

Register `kopia/backup` as a cron job or TrueNAS scheduled task to run daily.

## Browsing snapshots

Use the `kopia/kopia` wrapper to run any Kopia CLI command:

```bash
./kopia/kopia snapshot list
```

## Restoring files

Restore requires bind-mounting a host destination into the container. Run directly with `docker run`, adding `-v /mnt/storage/restore:/restore` and restoring to `/restore` inside the container.
