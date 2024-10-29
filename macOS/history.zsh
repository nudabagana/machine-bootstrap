# Set the maximum number of history entries saved
HISTSIZE=10000         # Number of commands to remember in the current session
SAVEHIST=10000        # Number of commands to save in the history file
HISTFILE=~/.zsh_history # File where command history is saved

# Other useful options
setopt append_history     # Append history to the history file, don't overwrite it
setopt histignoredups     # Ignore duplicate commands in history
setopt histfindno_dups    # Don't add to history if it's a duplicate of the last command
setopt share_history       # Share command history across all sessions