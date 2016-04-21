OSASCRIPT := $(shell command -v osascript 2> /dev/null)

all : resources/css/chickenpaint.css resources/js/chickenpaint.js
ifdef OSASCRIPT
	osascript -e 'display notification "Build successful" with title "ChickenPaint build complete"'
endif

dist : all min
	cp -a resources/ dist/chickenpaint
	cp -a lib/ dist/lib/

min : resources/js/chickenpaint.min.js

resources/js/chickenpaint.min.js : resources/js/chickenpaint.js
	cd resources/js && /usr/local/lib/node_modules/uglifyjs --compress --mangle --screw-ie8 --source-map chickenpaint.min.js.map --source-map-url chickenpaint.min.js.map --output chickenpaint.min.js chickenpaint.js 

resources/js/chickenpaint.js : js/engine/* js/gui/* js/util/* js/ChickenPaint.js
	browserify --standalone ChickenPaint --outfile $@ -d -e js/ChickenPaint.js -t /usr/local/lib/node_modules/babelify

clean :
	rm -f resources/css/chickenpaint.css resources/js/chickenpaint.js resources/js/chickenpaint.min.js resources/js/chickenpaint.min.js.map
	rm -rf dist/*

resources/css/chickenpaint.css : resources/css/chickenpaint.less
	lessc $< > $@