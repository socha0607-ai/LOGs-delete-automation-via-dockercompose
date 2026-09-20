# Automated Microservice Log Rotator & Backup Engine

A production-grade, highly secure containerized log tracking and compression engine built on **Ubuntu 22.04 LTS**. This project isolates multi-container runtime interactions, schedules directory tracing logs using an isolated non-root environment, and addresses low-level virtual filesystem constraints for live environments.

---

## 🏗️ Project Architecture & Blueprint

```text
log-backup-system/
├── docker-compose.yml     # Multi-container microservice orchestrator
├── README.md              # Project documentation and technical specifications
└── app/
    ├── Dockerfile         # Secured, minimal non-root Ubuntu base image
    └── scripts/
        ├── entrypoint.sh  # Autonomous background orchestration daemon
        └── backup.sh      # Core Bash logic handling compression & truncation
```

### 🧩 Core Component Breakdown:
* **`mock_app` Container:** A secondary simulated microservice generating continuous telemetry and active logs directly to a shared persistent volume layer.
* **`backup_engine` Container:** The automated core script runner wrapped within a strict non-root Linux system context (`runtimeuser`, UID `1001`).
* **`backup.sh` Logic:** Uses production safe utilities (`truncate -s 0`) instead of crude removal tools (`rm`) to wipe files cleanly without breaking production Linux active file descriptors.

---

## 💡 Key Technical Learnings & Live OS Bypasses

Running container infrastructure within an ephemeral **"Try Ubuntu" Live USB** session introduces deep lower-level system layout constraints. This project implements specific fixes to manage these safely:

1. **OverlayFS Kernel Virtualization Fix:** A standard Live OS runs fully out of hardware RAM blocks via `overlayfs`. Docker's default compiler (`BuildKit`) crashes when attempting to nest virtual layers over this architecture. This project bypasses the restriction by altering the container subsystem engine layer parameters to utilize the **`vfs` (Virtual File System) storage driver**.
2. **Docker Gateway API Authorization:** Bypasses complex multi-group validation constraints within unstable shell environments by explicitly shifting execution stream masks over the network bridge daemon socket (`/var/run/docker.sock`).

---

## 🚀 Quick Start & Workspace Deployment

### 1. Match File System Permissions
Before launching the service engine, you must explicitly align your host system folders to map into the decoupled Docker group constraints (`UID 1001`):
```bash
sudo chown -R 1001:1001 ~/Desktop/log-backup-system/logs ~/Desktop/log-backup-system/backups
```

### 2. Compile and Initialize the Infrastructure
Execute the orchestration build file context in a detached background operational layer:
```bash
docker compose up -d --build
```

### 3. Verify Telemetry & Compression Output
Monitor the active logging daemon stream to check target script processing intervals:
```bash
docker logs -f log_backup_service
```
Every 60 seconds, you will observe the background engine sweep the shared storage block, pack the log data into a compressed archive (`.tar.gz`) inside the `./backups/` tracking repository, and cleanly reset the production active log stream.
