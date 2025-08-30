shell server:
  ssh crony@{{server}}

forward port server:
  ssh -N -L {{port}}:127.0.0.1:{{port}} root@{{server}}

deploy server:
  deploy ".#{{server}}" --magic-rollback=false

deploy-force server:
  deploy ".#{{server}}" --magic-rollback=false --auto-rollback=false

deploy-all:
  deploy "." --magic-rollback=false

reboot server:
  ssh -t root@{{server}} "reboot"
