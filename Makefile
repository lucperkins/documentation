HUGO_VERSION = 0.36
HTMLPROOFER  = bundle exec htmlproofer
NODE_BIN     = node_modules/.bin
FIREBASE     := $(NODE_BIN)/firebase
FIREBASE_PROJECT = jaeger-docs
GULP         := $(NODE_BIN)/gulp
HUGO_THEME   := jaeger-docs
THEME_DIR    := themes/$(HUGO_THEME)
YARN         := /usr/local/bin/yarn
HUGO         := /usr/local/bin/hugo
CONCURRENTLY := $(NODE_BIN)/concurrently
WRITE_GOOD   := $(NODE_BIN)/write-good

hugo-install-macos:
	brew switch hugo $(HUGO_VERSION)

content-edit-setup: hugo-install-macos

clean:
	rm -rf public $(THEME_DIR)/data/assetHashes.json $(THEME_DIR)/static

assets-dev-setup:
	(cd $(THEME_DIR) && $(YARN) && npm rebuild node-sass --force)

build: clean build-assets build-content

build-content:
	$(HUGO) -v

build-assets:
	(cd $(THEME_DIR) && $(GULP) build)

circleci-setup: assets-dev-setup
	./scripts/setup.sh $(HUGO_VERSION) Linux

dev:
	$(CONCURRENTLY) "make develop-content" "make develop-assets"

develop-content: build-assets
	ENV=dev $(HUGO) server \
        --buildDrafts \
        --buildFuture \
        --disableFastRender \
        --ignoreCache

develop-assets:
	(cd $(THEME_DIR) && $(GULP) dev)

deploy: build
	$(FIREBASE) deploy \
		--only hosting \
		--token $(FIREBASE_TOKEN) \
		--project $(FIREBASE_PROJECT)

open-site:
	open https://$(FIREBASE_PROJECT).firebaseapp.com

htmlproofer-setup:
	gem install bundler \
        --no-rdoc \
        --no-ri
	NOKOGIRI_USE_SYSTEM_LIBRARIES=true bundle install \
		--path vendor/bundle

htmlproofer: build
	$(HTMLPROOFER) \
        --empty-alt-ignore \
        public

write-good:
	$(WRITE_GOOD) content/**/*.md
