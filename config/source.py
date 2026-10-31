import decman
from pathlib import Path
import os

declared_output = os.environ.get("KERN_DECLARED_OUTPUT")

if declared_output:
    declared= (
            decman.pacman.packages |
            decman.aur.packages
    )

    with open(declared_output, "w") as f:
        for package in sorted(declared):
            f.write(package + 

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
