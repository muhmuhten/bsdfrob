it:	build

build:
	sh util/build.sh

install:
	sh util/install.sh

clean:
	git clean -xdf
	git submodule foreach git clean -xdf
