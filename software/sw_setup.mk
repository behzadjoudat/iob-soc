# (c) 2022-Present IObundle, Lda, all rights reserved
#
# This makefile segment lists all software header and source files 
#
# It is included in submodules/LIB/Makefile for populating the
# build directory
#

#import software from submodules
include $(CACHE_DIR)/software/sw_setup.mk
include $(UART_DIR)/software/sw_setup.mk

# Generic target to copy/link sources of esrc/ directory to psrc/ directory
$(BUILD_PSRC_DIR)/%: $(BUILD_ESRC_DIR)/%
	ln -sr $< $@

# CACHE sources
SRC+=$(patsubst $(CACHE_DIR)/software/src/%,$(BUILD_ESRC_DIR)/%,$(wildcard $(CACHE_DIR)/software/src/*))
SRC+=$(patsubst $(CACHE_DIR)/software/src/%,$(BUILD_PSRC_DIR)/%,$(wildcard $(CACHE_DIR)/software/src/*))
$(BUILD_ESRC_DIR)/%: $(CACHE_DIR)/software/src/%
	cp $< $@
SRC+=$(patsubst $(CACHE_DIR)/software/esrc/%,$(BUILD_ESRC_DIR)/%,$(wildcard $(CACHE_DIR)/software/esrc/*))
$(BUILD_ESRC_DIR)/%: $(CACHE_DIR)/software/esrc/%
	cp $< $@
SRC+=$(patsubst $(CACHE_DIR)/software/psrc/%,$(BUILD_PSRC_DIR)/%,$(wildcard $(CACHE_DIR)/software/psrc/*))
$(BUILD_PSRC_DIR)/%: $(CACHE_DIR)/software/psrc/%
	cp $< $@


# UART sources
SRC+=$(patsubst $(UART_DIR)/software/src/%,$(BUILD_ESRC_DIR)/%,$(wildcard $(UART_DIR)/software/src/*))
SRC+=$(patsubst $(UART_DIR)/software/src/%,$(BUILD_PSRC_DIR)/%,$(wildcard $(UART_DIR)/software/src/*))
$(BUILD_ESRC_DIR)/%: $(UART_DIR)/software/src/%
	cp $< $@
SRC+=$(patsubst $(UART_DIR)/software/esrc/%,$(BUILD_ESRC_DIR)/%,$(wildcard $(UART_DIR)/software/esrc/*))
$(BUILD_ESRC_DIR)/%: $(UART_DIR)/software/esrc/%
	cp $< $@
SRC+=$(patsubst $(UART_DIR)/software/psrc/%,$(BUILD_PSRC_DIR)/%,$(wildcard $(UART_DIR)/software/psrc/*))
$(BUILD_PSRC_DIR)/%: $(UART_DIR)/software/psrc/%
	cp $< $@

#SOC_SW_DIR:=$(SOC_DIR)/software

#HEADERS
#SRC+=$(BUILD_PSRC_DIR)/system.h $(BUILD_ESRC_DIR)/system.h
#$(BUILD_PSRC_DIR)/system.h: $(SOC_SW_DIR)/system.h
#	cp $< $@

#Not used anymore. Use iob_soc_conf.h instead.
#SRC+=$(BUILD_PSRC_DIR)/iob_soc.h
#$(BUILD_PSRC_DIR)/iob_soc.h:
#	$(LIB_DIR)/scripts/sw_defines.py $@ $(SOC_DEFINE)

#SRC+=$(BUILD_PSRC_DIR)/template.lds $(BUILD_ESRC_DIR)/template.lds
#$(BUILD_PSRC_DIR)/template.lds: $(SOC_SW_DIR)/template.lds
#	cp $< $@

#peripherals' base addresses
#SRC+=$(BUILD_PSRC_DIR)/periphs.h $(BUILD_ESRC_DIR)/periphs.h
#$(BUILD_PSRC_DIR)/periphs.h $(BUILD_ESRC_DIR)/periphs.h:
	#No longer needed, iob_soc_setup.py generates this.
	#@is_diff=`diff -q -N $(BUILD_ESRC_DIR)/periphs.h $<`; if [ "$$is_diff" ]; then cp $< $(BUILD_ESRC_DIR)/periphs.h; fi && rm periphs_tmp.h
#	ln -fsr $(BUILD_ESRC_DIR)/periphs.h $(BUILD_PSRC_DIR)/periphs.h

#configuration headers. This file is generated by setup.py
#SRC+=$(BUILD_PSRC_DIR)/iob_soc_conf.h
#$(BUILD_PSRC_DIR)/iob_soc_conf.h:
#	$(LIB_DIR)/scripts/sw_defines.py $@ BAUD=BAUD_SIM PC 

# SOURCES

# # bootloader
# BHDR=$(wildcard $(SOC_SW_DIR)/bootloader/*.h)
# SRC+=$(patsubst $(SOC_SW_DIR)/bootloader/%,$(BUILD_SW_BSRC_DIR)/%,$(BHDR))
# $(BUILD_SW_BSRC_DIR)/%.h: $(SOC_SW_DIR)/bootloader/%.h
# 	cp $< $@

# BSRC=$(wildcard $(SOC_SW_DIR)/bootloader/*.c)
# SRC+=$(patsubst $(SOC_SW_DIR)/bootloader/%,$(BUILD_SW_BSRC_DIR)/%,$(BSRC))
# $(BUILD_SW_BSRC_DIR)/%.c: $(SOC_SW_DIR)/bootloader/%.c
# 	cp $< $@

# BSRCS=$(wildcard $(SOC_SW_DIR)/bootloader/*.S)
# SRC+=$(patsubst $(SOC_SW_DIR)/bootloader/%,$(BUILD_SW_BSRC_DIR)/%,$(BSRCS))
# $(BUILD_SW_BSRC_DIR)/%.S: $(SOC_SW_DIR)/bootloader/%.S
# 	cp $< $@

# firmware
#HDR=$(wildcard $(SOC_SW_DIR)/firmware/*.h)
#SRC+=$(patsubst $(SOC_SW_DIR)/firmware/%,$(BUILD_PSRC_DIR)/%,$(HDR))
#$(BUILD_PSRC_DIR)/%.h: $(SOC_SW_DIR)/firmware/%.h
#	cp $< $@
#
#SRC1=$(wildcard $(SOC_SW_DIR)/firmware/*.c)
#SRC+=$(patsubst $(SOC_SW_DIR)/firmware/%,$(BUILD_PSRC_DIR)/%,$(SRC1))
#$(BUILD_PSRC_DIR)/%.c: $(SOC_SW_DIR)/firmware/%.c
#	cp $< $@
#
#SRCS=$(wildcard $(SOC_SW_DIR)/firmware/*.S)
#SRC+=$(patsubst $(SOC_SW_DIR)/firmware/%,$(BUILD_PSRC_DIR)/%,$(SRCS))
#$(BUILD_PSRC_DIR)/%.S: $(SOC_SW_DIR)/firmware/%.S
#	cp $< $@



#
# LIB Scripts
#
SRC+=$(BUILD_SW_PYTHON_DIR)/sw_defines.py $(BUILD_SW_PYTHON_DIR)/console.py
$(BUILD_SW_PYTHON_DIR)/%: $(LIB_DIR)/scripts/%
	cp $< $@

SRC+=$(BUILD_DIR)/console.mk
$(BUILD_DIR)/console.mk: $(LIB_DIR)/scripts/console.mk
	cp $< $@

