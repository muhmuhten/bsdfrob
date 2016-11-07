it:	build

build:
	sh util/build.sh

install:
	sh util/install.sh

repatch:
	sh util/repatch.sh

clean:
	git clean -xdf
	git submodule foreach git clean -xdf
