it:	build

build:
	exec sh util/build.sh

clean:
	git clean -xdf
	git submodule foreach git clean -xdf
