HUGO_VERSION := 0.36
FIREBASE     := node_modules/.bin/firebase
FIREBASE_PROJECT := jaeger-docs
GULP         := node_modules/.bin/gulp
HUGO_THEME   := jaeger-docs
THEME_DIR    := themes/$(HUGO_THEME)
YARN         := /usr/local/bin/yarn
HUGO         := /usr/local/bin/hugo

hugo-install-macos:
	brew switch hugo $(HUGO_VERSION)

content-edit-setup: hugo-install-macos

assets-dev-setup:
	(cd $(THEME_DIR) && $(YARN))

build: build-assets
	$(HUGO) -v

build-assets:
	(cd $(THEME_DIR) && $(GULP) build)

circleci-setup: assets-dev-setup
	./scripts/hugo-install.sh $(HUGO_VERSION) Linux

develop-content: build-assets
	ENV=dev $(HUGO) server --ignoreCache --disableFastRender

develop-assets:
	(cd $(THEME_DIR) && $(GULP) dev)

deploy: build
	$(FIREBASE) deploy \
		--only hosting \
		--token $(FIREBASE_TOKEN) \
		--project $(FIREBASE_PROJECT)

open-site:
	open https://$(FIREBASE_PROJECT).firebaseapp.com
