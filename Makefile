# import definitions of the main repository
STROM_BUILD_ROOT := pg_strom
PGSTROM_MAKEFILE_ONLY_PARAMDEF = 1
include pg_strom/doc/Makefile

WEB_FILES = $(notdir $(HTML_SOURCES:.src.html=.html))
WEB_IMAGES = $(addprefix figs/,$(notdir $(IMAGE_SOURCES)))
WEB_TEMPLATE = web-template.src.html
NEWS_SOURCE = $(shell ls news/*.txt -r)

EXTRA_CLEAN += $(WEB_FILES) $(WEB_IMAGES)

web-pages: about.html $(WEB_FILES) $(WEB_IMAGES)

about.html: news/about.src.html $(NEWS_SOURCE)
	TEMP=`mktemp` && news/news_gen.sh $(NEWS_SOURCE) > $$TEMP && \
	env NEWS_RELEASE_TO_BE_REPLACED="`cat $$TEMP`" envsubst < news/about.src.html > about.html

$(WEB_FILES): $(HTML_SOURCES) $(WEB_TEMPLATE)
	echo $(WEB_FILES)
	echo $(WEB_SOURCES)
	echo $@
	$(PYTHON_CMD) $(MENUGEN_PY)	\
		-t $(WEB_TEMPLATE)	\
		-v '$(PGSTROM_VERSION)'	\
		-m $(@:%.html=pg_strom/doc/%.src.html) $(HTML_SOURCES) > $@

$(WEB_IMAGES): $(IMAGE_SOURCES)
	cp -f $(addprefix $(STROM_BUILD_ROOT)/doc/html/,$@) $@

clean:
	$(MAKE) -C $(STROM_BUILD_ROOT) clean
	rm -f $(WEB_FILES) $(WEB_IMAGES) about.html

.PHONY: web_pages
