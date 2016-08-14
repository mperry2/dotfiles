#
# This Makefile is used to create links to configuration files.
# Add REMOVE=y to the command line to remove configuration files.
#
# Requires: GNU Stow
#
# Author: Matt Perry <matt@mattperry.com>
#

SRC = $(CURDIR)
DST = $(HOME)

IGNORE = --ignore='^\.gitmodules'

STOW   = stow --stow   --verbose=1 --target=$(DST) $(IGNORE)
UNSTOW = stow --delete --verbose=1 --target=$(DST) $(IGNORE)

DIRS = $(subst /,,$(sort $(dir $(wildcard */.))))
SUBDIRS = $(foreach dir,$(DIRS),$(PREFIX)$(dir))

.NOTPARALLEL:

.PHONY: usage
usage:
	@# Update submodules if this is the first run
	@if [ ! -f .init ]; then \
	    echo "Performing first-run initialization of dotfiles."; \
	    $(MAKE) update; \
	    touch .init; \
	    echo "Successfully completed initialization of dotfiles."; \
	    echo -e '\n\n\n'; \
	fi
	@# Display usage
	@echo "Usage: make [TARGET... | all | update]"
	@echo "Create symlinks to configuration files in the user's home directory."
	@echo "Requires GNU stow."
	@echo ""
	@echo "Mandatory arguments must be one of the following."
	@echo "  TARGET    install the TARGET configuration where TARGET is one of"
	@echo "            the following values."
	@echo $(SUBDIRS) | sed -e 's/ /\n/g' | column -c 62 | sed -e 's/^/\t\t/'
	@echo ""
	@targets=$$(sed -n '/^\(usage\|help\|check\|all\|update\):/d; s/^\([a-z]\+\):\(.*\)/\1/p' Makefile | sort); \
	for t in $$targets; do \
	    printf "  %-9s install the following targets:\n" "$$t"; \
	    sed -n "s/^$${t}:\(.*\)/\1/p" Makefile | sed -e 's/ /\n/g' | sort | column -c 62 | sed -e 's/^/\t\t/'; \
	    echo; \
	done
	@echo "  all       install for all targets"
	@echo ""
	@echo "  update    update from the remote repositories"
	@echo ""
	@echo "Specifiying a target that is already installed will remove and re-add"
	@echo "the symlinks. Add 'REMOVE=y' to the command line to remove the"
	@echo "symlinks to the configuration files."

.PHONY: help
help: usage

.PHONY: check
check:
	@stow -V >/dev/null

.PHONY: update
update:
	@echo 'Updating from remote repositories'
	git pull --recurse-submodules=yes
	git submodule init
	git submodule update --init --remote --recursive

.PHONY: $(SUBDIRS)
$(SUBDIRS): check
	$(UNSTOW) $@
ifneq ($(REMOVE),y)
	$(STOW) $@
endif

.PHONY: all
all: $(SUBDIRS)

.PHONY: perl
perl: module-starter distzilla reply pause

.PHONY: basic
basic: bash inputrc dircolors vim xmodmap

.PHONY: desktop
desktop: xmodmap

## Makefile ends here
