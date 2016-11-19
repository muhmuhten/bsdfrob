it:	build

build:
	sh util/build.sh

install:
	xargs sh util/install.sh host < /media/host/quirks || sh util/install.sh jail

repatch:
	sh util/repatch.sh

clean:
	git clean -xdf
	git submodule foreach git clean -xdf
