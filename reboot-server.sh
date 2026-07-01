#! /usr/bin/env sh
for server in $(awk '{
    if ($0 ~ /server/) {
        print prev
    }
    prev = $0
}' hosts.nix | awk '{ print $1 }'); do just reboot "$server"; done
