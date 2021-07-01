sqlite3 /nix/var/nix/db/db.sqlite -header -column "select path,narSize/1024/1024,datetime(registrationTime,'unixepoch') from ValidPaths where narSize > (1024*1024*256) order by narSize desc limit 20;"

# With output paths
nix-store -q --roots /nix/store/<hash>-<pkg>
