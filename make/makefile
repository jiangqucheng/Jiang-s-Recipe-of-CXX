TOP_DIR=.

## this is only need in project root
ifeq ($(MAKECMDGOALS),clean)
	root_folder_CLEAN_COMMAND_ADDI = Jiang-s-Recipe-of-CXX/extract_link.bash -c
else
	ifeq ($(wildcard $(TOP_DIR)/make.config.mak),)
		__rubbish_bin_var__:=$(shell Jiang-s-Recipe-of-CXX/extract_link.bash)
	else ifeq ($(wildcard $(TOP_DIR)/make.func.mak),)
		__rubbish_bin_var__:=$(shell Jiang-s-Recipe-of-CXX/extract_link.bash)
	endif
endif


sinclude $(TOP_DIR)/make.config.mak
.PHONY: $(SUBDIRS) PRINT_ME root_folder 


SUBDIRS = Hello counter


all : $(SUBDIRS) root_folder PRINT_ME
	$(PRINT) " "
	$(PRINT) "**** all $(shell pwd)/$@  "

$(SUBDIRS):
	$(PRINT) " "
	$(PRINT) "**** make sub Dir $(shell pwd)/$@  "
	$(MAKE) --directory=$@ TARGET=$(TARGET) $(TARGET) 
	$(PRINT) " "

root_folder: $(SUBDIRS) 
	$(PRINT) " "
	$(PRINT) "**** make root Dir $(shell pwd)/$@  "
	# $(MAKE) -f makefile.mak TARGET=$(TARGET) $(TARGET) 
	$(PRINT) " "

sinclude $(TOP_DIR)/make.func.mak

