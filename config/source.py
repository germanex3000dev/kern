import decman

with open("/home/pineapples/kern-packages-native.txt") as f:
    decman.pacman.ignored_packages |= {
            line.strip()
            for line in f
            if line.strip()
    }

with open("/home/pineapples/kern-packages-foreign.txt") as f:
    decman.aur.ignored_packages |= {
            line.strip()
            for line in f
            if line.strip()
    }

with open("/home/pineapples/kern-all-foreign.txt") as f:
    decman.aur.ignored_packages |= {
            line.strip()
            for line in f
            if line.strip() and line.strip() != "decman"
    }


decman.pacman.packages |= {
        "python",
        "fastfetch",
        "htop",
        "rust",
}

decman.aur.packages |= {
        "decman",
}

