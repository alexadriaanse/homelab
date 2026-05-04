KOPIA_CONFIG_DIR=/mnt/storage/appdata/kopia/config
KOPIA_CACHE_DIR=/mnt/storage/appdata/kopia/cache
KOPIA_LOGS_DIR=/mnt/storage/appdata/kopia/logs
KOPIA_IMAGE=kopia/kopia:latest

run_kopia() {
    local docker_extra=()
    while [[ $# -gt 0 && "$1" != "--" ]]; do
        docker_extra+=("$1")
        shift
    done
    [[ "${1:-}" == "--" ]] && shift

    docker run --rm \
        "${docker_extra[@]+"${docker_extra[@]}"}" \
        -e KOPIA_PERSIST_CREDENTIALS_ON_CONNECT=true \
        -v "$KOPIA_CONFIG_DIR:/config" \
        -v "$KOPIA_CACHE_DIR:/app/cache" \
        -v "$KOPIA_LOGS_DIR:/app/logs" \
        "$KOPIA_IMAGE" \
        --config-file=/config/repository.config \
        --file-log-level=info \
        "$@"
}
