#!/bin/zsh -e

: ${SRPMIX7:=~/srpmix7/srpmix7}
: ${XCMD:=~/srpmix7/xcmd}
: ${CTAGS:=~/ctags/ctags}

newline_maybe ()
{
    if [[ $1 -gt 68 ]]; then
	echo "|"
    else
	return 1
    fi
}

p_red ()
{
    local c=$1

    printf '%b' "\033[31m${c}\033[39m"
}

p_yellow ()
{
    local c=$1

    printf '%b' "\033[33m${c}\033[39m"
}

p_green ()
{
    local c=$1

    printf '%b' "\033[32m${c}\033[39m"
}

run ()
{
    local c=$1
    local s=
    local cradle=
    local sources=
    local sources_c=
    local sources_c_n=
    local sources_c_n_evr=
    local sources_c_n_evr_status=

    local total_count=0
    local skip_count=0
    local successful_count=0
    local early_error_count=0
    local error_count=0    
    local msg_count=0

    local -a early_error_src
    local -a early_error_dest
    local -a error_src
    local -a error_dest
    local i

    cradle=${c##*/}
    sources=${D}/cradles/${cradle}/sources
    mkdir -p $sources

    if ! [[ -d $c/Packages ]]; then
	continue
    fi

    echo
    echo Cradles: $cradle
    echo '======================================================================'

    for s in $c/Packages/*.src.rpm; do
	sources_c=${sources}/${${(f)"$(rpm -qp --nosignature --queryformat "%{name}\n" $s)"}:0:1}
	sources_c_n=${sources_c}/${(f)"$(rpm -qp --nosignature --queryformat "%{name}\n" $s)"}
	sources_c_n_evr=${sources_c_n}/${(f)"$(rpm -qp --nosignature --queryformat '%{EPOCHNUM}:%{VERSION}-%{RELEASE}\n' $s)"}
	mkdir -p ${sources_c_n_evr}

	(( total_count += 1 ))
	sources_c_n_evr_status=${sources_c_n_evr}/_status
	if [[ -f ${sources_c_n_evr_status} && $(< ${sources_c_n_evr_status}) = "successful" ]]; then
	    echo -n ' '
	    (( skip_count += 1 ))
	    (( msg_count += 1 ))
	    newline_maybe $msg_count &&  msg_count=0
	    continue
	elif [ -f ${sources_c_n_evr_status} ]; then
	    rm -rf ${sources_c_n_evr}/*(N)
	    (( retry_count += 1 ))
	else
	    rm -rf ${sources_c_n_evr}/*(N)
	fi

	if SRPMIX7_XCMD_DIR=$XCMD ${SRPMIX7} expand --src file:$s --dest dir:${sources_c_n_evr} srpm; then
	    p_green .
	    (( successful_count += 1 ))
	else
	    case $status in
		(1) p_red F
		    (( early_error_count += 1 ))
		    (( msg_count += 1 ))
		    newline_maybe $msg_count &&  msg_count=0
		    early_error_src+=${s##*/}
		    early_error_dest+=${sources_c_n_evr#{sources_c}}
		    ;;
		(2) p_yellow f
		    (( error_count += 1 ))
		    (( msg_count += 1 ))
		    newline_maybe $msg_count &&  msg_count=0
		    error_src+=${s##*/}
		    error_dest+=${sources_c_n_evr#{sources_c}}
		    ;;
		(*) echo "UNEXPECTED EXIT STATUS" 2>&1
		    exit 0
		    ;;
	    esac
	fi
    done

    echo
    =printf "%-15s %30s\n"   "TOTAL"       "${total_count}"
    =printf "%-15s %30s\n"   "skipped"     "${skip_count}"
    =printf "%-15s %30s\n"   "successful"  "${successful_count}"
    =printf "%-15s %30s\n"   "EARLY-ERROR" "${early_error_count}"
    =printf "%-15s %30s\n"   "error"       "${error_count}"

    echo
    echo EARLY-ERROR '(may be bug)'
    echo '----------------------------------------------------------------------'
    for (( i=1; i <= $#early_error_src; i++ )); do
	=printf "%20s => %-20s\n" "${early_error_src[$i]}" "${early_error_dest[$i]}"
    done

    echo
    echo ERROR
    echo '----------------------------------------------------------------------'
    for (( i=1; i <= $#error_src; i++ )); do
	=printf "%20s => %-20s\n" "${error_src[$i]}" "${error_dest[$i]}"
    done

    echo
}
 
main ()
{
    local c

    mkdir -p $D
    for c in "$@"; do
	run $c
    done
}

D=$1
shift 
main "$@"
