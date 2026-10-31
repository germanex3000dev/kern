import decman
from pathlib import Path
import os

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

declared_path = Path("/var/lib/kern/declared.txt")
declared_path.parent.mkdir(parents=True, exist_ok=True)
with open(declared_path, "w") as f:
    for package in sorted(decman.pacman.packages):
        f.write(package + "\n")
    for package in sorted(decman.aur.packages):
        f.write(package + "\n")

print("pacman; ", decman.pacman.packages)
print("aur: ", decman.aur.packages)