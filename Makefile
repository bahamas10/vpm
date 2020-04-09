PREFIX ?= /usr/local

.PHONY: all
all:
	@echo 'nothing to do'

.PHONY: install
install:
	cp ./vpm $(PREFIX)/bin/vpm
	(
source /usr/share/bash-completion/completions/xbps

_vpm()
{
    local cur prev words cword
    _init_completion || return
    
    local subcommands='sync
	update
	listrepos
	repolist
	addrepo
	info
	filelist
	deps
	reverse
	search
	searchfile
	list
	install
	devinstall
	listalternatives
	setalternative
	reconfigure
	forceinstall
	remove
	removerecursive
	cleanup
	autoremove
	help
	helppager'
    local all_pkgs='info|filelist|deps|reverse|search|install|devinstall'
    local installed_pkgs='listalternatives|setalternative|reconfigure|forceinstall|remove|removerecursive'

    if [[ $prev == @($1) ]]; then
        COMPREPLY=( $( compgen -W "$subcommands" -- "$cur") )
    elif [[ $prev == @($all_pkgs) ]]; then
    	COMPREPLY=( $(compgen -W '$(_xbps_all_packages)' -- "$cur") )
    elif [[ $prev == @($installed_pkgs) ]]; then
    	COMPREPLY=( $(compgen -W '$(_xbps_installed_packages)' -- "$cur") )
    fi
} &&
complete -F _vpm vpm
	)>/usr/share/bash-completion/completions/vpm

.PHONY: uninstall
uninstall:
	rm -f $(PREFIX)/bin/vpm
	rm -f /usr/share/bash-completion/completions/vpm

.PHONY: check
check:
	shellcheck vpm
