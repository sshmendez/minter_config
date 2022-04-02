#!/bin/bash

debian () {
	sudo apt update -y
	sudo apt upgrade -y
	sudo apt install build-essential curl tmux jq sqlite3 -y
}

rust-install () {
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	source $HOME/.cargo/env
	cargo install --locked melwalletd melwallet-client melminter
}
clear-coins () {
	echo "delete from coins; delete from coin_confirmations" | sqlite3 ~/.themelio/mainnet-wallets.db
}

tmux-start() { 
	tmux new-session \; \
	send-keys 'melwalletd --wallet-dir ~/.themelio' C-m \; \
	split-window -v \; \
	send-keys 'sleep 1; melwallet-cli create -w w 2> /dev/null' C-m Enter\; \
	send-keys 'sleep 2; melwallet-cli unlock -w w' C-m Enter\; \
	split-window -h \; \
	send-keys 'sleep 5; melminter --backup-wallet w' C-m \;
}

wallet () {
	melwallet-cli "$1" -w w "${@:2}"
}
summary () {
	melwallet-cli summary -w __melminter_Mainnet; wallet summary
}

send () {
	wallet send --to "$1"
}
send-to() {
	send  `curl localhost:11773/wallets/"$1" | jq .address | tr -d '"'`,"$2" 
}
home_addr () {
	echo t3yvgw7nfvsqd13t2h7mcdtr6c2r754nm5vtqkvt0fjk0g779fm260
}

swap () {
	wallet swap --from MEL --to SYM "$1"
}

total_mels () {
	curl -s localhost:11773/wallet/$1 | jq .total_micromels
}

send_all () {
	melwallet
}

while test $# != 0
	do
	case "$1" in
		--debian) debian ;;
		--rust) rust-install ;;
		--tmux) tmux-start ;;

	esac
	shift
done


