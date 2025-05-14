shell server:
  ssh root@{{server}}

forward port server:
  ssh -N -L {{port}}:127.0.0.1:{{port}} root@{{server}}

deploy server:
  deploy ".#{{server}}" --magic-rollback=false

deploy-all:
  deploy "." --magic-rollback=false
