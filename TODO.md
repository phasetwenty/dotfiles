1. Need to figure out how to set up and switch config files, e.g., `.my.cnf`
2. Implement a check-env command which can be used to suss out problems rather than checking at startup. This will improve startup time
    1. An example case is for missing the right version of `ls`

```
   LS_CMD_set () {
       # Ensures that our `ls` command is the one that can group directories. If it's not available, an error message is
       # printed. End result is that LS_CMD is set.
       #
       local path=$(type -P gls)
       if [ $? ]; then
           export LS_CMD="$path -G --group-directories-first --color=always"
           return
       fi
          >&2 echo "gls missing; no directory grouping is possible."
       export LS_CMD="/bin/ls -G --color=always"
   }
```