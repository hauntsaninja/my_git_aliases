alias ga='git add'
alias fga='git add $(git ls-files --modified | fzf --preview "git diff --color -- {1}")'
alias gap='git add --patch'
alias gau='git add --update'

alias gb='git branch'
alias gbc='git checkout -b'
alias gbcu='git checkout --track @{u} -b'
alias gbd='git branch --delete --force'
alias fgbd='git branch --delete --force $(git branch --verbose | fzf --preview "pyp \"{}[1:].split()[0]\" | xargs git log --stat --color" | pyp "x[1:].split()[0]")'
alias gbm='git branch --move'
alias gbv='git branch --verbose'
alias gbvv='git branch --verbose --verbose'
alias gbvl='git show-branch --topics origin/master'

gbgc () {git branch --merged origin/master | grep -v '\*\|master' | xargs -r git branch -d}
gbgcm () {
    for b in $(git branch | grep -v '\*\|master'); do
        upstream=$(git rev-parse $b@{u} 2> /dev/null || echo 'origin/master')
        [[ -n $(git merge-tree $(git merge-base $upstream $b) $upstream $b) ]] || git branch -D $b
    done
}

alias gbl='git blame -b -w'

alias gc='git commit --verbose'
alias gc!='git commit --verbose --amend'
alias gcn!='git commit --verbose --no-edit --amend'
alias gca='git commit --verbose --all'
alias gca!='git commit --verbose --all --amend'
alias gcan!='git commit --verbose --all --no-edit --amend'

gcamendto () {c=`git rev-parse "$1"`; git commit --fixup "$c" && GIT_SEQUENCE_EDITOR=true git rebase --interactive --autosquash "$c^"}

alias gcl='git clone'

alias gco='git checkout'
alias fgco='git checkout $(git branch --verbose | fzf --preview "pyp \"{}[1:].split()[0]\" | xargs git log --stat --color"| pyp "x[1:].split()[0]")'
alias gcom='git checkout master'
alias gcoi='git checkout --'  # look into git restore at some point
alias fgcoi='git checkout $(git ls-files --modified | fzf --preview "git diff --color -- {1}")'

alias gcp='git cherry-pick'
fgcp () {git cherry-pick $(git log --branches --not --remotes --decorate --color --oneline $@ | fzf --ansi --preview 'git show --color {1}' | pyp 'x.split()[0]')}
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

alias gd='git diff'
alias gdc='git diff --cached'

alias gf='git fetch'
alias gfu='git fetch upstream'

alias glg='git log --stat'
fglg () {git log --color --oneline $@ | fzf --ansi --reverse --preview 'git show --color {1}' | pyp 'x.split()[0]'}
alias glgp='git log --stat --patch'
alias glgpa='git log --stat --patch --author'

alias glgo="git log --date=local --pretty='%C(white)%h%C(yellow)%d %Cred%>|(30)%an%Creset: %s %<|(90)%C(yellow)(%cd)'"
alias glgoa="git log --date=local --pretty='%C(white)%h%C(yellow)%d %Cred%>|(30)%an%Creset: %s %<|(90)%C(yellow)(%cd)' --author"

alias gl='git pull'
alias glu='git pull upstream $(git symbolic-ref --short HEAD)'
alias gp='git push'
alias gpoh='git push origin HEAD'

glall () {
    cb=$(git symbolic-ref --short HEAD)
    git fetch
    for b in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
        git rev-parse $b@{u} > /dev/null 2>&1 && {! git merge-tree $(git merge-base $b@{u} $b) $b@{u} $b | grep -q '<<<<<<<'} && git checkout $b && {git rebase FETCH_HEAD || git rebase --abort}
    done;
    git checkout $cb
}

alias gr='git reset'

alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'

alias grlg='git reflog'
alias fgrlg='git reflog --color --decorate=short | pyp -b "h = set()" "c = x.split()[0]" "if c not in h: print(x)" "h.add(c)" | fzf --ansi --reverse --preview "git show --color {1}" | pyp "x.split()[0]"'

# Need to install git-revise for this to work
alias grv='git revise'
alias fgrv='git-revise $(fglg)'
alias grvi='git-revise --interactive'
alias grvh='git-revise --help'

alias gs='git status'
alias gss='git status --short'

alias gsh='git show'

alias gst='git stash'
alias gstd='git stash drop'
alias gstk='git stash --keep-index'
alias gstl='git stash list --patch'
alias gstp='git stash pop'
