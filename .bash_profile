if [ -f ~/.secrets ]; then
	source ~/.secrets
fi

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

test -e ${HOME}/.iterm2_shell_integration.bash && source ${HOME}/.iterm2_shell_integration.bash
test -f ~/.rx/shell_config && source ~/.rx/shell_config
