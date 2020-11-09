export PATH=~/work/arcanist/bin:$PATH;
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$HOME/work/web/common/yqg-cli/bin:$PATH
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
export NVM_DIR="/Users/yu/.nvm"  # 注意：把 panezhang 替换成你自己的用户名
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
nvm use stable
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
alias mysql='/usr/local/opt/mysql@5.7/bin/mysql'
alias mysql.server='/usr/local/opt/mysql@5.7/bin/mysql.server'
alias flyjooq='mysql.server start && cd ~/work/yqg_oa/oa-core && mvn initialize flyway:migrate && mvn initialize jooq-codegen:generate && cd -'
alias flymock='cd ~/work/yqg_oa/oa-core && mvn initialize flyway:migrate -Pmock && mvn initialize jooq-codegen:generate && cd -'
alias gd1='git diff HEAD~1'
alias gd1ns='git --no-pager diff HEAD~1 --name-status'
alias gd2='git diff HEAD~2'
alias gt='git log --format="%Cred%h %Cred%d %Creset%s %Cgreen%an %Cblue%cd " --graph --color --all --decorate --date=format:%Y-%m-%d\ %H:%M:%S'
alias grm='git rebase master'
AUTHOR='xiaodongyu'
alias glm='git log --format=%s --author=$AUTHOR'
alias glmf='git log --author=$AUTHOR'
alias gprm='gco master && gpr'
alias gac='gaa && gca!'
alias gacn='gaa && gca --no-verify'
alias glp='git --no-pager log --format="%Cblue%ci %Cred%h %Creset%s %Cgreen%an"'
alias glpwd='git --no-pager log --format="%Cblue%ci %Cred%h %Creset%s %Cgreen%an %Creset%<(8,ltrunc)%b"'
alias glpm="git --no-pager log --format='%Cblue%ci %Cred%h %Creset%s %Cgreen%an' --author=$AUTHOR"
alias glpcp='glp --cherry-pick --right-only --no-merges'
alias glpcpwd='glpwd --cherry-pick --right-only --no-merges'
alias bwg='ssh -p 28769 root@bwg.yuxd.me'
#bwg root password: STomlH2f88gT

alias mysql-oa-local='mysql -uroot --password= yqg_oa_dev'
alias v.='vim .'
alias vim.='vim .'
alias v='vim'
alias gr='grep -r --color --exclude-dir={node_modules,build,log,.idea,.git}'
alias grf='grep -rF --color --exclude-dir={node_modules,build,log,.idea,.git}'
alias ns='NODE_OPTIONS="--max-old-space-size=4096" npm start'
alias nsp='ns --prefix'
alias oa='cd ~/work/web/react/oa'
alias admin='cd ~/work/web/yqd_web_admin'
alias gaf='cd ~/work/web/vue/gaf'
alias spa='cd ~/work/web/vue/spa'
alias ssr='cd ~/work/web/vue/ssr'
alias cli='cd ~/work/web/common/yqg-cli'
alias util='cd ~/work/web/common/yqg-util'
alias guard='cd ~/work/web/yqg-guard'
alias baseui='cd ~/work/web/vue/base-ui'
alias oas='ttab -w "ns --prefix ~/work/web/react/oa"'
alias mayuri='cd ~/work/web/vue/spa/projects/yqg-mayuri'
alias mayuris='ttab -w "ns --prefix ~/work/web/vue/spa/projects/yqg-mayuri-api" && ttab -w "ns --prefix ~/work/web/vue/spa/projects/yqg-mayuri"'
alias vote='cd ~/work/web/vue/spa/projects/yqg-vote'
alias votes='mayuris && ttab -w "ns --prefix ~/work/web/vue/spa/projects/yqg-vote"'
alias startmongo='sudo mongod'
alias upvimrc='find ~/.vim_runtime/sources_non_forked -type d -depth 1 -exec echo {} \; -exec git -C {} remote -v \; -exec git -C {} pull \;'
alias upcode='find ~/work/web ~/work/web/common ~/work/web/react ~/work/web/vue -type d -depth 1 -exec echo {} \; -exec git -C {} checkout master \; -exec git -C {} pull --rebase \; && git -C ~/work/yqg_oa pull --rebase'
alias scpcd='scp -r ~/work/web/vue/rising-sun/build/* root@47.94.131.251:/var/www/site/' # Cdifa2009
alias antd="rm -rf node_modules/@yqg/vue/antd && cp -rf ~/work/web/common/yqg-util/packages/@yqg/vue/antd node_modules/@yqg/vue && rm -rf node_modules/@yqg/vue/ytalk && cp -rf ~/work/web/common/yqg-util/packages/@yqg/vue/ytalk node_modules/@yqg/vue"
alias resource="rm -rf node_modules/@yqg/resource && cp -rf ~/work/web/common/yqg-util/packages/@yqg/resource node_modules/@yqg/resource"
alias rcli="rm -rf node_modules/@yqg/cli/bin && cp -rf ~/work/web/common/yqg-cli/bin node_modules/@yqg/cli/bin"


glpcpgb() {
    echo "glpcpwd ${1} | grep '基础框架\|${2}'"
    glpcpwd ${1} | grep "基础框架\|${2}"
}

replace() {
    find ${1} -type file -exec sed -i '' s/${2}/${3}/g {} + 
}

weekly() {
    local DATESTR=${1:-`date -v-mon +%Y%m%d`}
    local SECONDS=`date -jf %Y%m%d ${DATESTR} +%s`
    local SINCE=`expr $SECONDS - 3600 \* 24`
    DIR=~/work/weekly
    FILENAME=$DIR/$DATESTR-$AUTHOR.md
    echo $'# @xiaodongyu\n\n### 本周主要工作\n\n#### oa\n\n' > $FILENAME
    cd ~/work/web/react/oa
    gprm
    glm --since=$SINCE | sed -E "s/^\[OA FE\]//g" | sed -E "s/^ ?/- /g" >> $FILENAME
    cd -
    cd ~/work/yqg_oa
    gprm
    glm --since=$SINCE | sed -E "s/^\[yqg_oa\]//g" | sed -E "s/^ ?/- /g" >> $FILENAME
    cd -
    echo $'\n#### complaint-app\n' >> $FILENAME
    cd ~/work/web/react/complaint-app
    gprm
    glm --since=$SINCE | sed -E "s/^\[complaint\]//g" | sed -E "s/^ ?/- /g" >> $FILENAME
    cd -
    echo $'\n#### gaf\n' >> $FILENAME
    cd ~/work/web/vue/gaf
    gprm
    glm --since=$SINCE | sed -E "s/^ ?/- /g" >> $FILENAME
    cd -
    echo $'\n#### base-ui\n' >> $FILENAME
    cd ~/work/web/vue/base-ui
    gprm
    glm --since=$SINCE | sed -E "s/^ ?/- /g" >> $FILENAME
    cd -
    cd ~/work/web/yqd_web_admin
    gprm
    echo $'\n#### yqd_web_admin\n' >> $FILENAME
    glm --since=$SINCE | sed -E "s/^\[yqd_web_admin\]//g" | sed -E "s/^ ?/- /g" >> $FILENAME
    cd -
    cd ~/work/web/vue/ssr
    gprm
    echo $'\n#### vue-ssr\n' >> $FILENAME
    glm --since=$SINCE | sed -E "s/^\[vue-ssr\]//g" | sed -E "s/^ ?/- /g" >> $FILENAME
    cd -
    cd ~/work/web/vue/spa
    gprm
    echo $'\n#### vue-spa\n' >> $FILENAME
    glm --since=$SINCE | sed -E "s/^\[vue-spa\]//g" | sed -E "s/^ ?/- /g" >> $FILENAME
    cd -
    echo $'\n#### common\n' >> $FILENAME
    cd ~/work/web/common/yqg-cli
    gprm
    glm --since=$SINCE | sed -E "s/^ ?/- /g" >> $FILENAME
    cd -
    cd ~/work/web/common/yqg-util
    gprm
    glm --since=$SINCE | sed -E "s/^ ?/- /g" >> $FILENAME
    cd -
    cd ~/work/web/yqg-guard
    gprm
    glm --since=$SINCE | sed -E "s/^ ?/- /g" >> $FILENAME
    cd -
    echo $'\n### 下周大致规划\n' >> $FILENAME
    echo $'\n### 感想及分享\n' >> $FILENAME
    echo $FILENAME
    vim $FILENAME
}

# Git branch in prompt.
#parse_git_branch() {
#     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
#}
#export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\n\[\033[01;32;40m\]\$\[\033[00m\] "

# proxy list
alias proxy='export all_proxy=socks5://127.0.0.1:1086'
alias unproxy='unset all_proxy'
alias aws='ssh -i ~/.ssh/lq.pem ec2-user@52.53.176.119'
alias setbp='vim ~/.bash_profile'
alias updatebp='source ~/.bash_profile'

alias jump='ssh 18515663215@jump.yangqianguan.com'
alias jt='ssh yqg@jump-test.yangqianguan.com'
alias jto='ssh yqg@54.223.138.134'
alias jfo='ssh yqg@52.220.220.58'

# complaint code-push: yqgweb@gmail.com Y4$9@rFtRVod
# umeng: developer@yangqianguan.com  YqgDev2015
# npm: yqg-owner ywYD129^$B6B
# npm publish --tag next
# npm dist-tags
# npm publish --access=public
# npm install --unsafe-perm --no-optional
# docker run -i -d -p 80:80 -p 8081:8081 docker.io/caihuijigood/badjs-docker bash badjs mysql=mysql://root@10.0.9.2:3306/badjs mongodb=mongodb://10.0.9.2:27017/badjs
