#!/bin/bash

TARGET_DIR=".."
SOURCE_DIR="."

## link_file_list is a list of file/dir that need to extract from recipe folder to 
link_file_list="
include>>>include
make/makefile>>>makefile
make/makefile.mak>>>makefile.mak
make/make.config.mak>>>make.config.mak
make/make.func.mak>>>make.func.mak
"


## func_getDirReference
### set $PRGDIR & $CRTDIR into script variables.
### $PRGDIR - where this script located 
### $CRTDIR - pwd of running shell
function func_getDirReference() {
    CRTDIR=$(pwd)
    echo "current workdir:" $CRTDIR

    local PRG="$0"
    while [ -h "$PRG" ] ; do
    local ls=`ls -ld "$PRG"`
    local link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
        PRG="$link"
    else
        PRG=`dirname "$PRG"`/"$link"
    fi
    done
    PRGDIR=$(cd $(dirname $PRG); pwd)
    echo "script location:" $PRGDIR
}

## func_mapRelativePath2AbsPath
### turn relative path into abs path, just for $TARGET_DIR & $SOURCE_DIR using $PRGDIR
### if it is already abs path, then it will not change at all. 
function func_mapRelativePath2AbsPath() {
    ## change $TARGET_DIR into absolute path , based on $PRGDIR
    [  $(echo $TARGET_DIR | awk '{ string=substr($0,0,1); print string; }') = "/"   ] && { 
        echo "TARGET_DIR [$TARGET_DIR] is AbsPath."; 
    } || { 
        echo "TARGET_DIR [$TARGET_DIR] change to Abs."; 
        TARGET_DIR="$PRGDIR/$TARGET_DIR"; 
        echo "TARGET_DIR [$TARGET_DIR]."; 
    }
    ## change $SOURCE_DIR into absolute path , based on $PRGDIR
    [  $(echo $SOURCE_DIR | awk '{ string=substr($0,0,1); print string; }') = "/"   ] && { 
        echo "SOURCE_DIR [$SOURCE_DIR] is AbsPath."; 
    } || { 
        echo "SOURCE_DIR [$SOURCE_DIR] change to Abs."; 
        SOURCE_DIR="$PRGDIR/$SOURCE_DIR"; 
        echo "SOURCE_DIR [$SOURCE_DIR]."; 
    }
}

## func_isRootUser
### Purpose: Determine if current user is root or not
### use && <if true> || <if false> for branches
function func_isRootUser() {
    # root user has user id (UID) zero.
    [ $(id -u) -eq 0 ] 
}

## func_decodePathPair
### Put raw pair into `func_decodePathPair_input_pair`, run `func_decodePathPair`, get output from `func_decodePathPair_result_arr`.
### the output: 0th - source path, 1st - target path.
func_decodePathPair_input_pair=""
func_decodePathPair_result_arr=()
function func_decodePathPair() {
    local func_decodePathPair_sep_identifier=">>>"
    local func_decodePathPair_raw_pair="$func_decodePathPair_input";
    local func_decodePathPair_source="${func_decodePathPair_raw_pair%%$func_decodePathPair_sep_identifier*}"
    local func_decodePathPair_target="${func_decodePathPair_raw_pair##*$func_decodePathPair_sep_identifier}"
    func_decodePathPair_result_arr=("$func_decodePathPair_source" "$func_decodePathPair_target")
}

## func_linkProcess
### link process, link (extract) file in link_file_list, of cause, detect first.  
function func_linkProcess() {
    ## LINK Process
    for func_decodePathPair_input in $link_file_list
    do
        func_decodePathPair
        local fm_path="$SOURCE_DIR/${func_decodePathPair_result_arr[0]}"
        local to_path="$TARGET_DIR/${func_decodePathPair_result_arr[1]}"
        # echo "解析路径对： $fm_path 到 $to_path"
        [ -e "$to_path" ] && { 
            echo "  already exist:  $to_path "; 
        } || { 
            ln -s $fm_path  $(dirname $to_path) -f ; 
            echo "  create link :  $fm_path  <--  $to_path " ; 
        } 
    done
}

## func_unlinkProcess
### remove link from target, of cause, detect first, 1. exist, 2. is made from link.  
function func_unlinkProcess() {
    ## LINK Process
    for func_decodePathPair_input in $link_file_list
    do
        func_decodePathPair
        local fm_path="$SOURCE_DIR/${func_decodePathPair_result_arr[0]}"
        local to_path="$TARGET_DIR/${func_decodePathPair_result_arr[1]}"
        # echo "解析路径对： $fm_path 到 $to_path"
        [ -e $to_path ] && { 
            [ -h $to_path ] && {
                echo "  delete:  $to_path "; 
                rm $to_path;
            } || { 
                echo "  not created by link:  $to_path "; 
            }; 
        } || { 
            echo "  link not exist:  $to_path "; 
        } 
    done
}


## get $PRGDIR (where this script located) and $CRTDIR (pwd of running shell), 
func_getDirReference

## for $TARGET_DIR & $SOURCE_DIR, turn relative path into abs path using $PRGDIR
func_mapRelativePath2AbsPath

## identifier whether command line uses param or not.
isParamOverwrited=0

echo 

while getopts "a:exc" arg  # 选项后面的冒号表示该选项需要参数
do
        case $arg in
             a)
                isParamOverwrited=1
                echo "a's arg:$OPTARG"  # 参数存在$OPTARG中
                ;;
             c)
                isParamOverwrited=1 ; echo "-arg [$arg] : clean links if exists from target dir."
                func_unlinkProcess
                ;;
             e|x)
                isParamOverwrited=1 ; echo "-arg [$arg] : extract links to target dir."
                func_linkProcess
                ;;
             ?)  # 当有不认识的选项的时候arg为?
                isParamOverwrited=1 ; echo "-arg [$arg] : unkonw argument."
                # exit 1
                ;;
        esac
done

## default operation
[ $isParamOverwrited -eq 0 ] && func_linkProcess


