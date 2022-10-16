
# ##################   shell   ###################

SHELL          ?= /bin/sh
CD             ?= cd
CP             ?= cp
LN_S           ?= ln -s -f
MKDIR          ?= mkdir -p
RM             ?= /bin/rm -rf
MAKE           ?= make
PRINT          ?= @echo


#################   directory   #################

TOP_DIR        ?= .
  # "SRC_DIR" is place to put source code. 
SRC_DIR        ?= ./src .
  # "INC_DIR" is place to put common shared header files. 
INC_DIR        ?= . ./inc ./include $(TOP_DIR)/inc $(TOP_DIR)/include $(TOP_DIR)  
  # "BIN_DIR" is place to put output binary executables. 
BIN_DIR        ?= $(TOP_DIR)/bin
  # "LIB_DIR" is place to put library. 
LIB_DIR        ?= $(TOP_DIR)/lib
  # "SUBDIRS" is a list of subdirs which located in the current working directory. 
  # Need manually remove "." in shell find, by "filter-out ."
SUBDIRS        =  $(filter-out .,$(shell find . -type d))


########   Compiler / linker / Command   ########

# CXX            = /usr/bin/g++
CXX            ?= g++
# CXX            = mpic++
# CXX            = nvcc
LINKER         ?= $(CXX)


###################   Flags   ###################

LANG_STANDARD   = c++11
USING_DEFS      =  
USING_LIBS      = 
# USING_LIBS     = pthread  
USING_OPTIMIZE  = -O3  

ifeq ($(DEBUG), 1)
    USING_DEFS += DEBUG
else
    USING_DEFS += NO_DEBUG
endif

# ifdef USE_LOCAL_ARCH
# 	march_indicator = -march=native -mavx
# else
# 	march_indicator = -march=x86-64
# endif
# CXX_FLAGS       =  -std=$(LANG_STANDARD)
CXX_FLAGS      +=   -g \
                	$(march_indicator)  $(USING_OPTIMIZE) 
LINK_FLAGS      = $(CXX_FLAGS) 


###################   Files   ###################

MAKE_CONFIGS = $(wildcard $(TOP_DIR)/*.mak)  $(wildcard ./*.mak)  make.config.mak  make.func.mak  makefile  

# 获取源文件，目标文件和依赖文件名
SRCS = $(wildcard $(patsubst %, %/*.cpp, $(SRC_DIR))  $(patsubst %, %/*.c, $(SRC_DIR))  $(patsubst %, %/*.cu, $(SRC_DIR)) )
OBJS = $(filter %.o, $(SRCS:.cpp=.o) $(SRCS:.c=.o) $(SRCS:.cu=.o))
DEPS = $(filter %.d, $(SRCS:.cpp=.d) $(SRCS:.c=.d) $(SRCS:.cu=.d))


# 获取执行 make 模块目录的绝对文件路径
RUNNING_MAKEFILE_PATH = $(abspath $(lastword $(MAKEFILE_LIST))) 
