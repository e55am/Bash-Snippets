#!/usr/bin/env bash
# Author: Alexander 'Epstein https://github.com/alexanderepstein'
# Refactor: e55am 'https://github.com/e55am'

# TODO
# tools array should be populated with `find scripts -type -f -executable`

# exit on error
set -e

### Global vars
# DIRECTORY var will make sure wherever user CWD, installer will work
DIRECTORY="${0%/*}"	# current repo directory
PROGRAM="${0##*/}"	# bash version of basename
LIB="$DIRECTORY/bash-snippets.lib"
DETAIL=false

prefix="/usr/local"
bin_path="$prefix/bin"
man_path="$prefix/share/man/man1"
interactive=false	# prompt before each install
all=false	# install all tools

# TODO
# implement platform check on script/tool level will result cleaner install script
# (e.g. abort from program if platform incompatible)
declare -a tools=(bak2dvd bash-snippets cheat cloudup crypt cryptocurrency currency geo gist lyrics meme movies newton pwned qrify short siteciphers stocks taste todo transfer weather ytview)
declare -a extraLinuxTools=(maps)
declare -a extraDarwinTools
usedGithubInstallMethod="0"


# source library, and exit on error
source "$LIB" || {
	echo "$PROGRAM: failed to source '$LIB' library" >&2
	exit 3
}


# print help message
#
# Globals:
# 	PROGRAM
#
# Inputs: nothing
# Outputs: nothing
# Returns: nothing
Help() {
	cat <<- EOF
		$PROGRAM [-i|--interactive] [-p|--prefix DIRECTORY] [-h|-u|-U|-v|-V] {all,TOOL ...}
		install all/some of bash-snippets tools

		Option
		  -h, --help		display this help and exit
		  -i, --interactive	prompt before install tool
		  -p DIR, --prefix DIR
		 	install Bash-Snippets tool(s) under DIR (default is /usr/local)
		  -u, --usage		display synopsis/brief usage and exit
		  -U, --update		update Bash-Snippets
		  -V, --version		print version and exit
	EOF

}	# end of function Help


# conform user choice
#
# Globals: nothing
# Inputs:
# 	tool name
# Outputs: nothing
#
# Returns:
# 	0 (true) if user choice was 'Y' or 'y' (default Y)
# 	non-zero (false) otherwise
Confirm_Install() {

	local tool="$1"

	echo "The following tool will be installed: $tool"
	read -p "Do you want to continue? [Y/n] " answer
	answer="${answer:-Y}"

	[[ "$answer" == [Yy] ]]

}	# end of function Confirm_Install


# copy tool to bin_path directory
#
# Globals:
# 	PROGRAM
#
# Inputs:
# 	tool: tool name
#
# Outputs: nothing
# Returns: nothing
Install_Tool() {

	local tool="$1"

	# TODO
	# - replace cd `DIRECTORY/tool` with `DIRECTORY/scripts`
	cd "$DIRECTORY/$tool"
	echo "Installing $tool..."
	chmod a+x "$tool"
	cp "$tool" -t "$bin_path" &> /dev/null || {
		_Echo_Err "$PROGRAM: failed to copy '$tool' to '$bin_path'"
	}
	echo "$tool installed"
	cd .. # to repo directory

}	# end of function Install_Tool


# copy all tools to bin_path
#
# Globals:
# 	tools
#
# Inputs: nothing
# Outputs: nothing
# Returns: nothing
Install_All_Tools() {

	for tool in "${tools[@]}"; do
		if $interactive; then
			(Confirm_Install "$tool") && Install_Tool "$tool"
		else
			Install_Tool "$tool"
		fi
	done

}	# end of function Install_All_Tools


# copy Man page to man_path
#
# Globals:
# 	PROGRAM
# 	man_path
#
# Inputs: nothing
# Outputs: nothing
# Returns: nothing
Copy_Man_Page() {

	cp "$DIRECTORY/bash-snippets.1" -t "$man_path" || {
		_Echo_Err "$PROGRAM: failed to copy man page"
	}

}	# end of function Copy_Man_Page


# parse cli option
while getopts ':-:ahip:uUV' opts; do
	case "$opts" in
		a ) all=true ;;
		h ) Help; exit 0 ;;
		i ) interactive=true ;;
		p )
			prefix="$OPTARG"
			bin_path="$prefix/bin"
			man_path="$prefix/share/man/man1"
		;;

		u ) _Usage; exit 0 ;;
		U ) _Update ;;
		V ) echo "$VERSION"; exit 0 ;;

		# parse long option--------------------------------------
		- )
			case "$OPTARG" in
				all ) all=true ;;
				help )
					Help
					exit 0
				;;

				interactive ) interactive=true ;;
				prefix )
					shift
					prefix="$1"
					bin_path="$prefix/bin"
					man_path="$prefix/share/man/man1"

					## TODO
					## move the following block into function and test it
					#
					# # check if argument is path
					# if [[ $prefix =~ ^(\.|\.\.)?/?.* ]]; then
					# 	bin_path="$prefix/bin"
					# 	man_path="$prefix/share/man/man1"
					# else
					# 	echo "$PROGRAM: invalid path"
					# 	exit 1
					# fi
				;;

				update ) _Update ;;
				usage ) _Usage; exit 0 ;;
				version ) echo "$VERSION"; exit 0 ;;
				* )
					_Echo_Err "$PROGRAM: Invalid option '--$OPTARG'"
					exit 1
				;;
			esac
		;;
		#--------------------------------------------------------

		: )
			_Echo_Err "Option '-$OPTARG' requires an argument."
			_Try_Help
			exit 1
		;;

		\?)
			_Echo_Err "$PROGRAM: Invalid option '-$OPTARG'"
			_Try_Help
			exit 1
		;;
	esac
done
shift $(( OPTIND - 1 ))


## check user permission
[[ -d $prefix ]] || {
	_Echo_Err "$PROGRAM: '$prefix' is not directory"
	exit 1
}

[[ -w $prefix && -x $prefix ]] || {
	_Echo_Err "$PROGRAM: cannot install/update: permission denied"
	exit 2
}

[[ $# == 0 ]] && {
	(Confirm_Install "all ${#tools[@]} tools") && all=true
}

for i in "$bin_path" "$man_path"; do
	[[ -d "$i" ]] || mkdir -p "$i"
done


# TODO
# once we place all script in one directory call Install_Tool function
# library is necessary dependency
cp "$LIB" -t "$bin_path"
Copy_Man_Page

if $all; then
	Install_All_Tools
else
	for tool in "$@"; do 
		# check if tool name is valid
		if [[ "${tools[*]}" == *$tool* ]]; then
			Install_Tool "$tool"
		else
			_Echo_Err "E: cannot install $tool: no such tool"
			_Echo_Err "skipping $tool"
		fi
	done
fi


# NOTE
# currently i have no idea how apt install this package from GitHub (e.g. apt internal work)
# feel free to remove/edit the following block
# if [[ $usedGithubInstallMethod == "1" ]]; then
# 	Copy_Man_Page
# else
# 
# 	cat <<- EOF
# 		$PROGRAM: warning: It appears you have installed bash-snippets through a package manager, 
# 		you must update it with the respective package manager.
# 	EOF
# 	exit 1
# fi

echo "Bash Snippets version $VERSION"
echo "https://github.com/alexanderepstein/Bash-Snippets"
exit 0

