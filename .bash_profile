if [ -f ~/.secrets ]; then
	source ~/.secrets
fi

test -f ~/.rx/shell_config && source ~/.rx/shell_config

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
