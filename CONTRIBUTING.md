# Contributing

### First off, thank you for considering contributing to Bash-Snippets.

#### Where do I go from here?

If you've noticed a bug or have a question, search the <a href="https://github.com/alexanderepstein/Bash-Snippets/issues">issue tracker</a> to see if someone else in the community has already created a ticket. If not, go ahead and <a href="https://github.com/alexanderepstein/Bash-Snippets/issues/new">make one</a>!

#### Otherwise if implementing a fix, feature or new component go through these steps
#### 1. Fork & Clone The Repository
* Fork the repository
* It is assumed you are on either a Unix or Linux system in which are there are no dependencies
* To download the full source code after forking
```bash
git clone https://github.com/yourusernamehere/Bash-Snippets
```


#### 2. Implement your fix, feature or new component

###### Fix/Feature
At this point, you're ready to make your changes!

###### New Component
* Decide on a short but sweet name for your tool
* Create a folder in the Bash-Snippets root directory named after the tool
* Copy over the Bash-Snippets tool [skeleton](https://github.com/alexanderepstein/Bash-Snippets/blob/master/skeleton) to the newly created folder
* Rename the skeleton in the new directory to the name of the tool
* Using newly copied over file as a basis (with the name of your tool) code your new component!

Feel free to ask for help; everyone is a beginner at first :smile_cat:
Make sure to make your commit messages informative and concise.


#### 3. Check The Script Runtime

If you changed the weather script for example try running it and see if it works as intended. Run ```bats tests``` when inside the Bash-Snippets directory to test the tools.
If you added a new script/tool test it to see if it works.

#### 4. Create A Pull Request

First make sure to commit and push your changes to your forked repository.
Check to see if there are any conflicts with the main repository and your fork.
If there are none submit the request and give details as to what you changed or added.

#### 5. Bask In All The Glory Of Adding To A FOSS Application
![Had to do it to em](https://68.media.tumblr.com/2dfc3369827df9b981e111d7fd8fc732/tumblr_mvemcyarmn1rslphyo1_400.gif)


# Style Guide
## *Before* contributing, please implement the following style guidelines

## Function

function declaration should be in Camel_Case, and library function declaration should prefixed with underscore '_'
use two blank lines separator between each function declaration

Each function declaration should have the following comment documentation

1. brief description
2. Globals: global variables function relays on
3. Inputs: argument(s) passed, else nothing
4. Outputs: write to file, modifies global variable, else nothing
5. Returns: function return(s) value, else nothing

Each function should followed by 'end of function FUNC_NAME'


### Example:

The following example declare shared function `Foo`

```sh
# print Foo n times
# Globals: nothing
#		leave blank line for readability
# Inputs:
# 	n: number of times to print 'Foo'
#
# Outputs: nothing
# Returns: nothing
_Foo() {

	# leave one blank line after openening and before closing curly bracket
	n="$1"	# variable declaration/assignment should placed at the beginning

	# function body
	while (( n-- )); do
		echo "Foo"
	done

}	# end of function _Foo


```

## Variable

predefined global variables should placed at the beginning of script in ALL_CAPS

local variables in lower_case

you should place variables declaration at start the start of function or code block


### Example:

```sh
if $bar; then
	i=1
	j=3

	echo "\$i: i\t\$j: $j"
fi
```

> [!NOTE]
> - By default variables in bash are global, except when you declare them otherwise with `local bar` or `declare bar`
> - Please use tabs instead of whitespace for indentation

