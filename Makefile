HUGO_VERSION := 0.32.4
GULP         := node_modules/.bin/gulp
HUGO_THEME   := jaeger-docs
THEME_DIR    := themes/$(HUGO_THEME)
YARN         := /usr/local/bin/yarn

hugo-install-macos:
	brew switch hugo $(HUGO_VERSION)

content-edit-setup: hugo-install-macos

assets-dev-setup:
	(cd $(THEME_DIR) && $(YARN))

build:
	hugo

build-assets:
	(cd $(THEME_DIR) && $(GULP) build)

develop-content: build-assets
	ENV=dev hugo serve --ignoreCache --disableFastRender

develop-assets:
	(cd $(THEME_DIR) && $(GULP) dev)
