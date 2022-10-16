
TOP_DIR=.
sinclude $(TOP_DIR)/make.config.mak

EXES = $(BIN_DIR)/countersim
TARGETS=$(OBJS) $(EXES)

USING_OPTIMIZE= 
# CXX_FLAGS+= --gpu-architecture=compute_37 --gpu-code=sm_37 
LINK_FLAGS=$(CXX_FLAGS) 
USING_LIBS      = vcd_writer

sinclude $(TOP_DIR)/make.func.mak


