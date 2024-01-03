# Shantanu's git aliases
# https://github.com/hauntsaninja/my_git_aliases

alias ga='git add'
alias fga='git add $(git ls-files --modified --other --exclude-standard | fzf -m --preview "git diff --color -- {1}")'
alias gap='git add --patch'
alias gau='git add --update'
alias fgau='git add $(git ls-files --modified | fzf -m --preview "git diff --color -- {1}")'

alias gb='git branch'
alias gbc='git checkout -b'
alias gbcu='git checkout --track @{u} -b'
alias gbd='git branch --delete --force'
alias fgbd='git branch --delete --force $(git branch --sort=-authordate --color --verbose | fzf -m --ansi --preview "echo {} | pyp \"lines[0][1:].split()[0]\" | xargs -IXXX git log --stat --color -n 10 XXX --" | pyp "x[1:].split()[0]")'
alias gbm='git branch --move'
alias gbu='git branch --set-upstream-to'
alias gbv='git branch --verbose'
alias gbvv='git branch --verbose --verbose'
alias gbvl='git show-branch --topics origin/$(gbmaster)'

gbmaster () {
    [ $(git rev-parse --verify main 2> /dev/null) ] && echo main || echo master
}

# Need to install git-delete-merged-branches for this to work
alias gbgcd='git-delete-merged-branches --effort 3 -b $(gbmaster) --yes'
# In case you don't have git-delete-merged-branches installed
gbgc () {git branch --merged origin/$(gbmaster) | grep -v '\*\|master|main' | xargs -r git branch -d}
gbgcm () {
    for b in $(git branch | grep -v '\*\|master|main'); do
        upstream=$(git rev-parse $b@{u} 2> /dev/null || echo "origin/$(gbmaster)")
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

alias gcl='git clone'

alias gco='git checkout'
fgco () {git checkout $(git branch --sort=-authordate --color --format '%(HEAD) %(align:20)%(refname:short)%(end) %(color:dim)%(align:9)%(upstream:track)%(end) %(color:reset)%(contents:subject)' | fzf --ansi $([[ -z "$1" ]] && echo "" || echo "--query $@") --preview 'git log --stat --color -n 10 $(echo {} | pyp "lines[0][1:].split()[0]") --' | pyp "x[1:].split()[0]")}
alias gcom='git checkout main 2> /dev/null || git checkout master'
alias gcoi='git checkout --'  # look into git restore at some point
alias fgcoi='git checkout $(git ls-files --modified | fzf -m --preview "git diff --color -- {1}")'

alias gcp='git cherry-pick'
fgcp () {git cherry-pick $(git log --branches --not --remotes --decorate --color --oneline $@ | fzf --ansi --preview 'git show --color {1}' | pyp 'x.split()[0]')}
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

alias gd='git diff'
alias gdc='git diff --cached'

alias gf='git fetch'
alias gfu='git fetch upstream'

alias glg='git log --stat'
fglg () {git log --color --oneline $@ | fzf --ansi --reverse --no-sort --preview 'git show --color {1}' | pyp 'x.split()[0]'}
alias glgp='git log --stat --patch'
alias glgpa='git log --stat --patch --author'

alias glgo="git log --date=local --pretty='%C(white)%h%C(yellow)%d %Cred%>|(30)%an%Creset: %s %<|(90)%C(yellow)(%cd)'"
alias glgoa="git log --date=local --pretty='%C(white)%h%C(yellow)%d %Cred%>|(30)%an%Creset: %s %<|(90)%C(yellow)(%cd)' --author"

alias gl='git pull'
alias glu='git pull upstream $(git symbolic-ref --short HEAD)'
alias gloh='git pull origin --rebase $(git symbolic-ref --short HEAD)'
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

alias grm='git remote -vv'
grmau () {
    [[ -n $1 ]] || {echo 'Usage: grmau $upstream [$remote=origin]'; return 1}
    remoteurl=$(git remote -vv | grep ${2:-origin} | grep fetch | pyp 'x.split()[1]')
    git remote add upstream $(pyp "re.sub('(?<=github.com[/:])([^/]+)', '$1', '$remoteurl')")
}
grmssh () {
    remoteurl=$(git remote -vv | grep ${1:-origin} | grep fetch | pyp 'x.split()[1]' | pyp 're.sub("https://github.com", "git@github.com", x)')
    git remote set-url ${1:-origin} $remoteurl
}

# Need to install git-revise for these to work
alias grv='git revise'
alias fgrv='git-revise $(fglg)'
alias grvi='git-revise --interactive'
alias grvh='git-revise --help'
# In case you don't have git-revise installed
gcamendto () {
    c=`git rev-parse "$1"`
    git commit --fixup "$c" && GIT_SEQUENCE_EDITOR=true git rebase --interactive --autosquash "$c^"
}

alias gs='git status'
alias gss='git status --short'

alias gsh='git show'

alias gst='git stash'
alias gstd='git stash drop'
alias gstk='git stash --keep-index'
alias gstl='git stash list --patch'
alias gstp='git stash pop'
fgstl () {
    git stash list --format="%gd %cr" | fzf -m --ansi --preview "git stash show --color {1}" | pyp "x.split()[0]"
}
fgstd () {
    c=$(fgstl)
    [[ -n "$c" ]] && git stash drop $c
}
