_default:
    @{{just_executable()}} --list --unsorted --justfile {{justfile()}}

## NH Wrappers

# Update system.
[no-exit-message]
update:
    nh os switch -a -u .

# Switch to the new system
[no-exit-message]
switch:
    nh os switch .

# Activate the new system but not make it the boot default
[no-exit-message]
test:
    nh os test .

# Make the new config the boot default but not activate it
[no-exit-message]
boot:
    nh os boot .

# Open an REPL environment in the system config
[no-exit-message]
repl:
    nh os repl .

## Git Wrappers

# Create a new feature branch.
feature name:
    git switch -c {{name}}

# Finish the work in current branch and merge it to the main branch.
finish parent='main':
    #!/usr/bin/env bash
    currbr=$(git branch --show-current)
    git switch {{parent}}
    git merge $currbr
    git branch -d $currbr
