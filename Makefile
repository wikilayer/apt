.DEFAULT_GOAL := test

DEBIAN_IMAGE := debian:bookworm
SHELLCHECK_IMAGE := koalaman/shellcheck:v0.10.0

.PHONY: lint test publish withdraw

lint:
	docker run --rm -v "$(CURDIR)":/repo:ro -w /repo $(SHELLCHECK_IMAGE) bin/add-packages bin/index bin/verify bin/withdraw tests/install

test: lint
	docker run --rm -v "$(CURDIR)":/repo:ro $(DEBIAN_IMAGE) bash /repo/tests/install

publish:
	@test -n "$(INCOMING)" || { echo "usage: make publish INCOMING=<directory with .deb files>"; exit 1; }
	bin/add-packages "$(INCOMING)"
	@if [ -z "$$(git status --porcelain pool)" ]; then echo "nothing new to publish"; else bin/index && bin/verify wikilayer.gpg; fi

# Takes a version out of the pool and the signed index, for a release that
# must not be offered any more: `make withdraw PACKAGE=wlget VERSION=0.2.1`.
withdraw:
	@test -n "$(PACKAGE)" -a -n "$(VERSION)" || { echo "usage: make withdraw PACKAGE=<name> VERSION=<version>"; exit 1; }
	bin/withdraw "$(PACKAGE)" "$(VERSION)"
	bin/index
	bin/verify wikilayer.gpg
