#!/bin/bash
login-ssh() { 
	tmux new-window -n $1 \; \
	send-keys 'ssh '$1 C-m\; \
	send-keys 'tmux a' C-m\; 
}



minters() {
	echo miner0 miner1 miner2 miner3 miner4 | xargs -n 1 
}

run-each () {
minters | xargs -P 20 -I {}  ssh "{}" 'echo {}::$('$@') ""' | sort 

}

login-all() {
	login-ssh miner0
	login-ssh miner1
	login-ssh miner2
	login-ssh miner3
	login-ssh miner4
}
