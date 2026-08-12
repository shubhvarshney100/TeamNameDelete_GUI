# Delete

**Secure data erasure for HDD, SATA SSD and NVMe drives. NIST SP 800-88 compliant.**

![License](https://img.shields.io/badge/license-MIT-blue)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)
![Standard](https://img.shields.io/badge/NIST-SP%20800--88%20Rev.1-green)

---

## The problem

Deleting a file or formatting a drive removes filesystem metadata. It does not remove the data. Everything stays on the physical medium and can be reconstructed with tools like Autopsy, FTK Imager or PhotoRec in under an hour.

This matters most when devices are retired, resold or recycled. Studies of second hand drives have repeatedly recovered financial records, credentials and personal documents from disks the previous owner believed were wiped. Many organisations respond by physically destroying drives, which works but creates avoidable e-waste.

Two things make correct erasure harder than it looks:

**Wear levelling.** On flash storage, the Flash Translation Layer redirects writes to fresh cells. Overwriting logical block N does not guarantee the physical cell behind N is touched. Research has measured 4 to 75 percent of data surviving a software overwrite on tested SSDs.

**Journaling.** ext4, XFS and NTFS keep a write ahead log that can retain fragments independently of the main data blocks, so residue survives even after an overwrite pass completes.

`Delete` solves both by booting outside the host OS and using firmware level commands that operate below the FTL.

---

## Features

- **Three erasure methods**, selected automatically per drive
- **Boots independently** of the installed OS, so no journaling side channels and no file locks
- **Automatic device classification** by interface type and rotational flag
- **Boot device exclusion** so the tool cannot erase the media it is running from
- **Frozen state recovery** for drives locked by UEFI at power on
- **Post erasure verification** with LBA sampling and entropy analysis
- **Certificate generation** producing an auditable record of each wipe

---

## How it works

| Drive type | Method | Command layer | Time |
|---|---|---|---|
| HDD (rotational) | DoD 5220.22-M three pass overwrite | `dd` | O(3n/W), scales with capacity |
| SATA SSD | ATA `SECURITY ERASE UNIT` | `hdparm` | O(1), firmware controlled |
| NVMe SSD | Cryptographic sanitize | `nvme-cli` | O(1), key destruction |

The asymptotic gap is the whole point. Overwriting a 1 TB HDD moves a terabyte of data three times over the host bus. Destroying a 256 bit media encryption key on an NVMe drive takes the same time whether the drive is 512 GB or 4 TB.

Measured on real hardware:

```text
Seagate Barracuda 1 TB HDD      3 hours 42 minutes
Kingston A400 256 GB SATA SSD   under 5 minutes
WD Black SN750 512 GB NVMe      8 seconds
```

---

## NIST SP 800-88 levels

| Level | Protects against | Method | Media reusable |
|---|---|---|---|
| **Clear** | Software recovery tools | Overwrite with known pattern | Yes |
| **Purge** | Laboratory recovery techniques | ATA Secure Erase, cryptographic erase | Yes |
| **Destroy** | Nation state adversaries | Physical destruction | No |

`Delete` targets **Purge**. Destroy is out of scope for any software tool.

---

## Requirements

```bash
sudo apt install build-essential gcc hdparm nvme-cli coreutils
```

Optional, for inspecting drive capabilities before a wipe:

```bash
sudo apt install smartmontools
```

---

## Build

```bash
git clone https://github.com/shubhvarshney100/Delete.git
cd Delete
make
```

Clean build artifacts:

```bash
make clean
```

---

## Usage

> **Warning**
> This tool permanently destroys data. There is no undo and no recovery. Verify your device selection before every run.

Root privileges are required for direct hardware access.

```bash
sudo ./delete <device> <level>
```

### Examples

```bash
# Clear level, internal reuse within an organisation
sudo ./delete /dev/sda clear

# Purge level, media leaving organisational control
sudo ./delete /dev/sdb purge

# Physical destruction guidance
sudo ./delete /dev/sdc destroy
```

### Confirmation

Every destructive operation requires an explicit typed confirmation:

```text
Type 'CONFIRM NIST SANITIZATION' to proceed:
```

### Inspecting a drive first

```bash
sudo hdparm -I /dev/sda | grep -A 10 Security
```

---

## Device classification

Drives are classified from two kernel exposed attributes and dispatched to the correct routine.

```bash
BOOT_DEV=$(findmnt -n -o SOURCE / | sed 's/[0-9]*$//')

for dev in $(lsblk -dn -o NAME); do
    full=/dev/$dev
    [[ $full == $BOOT_DEV ]] && continue

    if [[ $dev == nvme* ]]; then
        erase_nvme "$full"
    else
        rot=$(cat /sys/block/$dev/queue/rotational)
        if [[ $rot -eq 1 ]]; then
            erase_hdd "$full"
        else
            erase_sata_ssd "$full"
        fi
    fi
done
```

---

## Erasure routines

### HDD, three pass overwrite

```bash
erase_hdd() {
    local dev=$1
    echo "[*] Detected HDD: $dev"

    echo "[*] Pass 1/3: zeroes"
    dd if=/dev/zero of="$dev" bs=4M status=progress

    echo "[*] Pass 2/3: ones"
    tr '\000' '\377' < /dev/zero | dd of="$dev" bs=4M status=progress

    echo "[*] Pass 3/3: random"
    dd if=/dev/urandom of="$dev" bs=4M status=progress

    echo "[+] HDD erase complete: $dev"
}
```

### SATA SSD, ATA Secure Erase

Handles the UEFI frozen state via a suspend resume cycle.

```bash
erase_sata_ssd() {
    local dev=$1
    local frozen
    frozen=$(hdparm -I "$dev" | grep -i 'frozen' | grep -v 'not')

    if [[ -n $frozen ]]; then
        echo "[!] Drive frozen. Attempting suspend..."
        echo mem > /sys/power/state
        sleep 3
    fi

    hdparm --user-master u --security-set-pass "tmppass" "$dev"
    hdparm --user-master u --security-erase "tmppass" "$dev"

    echo "[+] ATA Secure Erase complete: $dev"
}
```

### NVMe, cryptographic sanitize

Falls back to `nvme format --ses=2` on controllers without crypto erase support.

```bash
erase_nvme() {
    local dev=$1
    local ns="${dev}n1"
    echo "[*] NVMe detected: $dev"

    san_support=$(nvme id-ctrl "$dev" | grep sanicap | awk '{print $3}')

    if [[ $((san_support & 0x4)) -ne 0 ]]; then
        echo "[*] Using nvme sanitize (crypto erase)"
        nvme sanitize "$dev" --sanact=4
        while true; do
            progress=$(nvme sanitize-log "$dev" | grep "Global Data Erased")
            [[ $progress == *"yes"* ]] && break
            sleep 2
        done
    else
        echo "[*] Falling back to nvme format --ses=2"
        nvme format "$ns" --ses=2 --namespace-id=0xffffffff
    fi

    echo "[+] NVMe erase complete: $dev"
}
```

---

## Verification

After erasure the tool samples 50 randomly selected LBA offsets per device and checks each block for known file signatures and for entropy above threshold. Full forensic analysis with Autopsy is used as a second verification layer.

```text
Sampling:   50 random LBA offsets, 512 bytes each
Signatures: 300+ file magic patterns (JPEG, PDF, DOCX, and others)
Entropy:    Shannon, threshold 0.5 bits per byte
Forensics:  Autopsy 4.19, all carving modules enabled
```

Result across all tested devices: zero files and zero fragments recovered.

---

## ATA commands used

| Opcode | Command | Purpose |
|---|---|---|
| `0xEC` | IDENTIFY DEVICE | Capability detection |
| `0xF1` | SECURITY SET PASSWORD | Password initialisation |
| `0xF2` | SECURITY ERASE UNIT | Standard secure erase |
| `0xB4` | SANITIZE DEVICE | Block erase and crypto scramble |

ATA commands are issued through the SCSI layer using ATA PASS-THROUGH (16), opcode `0x85`.

---

## Architecture

```text
main.c              CLI interface and orchestration
├── detectDevice.c  ATA device capability detection
├── nist.c          NIST sanitization level implementation
└── ata.c           Low level ATA command execution
```

---

## Troubleshooting

**Drive is frozen**

UEFI firmware locks ATA security state at power on as a ransomware defence. Trigger a suspend resume cycle, or hot plug the SATA cable while the system is running.

```bash
sudo systemctl suspend
# wake the system, then run the tool again
```

**Failed to identify ATA device**

Confirm the device is SATA or IDE rather than USB attached. Check root access and device permissions.

**SANITIZE commands failed**

Older drives may not implement SANITIZE. The tool falls back to SECURITY ERASE UNIT automatically.

**Command not supported**

```bash
sudo hdparm -I /dev/sdX
```

---

## Limitations

- **HDD throughput.** Three pass overwrite scales linearly. A 4 TB drive takes roughly 15 hours. A single random pass is sufficient per Wright et al. and cuts this to around 5 hours.
- **NVMe without hardware encryption.** Where the `sanicap` crypto erase bit is unset, the tool falls back to `nvme format --ses=2`, whose behaviour is controller defined and may not cover all physical cells.
- **USB attached drives.** Most USB to SATA bridges block ATA passthrough. Overwrite still works but misses spare cell coverage.
- **eMMC and UFS storage.** Embedded storage in phones, tablets and single board computers is not exposed through the standard block device interface and is not supported.
- **Physical layer recovery.** Residual magnetic or charge signatures can persist at the medium level. An adversary with laboratory equipment and access to individual NAND cells may recover partial data. This is a fundamental limit of every software erasure tool.

---

## Research paper

The design, formal algorithms and validation methodology are documented in an accompanying paper:

**Delete: A Bootable Utility for Secure Erasure of HDD, SSD and NVMe Storage Devices**
Shubh Varshney, Department of Information Technology, Maharaja Agrasen Institute of Technology, Delhi

The paper covers five formal algorithms with pseudocode, a threat model, complexity analysis and forensic validation results.

---

## Legal notice

This tool is intended for legitimate data sanitization. Users are responsible for authorisation before sanitizing any device, compliance with organisational data retention policy, adherence to applicable law, and maintaining chain of custody documentation.

**Data destruction is permanent and irreversible.** The authors accept no liability for data loss or hardware damage.

---

## References

1. P. Gutmann, "Secure deletion of data from magnetic and solid-state memory," USENIX Security, 1996
2. M. Wei et al., "Reliably erasing data from flash-based solid state drives," USENIX FAST, 2011
3. NIST SP 800-88 Rev. 1, "Guidelines for Media Sanitization," 2014
4. C. Wright et al., "Overwriting hard drive data: The great wiping controversy," ICISS, 2008
5. DoD 5220.22-M, National Industrial Security Program Operating Manual, 2006

---

## License

MIT
