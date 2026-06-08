# Ssh into the server
[group('ssh')]
shell server:
    ssh crony@{{ server }}

# Forward a port from server to localhost
[group('ssh')]
forward port server:
    ssh -N -L {{ port }}:127.0.0.1:{{ port }} root@{{ server }}

# Deploy server nixos installation
[group('deploy')]
deploy server:
    deploy ".#{{ server }}" --magic-rollback=false -s

# Forcefully deploy without rollback
[group('deploy')]
deploy-force server:
    deploy ".#{{ server }}" --magic-rollback=false --auto-rollback=false -s

# Deploy all servers available
[group('deploy')]
deploy-all:
    deploy "." --magic-rollback=false -s

# Deploy all servers available
[group('deploy')]
deploy-all-boot:
    deploy "." --magic-rollback=false -s --boot

# Reboot the server
[group('ssh')]
reboot server:
    ssh -t root@{{ server }} "reboot"

# Update current nixos install
[group('nixos')]
update:
    nh os test -u -a && nh os switch

# Test current config
[group('nixos')]
test:
    nh os test -a

# Switch to current config
[group('nixos')]
switch:
    nh os switch -a

# Commit flake.lock update or modifications
[group('git')]
commit-lock:
    git add flake.lock
    git commit -m "feat: update flake.lock"
    git push
