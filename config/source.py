import decman
from pathlib import Path

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
}

decman.aur.packages |= {
        "decman",
}