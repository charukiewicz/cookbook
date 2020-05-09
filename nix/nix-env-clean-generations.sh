# View all the generations in the system profile
nix-env --list-generations --profile /nix/var/nix/profiles/system

# Delete all but the last 4 generations for the system profile
nix-env --delete-generations +4 --profile /nix/var/nix/profiles/system
