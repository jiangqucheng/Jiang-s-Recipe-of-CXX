TOP_DIR=.
sinclude $(TOP_DIR)/make.config.mak
.PHONY: $(SUBDIRS) PRINT_ME root_folder make_requisite


SUBDIRS = Hello counter


all : make_requisite $(SUBDIRS) root_folder PRINT_ME
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

make_requisite: Jiang-s-Recipe-of-CXX/extract_link.bash
	Jiang-s-Recipe-of-CXX/extract_link.bash