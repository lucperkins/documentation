HUGO_VERSION = 0.36
NODE_BIN     = node_modules/.bin
FIREBASE     := $(NODE_BIN)/firebase
FIREBASE_PROJECT = jaeger-docs
GULP         := $(NODE_BIN)/gulp
HUGO_THEME   := jaeger-docs
THEME_DIR    := themes/$(HUGO_THEME)
YARN         := /usr/local/bin/yarn
HUGO         := /usr/local/bin/hugo
CONCURRENTLY := $(NODE_BIN)/concurrently

hugo-install-macos:
	brew switch hugo $(HUGO_VERSION)

content-edit-setup: hugo-install-macos

assets-dev-setup:
	(cd $(THEME_DIR) && $(YARN) && npm rebuild node-sass --force)

build: build-assets
	$(HUGO) -v

build-assets:
	(cd $(THEME_DIR) && $(GULP) build)

circleci-setup: assets-dev-setup
	./scripts/setup.sh $(HUGO_VERSION) Linux

dev:
	$(CONCURRENTLY) "make develop-content" "make develop-assets"

develop-content:
	ENV=dev $(HUGO) server

develop-assets:
	(cd $(THEME_DIR) && $(GULP) dev)

deploy: build
	$(FIREBASE) deploy \
		--only hosting \
		--token $(FIREBASE_TOKEN) \
		--project $(FIREBASE_PROJECT)

open-site:
	open https://$(FIREBASE_PROJECT).firebaseapp.com
