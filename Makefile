HUGO_VERSION = 0.37.1
HTMLPROOFER  = bundle exec htmlproofer
NODE_BIN     = node_modules/.bin
HUGO_THEME   = jaeger-docs
THEME_DIR    := themes/$(HUGO_THEME)
GULP         := $(NODE_BIN)/gulp
CONCURRENTLY := $(NODE_BIN)/concurrently
WRITE_GOOD   := $(NODE_BIN)/write-good

# Verify proper Node version
NODE_VERSION=$(shell node -v)
ifeq ($(patsubst v8.%,v8,$(NODE_VERSION)), v8)
	NODE_8=true
else
	NODE_8=false
endif

check-node-8:
	@$(NODE_8) || echo Build requires Node 8.x
	@$(NODE_8) && echo Building using Node 8.x

macos-setup: check-node-8
	brew switch hugo $(HUGO_VERSION) && brew link --overwrite hugo
	npm install
	(cd $(THEME_DIR) && npm install)

netlify-setup:
	(cd $(THEME_DIR) && npm install)

clean:
	rm -rf public $(THEME_DIR)/data/assetHashes.json $(THEME_DIR)/static

build-content:
	hugo -v \
		--theme $(HUGO_THEME)

build-assets:
	(cd $(THEME_DIR) && $(GULP) build)

build: clean build-assets build-content

netlify-build: netlify-setup build

dev:
	$(CONCURRENTLY) "make develop-content" "make develop-assets"

develop-content: build-assets
	hugo server \
		--theme $(HUGO_THEME) \
        --buildDrafts \
        --buildFuture \
        --disableFastRender \
        --ignoreCache

develop-assets:
	(cd $(THEME_DIR) && $(GULP) dev)

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
