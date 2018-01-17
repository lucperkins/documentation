HUGO_VERSION := 0.32.4

hugo-install-macos:
	brew switch hugo $(HUGO_VERSION)

build:
	hugo

develop-content:
	hugo serve
