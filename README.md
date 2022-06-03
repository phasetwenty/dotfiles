# dotfiles

The next generation of my dotfiles management solution.

# Inspiration

Originally taken from an [Atlassian guide](https://www.atlassian.com/git/tutorials/dotfiles). I used to use a branching approach thinking that my needs would be the same per-architecture except for some small customizations. Over time I'm realizing the differences are significant and merit a new approach. My old approach is archived at [dotfiles-legacy](https://github.com/phasetwenty/dotfiles-legacy).

# Setting up a new host

Clone with this command:

    git clone --bare git@github.com:phasetwenty/dotfiles.git $HOME/.dotfiles-repo

I have the remote available as a shell variable `DOTFILES_REMOTE`. Also, `.dotfiles-repo` is a name that shows up in these instructions and in this repo.

To make running the commands easier, set an alias:

    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles-repo/ --work-tree=$HOME'

Next, check out with:

    dotfiles checkout
    
If the host has existing dotfiles, you'll need to get them out of the way (git doesn't like them). The Atlassian link has instructions for how to work around this issue. 

Last, you need to confirm which host configuration you want. By default the script will use the hostname to locate the configuration it should use. If you wish to override this behavior create a file with the desired hostname:

    echo "my host" > .chaverma-host

I recommend restarting the shell to apply the full set of dotfiles.