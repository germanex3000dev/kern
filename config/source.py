import decman
from pathlib import Path
import os

declared_output = os.environ.get("KERN_DECLARED_OUTPUT")

if declared_output:
    with open(declared_output, "w") as f:
        for package in sorted(decman.pacman.packages):
            f.write(package + "")

        for package in sorted(decman.aur.packages):
            f.write(package + "")

ledger_path = Path("/var/lib/kern/ledger.txt")

if ledger_path.exists():
    with open(ledger_path) as f:
        ignored = {
            line.strip()
            for line in f
            if line.strip()
        }
        decman.pacman.ignored_packages |= ignored
        decman.aur.ignored_packages |= ignored

decman.pacman.packages |= {
        "python",
        "fastfetch",
        "rust",
        "ranger",
        "lua",
        "chawan",
        "tailscale",
}

decman.aur.packages |= {
        "decman",
}

print("pacman; ", decman.pacman.packages)
print("aur: ", decman.aur.packages)
