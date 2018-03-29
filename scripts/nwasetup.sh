#/bin/bash
set -x
set -e

NWADIR=$1
export NWADIR=${NWADIR:-"nwa-yocto-dir"}

install_some_packages() {
    echo "install some packages"
    sudo apt-get install \
	gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential \
	chrpath socat cpio python python3 python3-pip python3-pexpect \
	xz-utils debianutils iputils-ping libsdl1.2-dev xterm

    echo "install some more packages"
    sudo apt-get install \
	autoconf libtool libglib2.0-dev libarchive-dev python-git \
	xterm sed cvs subversion coreutils texi2html docbook-utils \
	python-pysqlite2 help2man make gcc g++ desktop-file-utils \
	libgl1-mesa-dev libglu1-mesa-dev mercurial automake groff \
	curl lzop asciidoc u-boot-tools dos2unix mtd-utils pv \
	libncurses5 libncurses5-dev libncursesw5-dev libelf-dev
}


setup_git_user_stuff() {
    gun=$(git config --global --get user.name)
    test -n "$gun" ||
	echo 'you should set a git username, e.g.: \
	    git config --global user.name "Fred Flintstone'

    gue=$(git config --global --get user.email)
    test -n "$gue" ||
	echo 'you should set a git email, e.g.: \
	    git config --global user.email "fred@flintstone.org'
}

install_repo() {
    type repo && return
    echo "no repo in PATH installing into ~/bin"
    echo "make sure to add ~/bin to PATH if it is not already there"
    mkdir -p ~/bin
    curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    chmod +x ~/bin/repo 
}

run_repo_init() {
    echo "setting up in $NWADIR"
    mkdir -p $NWADIR
    cd $NWADIR
    repo init -u https://github.com/varigit/variscite-bsp-platform.git -b rocko
    repo sync -j4
}

install_some_packages
setup_git_user_stuff
install_repo
run_repo_init
