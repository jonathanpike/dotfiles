# These are my dotfiles.  There may be many like them, but these are mine. 

## Running

```
git clone https://github.com/jonathanpike/dotfiles ~/.dotfiles
cd ~/.dotfiles;
. setup.sh;
```

The setup script will detect whether you're running either OS X or Ubuntu, and change the package manager accordingly. 

Setup _should_ be idempotent, but I don't guarantee anything! 


## Credits
- Setup Script and Function Library -- [Adam Eivy](https://github.com/atomantic/dotfiles)
- vimrc -- [Thoughtbot](https://github.com/thoughtbot/dotfiles)
- Idea for separate OS X and Ubuntu Configs -- ["Cowboy" Ben Alman](https://github.com/cowboy/dotfiles)