# VM Setup Guide (M1 Mac — UTM)

## Why UTM?

UTM is free, open-source, and the best VM software for Apple Silicon (M1/M2/M3).
Parallels and VMware Fusion also work but cost money.

Download: https://mac.getutm.app/

## Recommended VM Config (8GB RAM Mac)

| VM | OS | RAM | CPU | Role |
|---|---|---|---|---|
| victim | Ubuntu 22.04 ARM | 2GB | 2 cores | Wazuh Agent endpoint |

> Keep Wazuh server running in Docker on your Mac (not a VM) to save RAM.

## Setting Up Ubuntu 22.04 VM in UTM

1. Open UTM → Click **+** → **Virtualize**
2. Select **Linux**
3. Download Ubuntu 22.04 ARM ISO:
   `https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04.5-live-server-arm64.iso`
4. RAM: **2048 MB**, CPU: **2 cores**, Storage: **20 GB**
5. Boot and complete Ubuntu install (server edition is lighter)

## Find Your Mac's IP (for agent registration)

```bash
# Run on your Mac
ipconfig getifaddr en0
# or check UTM network — usually 192.168.64.1 is the Mac host
```

## Network Settings in UTM

Use **Shared Network** mode — this gives the VM internet access and allows
it to reach your Mac (where Wazuh manager runs in Docker).

The VM will get an IP like `192.168.64.x`, and your Mac is at `192.168.64.1`.
