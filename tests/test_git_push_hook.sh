#!/bin/bash


oneTimeSetUp() {
    git checkout --quiet master

    REMOVE_REMOTE_PREFIX_CMD=$(grep --no-filename DEFAULT_UPSTREAM_BRANCH_NAME= git/hooks/pre-push | rev | cut --delimiter ' ' --fields 1 | rev)
}


oneTimeTearDown() {
    ##
    # @reference    Is there any way to git checkout previous branch?
    #               https://stackoverflow.com/questions/7206801/is-there-any-way-to-git-checkout-previous-branch
    ##
    git checkout --quiet -
}


testPreHookScriptExistAndRunable() {
    DOT_GIT_DIR=$(git rev-parse --git-dir)
    assertTrue "[ -x \"$DOT_GIT_DIR/hooks/pre-push\" ]"
}


testDefaultPushToMasterWouldFail() {
    git push --dry-run
    assertFalse $?
}


testPushToGerrithubShouldWork() {
    git push --dry-run origin HEAD:refs/for/master
    assertTrue $?
}


testRemoveRemotePrefixWithMaster() {
    local EXPECTED_BRANCH_NAME="master"
    local REMOTE="origin"
    local DEFAULT_FULL_UPSTREAM="$REMOTE/$EXPECTED_BRANCH_NAME"

    eval "local $REMOVE_REMOTE_PREFIX_CMD"

    assertEquals "$EXPECTED_BRANCH_NAME" "$DEFAULT_UPSTREAM_BRANCH_NAME"
}


testRemoveRemotePrefixWithRefsFor() {
    local REMOTE=origin
    local DEFAULT_FULL_UPSTREAM="refs/for/master"

    eval "local $REMOVE_REMOTE_PREFIX_CMD"

    assertEquals "$DEFAULT_FULL_UPSTREAM" "$DEFAULT_UPSTREAM_BRANCH_NAME"
}


source /usr/bin/shunit2
