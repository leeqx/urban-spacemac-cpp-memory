yum install -y centos-release-scl
yum install -y llvm-toolset-7.0-clang-tools-extra
gcc --version
echo "use newer gcc version..."
source /opt/rh/devtoolset-8/enable
gcc --version

function set_env() {
	old_dir=$PWD
	if [ ! -e "~/.zshrc" ];then
		ln -sf $PWD/.zshrc ~/.zshrc
	fi
	if [ ! -e "~/.tmux.conf" ];then
		ln -sf $PWD/.tmux.conf ~/.tmux.conf
	fi
	if [ ! -e "~/bin" ];then
		ln -sf $PWD/bin ~/
	fi
	if [ ! -e "~/.emacs.d" ];then
		ln -sf $PWD/.emacs.d ~/
	fi
	cd $old_dir
}

function build_ccls() {
	old_dir=$PWD
	exist=`which ccls|grep -v no`
	if [  "x" = "x$exist" ];then
		echo "build ccls,gcc must support c++17"
		cd extra_tools/ccls
		sh build_ccls_llvm.sh
		if [ $? -eq 0 ];then
			echo "build success;switch to root and then run make install: cd  ccls/Release && make install"
		else
			echo "cmake fail"
		fi
	else
		echo "ccls exist"
	fi
	cd $old_dir
}

function set_gdb() {
	old_dir=$PWD
	if [ ! -e ~/peda/peda.py ];then
		git clone https://github.com/longld/peda.git ~/peda
		echo "source ~/peda/peda.py" >> ~/.gdbinit
	fi
	cd $old_dir
}
function build_bear() {
	old_dir=$PWD
	yum update
	yum -y install sqlite3-dbf.x86_64
	yum -y install sqlite-devel.x86_64
	cd extra_tools/Bear
	mkdir build && cd build
	cmake ../
	make -j32
	cd $old_dir
}
set_gdb
set_env
build_bear
build_ccls

