# Sets the user.email in the git config for all subdirectories of the current directory
#
# Useful for when there is a set of multiple repositories where the user.email config
# should different from the globally defined one

for d in */; do pushd $d; git config --add user.email <user@example.com>; popd; done
