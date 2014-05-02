NM = ./node_modules

JADE = $(NM)/.bin/jade
STYLUS = $(NM)/.bin/stylus
SERVER = $(NM)/.bin/http-server
SOURCE = ./src
PUBLIC = ./public

# jade
JADE_FILES := $(wildcard $(SOURCE)/*.jade)
HTML_FILES := $(subst $(SOURCE)/,$(PUBLIC)/,$(JADE_FILES:.jade=.html))

# styles
STYLUS_FILE := $(SOURCE)/stylesheets/style.styl
CSS_FILE := $(PUBLIC)/style.css
CSS_ALL := $(PUBLIC)/all.css
NORMALIZE := $(NM)/normalize.css/normalize.css
FONTS := $(SOURCE)/stylesheets/fonts.css

all: clean build;

build: create-folder $(HTML_FILES) $(CSS_FILE);

$(PUBLIC)/%.html: $(SOURCE)/%.jade
	@echo '  jade <' $(notdir $<) '>' $(notdir $@)
	@$(JADE) < $< > $@

$(CSS_FILE): $(STYLUS_FILE)
	@$(STYLUS) $< -o $(PUBLIC) -u nib
	@cat $(FONTS) > $(CSS_ALL)
	@cat $(NORMALIZE) >> $(CSS_ALL)
	@cat $(CSS_FILE) >> $(CSS_ALL)

create-folder:
	@mkdir -p $(PUBLIC)

install-watch:
	@npm install git://github.com/visionmedia/watch.git
	@cd $(NM)/watch;\
	make install

watch:
	watch make build

server:
	@$(SERVER) $(PUBLIC)

clean:
	@if [ -d $(PUBLIC) ]; then\
		rm -r $(PUBLIC);\
	fi

.PHONY: build clean
