# Enter a NixOS system chroot (assumes system is mounted at /mnt)
nixos-enter
# List and delete generations in the system profile
nix-env --list-generations --profile /nix/var/nix/profiles/system
nix-env --delete-generations +4 --profile /nix/var/nix/profiles/system
