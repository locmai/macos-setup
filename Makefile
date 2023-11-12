.POSIX:
.PHONY: default build update

default: build

/nix:
	curl -L https://nixos.org/nix/install | sh
	# TODO https://github.com/LnL7/nix-darwin/issues/149
	sudo rm /etc/nix/nix.conf

/run/current-system/sw/bin/darwin-rebuild:
	/nix/var/nix/profiles/default/bin/nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
	yes | ./result/bin/darwin-installer

build: /nix /run/current-system/sw/bin/darwin-rebuild 
	/run/current-system/sw/bin/nix --experimental-features 'nix-command flakes' build ./\#darwinConfigurations.$(shell hostname -s).system
	./result/sw/bin/darwin-rebuild switch --flake .

update:
	nix flake update
