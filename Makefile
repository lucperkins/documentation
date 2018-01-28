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
	(cd themes/jaeger-docs && $(GULP) build)

develop-content: build-assets
	hugo serve

develop-assets:
	(cd themes/jaeger-docs && $(GULP) dev)

develop-assets-and-content:
	make develop-assets
	PID1=$!
	ENV=dev hugo serve)
	PID2=$!
	wait $(PID1) $(PID2)
