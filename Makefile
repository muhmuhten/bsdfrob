it:	build

build:
	sh util/build.sh

clean:
	git clean -xdf
	git submodule foreach git clean -xdf
