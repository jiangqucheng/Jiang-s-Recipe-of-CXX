.PHONY: all clean PRINT_ME

all: $(TARGETS)
	$(PRINT) "**** Done $@  [ $@: $^ ] "
	$(PRINT) 

%.o: %.cpp %.d
	$(PRINT) "**** Compiling $@  [ $@: $(filter-out $(MAKE_CONFIGS),$^) ] "
	$(CXX) \
		-o $@ -c $<  \
		$(CXX_FLAGS) \
		$(patsubst %,-I %,$(INC_DIR)) \
		$(patsubst %,-D %,$(USING_DEFS)) \
		$(patsubst %,-l %,$(USING_LIBS)) 
	$(PRINT) 

%.o: %.cu %.d
	$(PRINT) "**** Compiling $@  [ $@: $(filter-out $(MAKE_CONFIGS),$^) ] "
	$(CXX) \
		-o $@ -c $<  \
		$(CXX_FLAGS) \
		$(patsubst %,-I %,$(INC_DIR)) \
		$(patsubst %,-D %,$(USING_DEFS)) \
		$(patsubst %,-l %,$(USING_LIBS)) 
	$(PRINT) 

# depricated
$(EXES): $(OBJS)
	$(PRINT) "**** Linking   $@  [ $@: $(filter-out $(MAKE_CONFIGS),$(filter-out $(patsubst %,%.o,$(filter-out $@,$(EXES))),$^)) ] "
	-$(MKDIR) $(dir $@)
	$(LINKER) \
		-o $@  $(filter-out $(MAKE_CONFIGS),$(filter-out $(patsubst %,%.o,$(filter-out $@,$(EXES))),$^)) \
		$(LINK_FLAGS) \
		$(patsubst %,-I %,$(INC_DIR)) \
		$(patsubst %,-D %,$(USING_DEFS)) \
		$(patsubst %,-l %,$(USING_LIBS)) \
		$(patsubst %,-L %,$(LIB_DIR)) 
	$(PRINT) 


$(LIBS):$(OBJS) 
	$(PRINT) "**** Linking   $@  [ $@: $(filter-out $(MAKE_CONFIGS),$(filter-out $(patsubst %,%.o,$(filter-out $@,$(EXES))),$^)) ] "
	$(LINKER) \
		-o $@  $(filter-out $(MAKE_CONFIGS),$(filter-out $(patsubst %,%.o,$(filter-out $@,$(EXES))),$^)) \
		-shared $(LINK_FLAGS) \
		$(patsubst %,-I %,$(INC_DIR)) \
		$(patsubst %,-D %,$(USING_DEFS)) \
		$(patsubst %,-l %,$(USING_LIBS)) 
	$(PRINT) 

###########  genereate dependent relation file  
# Note that 这里人为指定了依赖关系中的目标为.o和.d，为的是在h文件更新时，依赖文件也能更新
%.d:%.cpp
	$(PRINT) " "
	$(PRINT) "**** Creating $@"
	$(CXX) $< -MM -MF $@ -MT $*.o -MT $*.d $(CXX_FLAGS) $(patsubst %,-I %,$(INC_DIR))  
	$(PRINT) " "

%.d:%.cu
	$(PRINT) " "
	$(PRINT) "**** Creating dependent file $@"
	set -e; rm -f $@; \
		$(CXX)  $< -M $(CXX_FLAGS) $(patsubst %,-I %,$(INC_DIR))  > $@.$$$$; \
		# sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
		sed '1 s/^/$(subst /,\/,$(SRC_DIR))\//' < $@.$$$$ > $@; \
		sed -i '/^    \/.*/d' $@; \
		rm -f $@.$$$$
	$(PRINT) " "


# do not include dependent relations when the make goal is "make clean"
ifneq ($(MAKECMDGOALS),clean)
sinclude $(DEPS)
endif


ifneq ($(TARGET),clean)
clean_root_folder_additional_cmd=-$(MAKE) -f makefile.mak clean TARGET=clean
endif
########### clean ###################
clean:
	$(PRINT)
	$(PRINT) "**** Cleaning   $(shell pwd) "
	-for dir in $(SUBDIRS);	do $(MAKE) -C $$dir clean||exit 1;	done
	$(RM) $(OBJS) $(TARGETS) $(DEPS)
	$(clean_root_folder_additional_cmd)
	$(PRINT)


PRINT_ME:
	$(PRINT) " "
	$(PRINT) " "
	$(PRINT) "      ██╗██╗ █████╗ ███╗   ██╗ ██████╗      ██████╗  ██████╗"
	$(PRINT) "      ██║██║██╔══██╗████╗  ██║██╔════╝     ██╔═══██╗██╔════╝"
	$(PRINT) "      ██║██║███████║██╔██╗ ██║██║  ███╗    ██║   ██║██║     "
	$(PRINT) " ██   ██║██║██╔══██║██║╚██╗██║██║   ██║    ██║▄▄ ██║██║     "
	$(PRINT) " ╚█████╔╝██║██║  ██║██║ ╚████║╚██████╔╝    ╚██████╔╝╚██████╗"
	$(PRINT) "  ╚════╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝      ╚══▀▀═╝  ╚═════╝"
	$(PRINT) " "
	$(PRINT) " "

