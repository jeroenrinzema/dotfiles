# Dotfiles

Small repository containing my personal dotfiles used local configurations.

## Tooling and programming languages

```sh
$ brew install go node helm
$ brew install hyperkit minikube docker docker-compose
$ brew install fzf git neovim navi telnet wget curl gpg
```

## Minikube and docker

```sh
$ minikube start --mount --mount-string "/Users:/Users"
$ # Setup docker to connect with minikube
$ eval $(minikube docker-env)
$ # Save the local docker ip to /etc/hosts
$ echo "`minikube ip` docker.local" | sudo tee -a /etc/hosts > /dev/null
```

