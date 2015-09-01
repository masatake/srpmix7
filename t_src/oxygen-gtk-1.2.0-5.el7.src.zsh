#!/bin/zsh

d=$1
: && 
    [[ $(ls $1/pre-build | wc -l) == 0 ]] &&
    [[ $(ls $1/archives | wc -l) == 0 ]] &&
    [[ -f $1/specs/srpm.spec ]] &&    
    exit 0
exit 1
