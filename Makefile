.DEFAULT_GOAL := test

DEBIAN_IMAGE := debian:bookworm
SHELLCHECK_IMAGE := koalaman/shellcheck:v0.10.0

.PHONY: lint test publish

lint:
	docker run --rm -v "$(CURDIR)":/repo:ro -w /repo $(SHELLCHECK_IMAGE) bin/add-packages bin/index tests/install

test: lint
	docker run --rm -v "$(CURDIR)":/repo:ro $(DEBIAN_IMAGE) bash /repo/tests/install

publish:
	@test -n "$(INCOMING)" || { echo "usage: make publish INCOMING=<directory with .deb files>"; exit 1; }
	bin/add-packages "$(INCOMING)"
	bin/index
