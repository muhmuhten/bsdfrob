it:	build

build:
	sh util/build.sh

install:
	sh util/install.sh

install-jail:
	sh util/install.sh jail

clean:
	git clean -xdf
	git submodule foreach git clean -xdf
