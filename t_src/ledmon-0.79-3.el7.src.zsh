#!/bin/zsh

d=$1
: && 
    ( [[ -e $d/pre-build/ledmon-0.79/src/Makefile ]] ) &&
    (  ! [[ -e $d/pre-build/ledmon-0.79/src/Makefile.cflags ]] ) &&
    (  [[ $(readlink $d/specs/srpm.spec) == "./ledmon.spec" ]] ) &&
    exit 0
exit 1
