# Sets access control list for a given <path> and subdirectories
#
# setfacl docs: https://linux.die.net/man/1/setfacl
#
# Difference between chmod and acl: https://unix.stackexchange.com/questions/364517/difference-between-chmod-vs-acl
#

setfacl -R -m g:users:rwX <path>
find <path> -type d | xargs setfacl -R -m d:g:users:rwX
