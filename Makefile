#############################################################################
#
# Generic Makefile for C/C++ Program
# Copyright (C) 2013 Federico "MrModd" Cosentino
# Version 1.0: 2013/12/03
#
# Based on Generic Makefile for C/C++ Program
# by whyglinux <whyglinux AT gmail DOT com>
# Version: 2008/04/05 (version 0.5)
# Distributed under the GPL (General Public License)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#
# Description:
# ------------
# This is an easily customizable makefile template. The purpose is to
# provide an instant building environment for C/C++ programs.
#
# It searches all the C/C++ source files in the specified directories,
# makes dependencies, compiles and links to form an executable.
#
# Besides its default ability to build C/C++ programs which use only
# standard C/C++ libraries, you can customize the Makefile to build
# those using other libraries. Once done, without any changes you can
# then build programs using the same or less libraries, even if source
# files are renamed, added or removed. Therefore, it is particularly
# convenient to use it to build codes for experimental or study use.
#
# GNU make is expected to use the Makefile. Other versions of makes
# may or may not work.
#
# Usage:
# ------
# 1. Copy the Makefile to your program directory.
# 2. Customize in the "Customizable Section" only if necessary:
#    * to use non-standard C/C++ libraries, set pre-processor or compiler
#      options to <MY_CFLAGS> and linker ones to <MY_LIBS>
#      (See Makefile.gtk+-2.0 for an example)
#    * to search sources in more directories, set to <SRCDIRS>
#    * to specify your favorite program name, set to <PROGRAM>
# 3. Type make to start building your program.
#
# Make Target:
# ------------
# The Makefile provides the following targets to make:
#   $ make           compile and link
#   $ make NODEP=yes compile and link without generating dependencies
#   $ make objs      compile only (no linking)
#   $ make tags      create tags for Emacs editor (requires etags)
#   $ make ctags     create ctags for VI editor (reguires ctags)
#   $ make clean     clean objects and the executable
#   $ make distclean clean clean objects, the executable, dependencies and tags
#   $ make help      get the usage of the makefile
#
#===========================================================================

## Customizable Section: adapt those variables to suit your program.
##==========================================================================

# The pre-processor and compiler options.
MY_CFLAGS =

# The linker options.
MY_LIBS   =

# The pre-processor options used by the cpp (man cpp for more).
CPPFLAGS  =

# The options used in linking as well as in any direct use of ld.
LDFLAGS   =

# Uncomment this if you need debug symbols
#DBGFLAGS  = -g

# The directories in which source files reside.
# If not specified, only the current directory will be serached.
SRCDIRS   =

# The executable file name.
# If not specified, current directory name or `a.out' will be used.
PROGRAM   =

## Implicit Section: change the following only when necessary.
##==========================================================================

# The source file types (headers excluded).
# .c indicates C source files, and others C++ ones.
SRCEXTS = .c .C .cc .cpp .CPP .c++ .cxx .cp

# The header file types.
HDREXTS = .h .H .hh .hpp .HPP .h++ .hxx .hp

# The pre-processor and compiler options.
# Users can override those variables from the command line.
CFLAGS   = -O2
CXXFLAGS = -O2

# The C program compiler.
#CC       = gcc

# The C++ program compiler.
#CXX      = g++

# Un-comment the following line to compile C programs as C++ ones.
#CC       = $(CXX)

# The command used to delete file.
#RM       = rm -f

ETAGS = etags
ETAGSFLAGS =

CTAGS = ctags
CTAGSFLAGS =

## Stable Section: usually no need to be changed. But you can add more.
##==========================================================================
SHELL   = /bin/sh
EMPTY   =
SPACE   = $(EMPTY) $(EMPTY)
ifeq ($(PROGRAM),)
  CUR_PATH_NAMES = $(subst /,$(SPACE),$(subst $(SPACE),_,$(CURDIR)))
  PROGRAM = $(word $(words $(CUR_PATH_NAMES)),$(CUR_PATH_NAMES))
  ifeq ($(PROGRAM),)
    PROGRAM = a.out
  endif
endif
ifeq ($(SRCDIRS),)
  SRCDIRS = .
endif
ifneq ($(DBGFLAGS),)
  CFLAGS += $(DBGFLAGS)
  CXXFLAGS += $(DBGFLAGS)
endif
SOURCES = $(foreach d,$(SRCDIRS),$(wildcard $(addprefix $(d)/*,$(SRCEXTS))))
HEADERS = $(foreach d,$(SRCDIRS),$(wildcard $(addprefix $(d)/*,$(HDREXTS))))
SRC_CXX = $(filter-out %.c,$(SOURCES))
OBJS    = $(addsuffix .o, $(basename $(SOURCES)))
DEPS    = $(OBJS:.o=.d)

## Define some useful variables.
DEP_OPT = $(shell if `$(CC) --version | grep "GCC" >/dev/null`; then \
                  echo "-MM -MP"; else echo "-M"; fi )
DEPEND      = $(CC)  $(DEP_OPT)  $(MY_CFLAGS) $(CFLAGS) $(CPPFLAGS)
DEPEND.d    = $(subst -g ,,$(DEPEND))
COMPILE.c   = $(CC)  $(MY_CFLAGS) $(CFLAGS)   $(CPPFLAGS) -c
COMPILE.cxx = $(CXX) $(MY_CFLAGS) $(CXXFLAGS) $(CPPFLAGS) -c
LINK.c      = $(CC)  $(MY_CFLAGS) $(CFLAGS)   $(CPPFLAGS) $(LDFLAGS)
LINK.cxx    = $(CXX) $(MY_CFLAGS) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)

.PHONY: all objs tags ctags clean distclean help show

# Delete the default suffixes
.SUFFIXES:

all: $(PROGRAM)

# Rules for creating dependency files (.d).
#------------------------------------------

%.d:%.c
#@echo -n $(dir $<) > $@
	@echo "$(dir $<)\c" > $@
	@$(DEPEND.d) $< >> $@

%.d:%.C
#@echo -n $(dir $<) > $@
	@echo "$(dir $<)\c" > $@
	@$(DEPEND.d) $< >> $@

%.d:%.cc
#@echo -n $(dir $<) > $@
	@echo "$(dir $<)\c" > $@
	@$(DEPEND.d) $< >> $@

%.d:%.cpp
#@echo -n $(dir $<) > $@
	@echo "$(dir $<)\c" > $@
	@$(DEPEND.d) $< >> $@

%.d:%.CPP
#@echo -n $(dir $<) > $@
	@echo "$(dir $<)\c" > $@
	@$(DEPEND.d) $< >> $@

%.d:%.c++
#@echo -n $(dir $<) > $@
	@echo "$(dir $<)\c" > $@
	@$(DEPEND.d) $< >> $@

%.d:%.cp
#@echo -n $(dir $<) > $@
	@echo "$(dir $<)\c" > $@
	@$(DEPEND.d) $< >> $@

%.d:%.cxx
#@echo -n $(dir $<) > $@
	@echo "$(dir $<)\c" > $@
	@$(DEPEND.d) $< >> $@

# Rules for generating object files (.o).
#----------------------------------------
objs:$(OBJS)

%.o:%.c
	$(COMPILE.c) $< -o $@

%.o:%.C
	$(COMPILE.cxx) $< -o $@

%.o:%.cc
	$(COMPILE.cxx) $< -o $@

%.o:%.cpp
	$(COMPILE.cxx) $< -o $@

%.o:%.CPP
	$(COMPILE.cxx) $< -o $@

%.o:%.c++
	$(COMPILE.cxx) $< -o $@

%.o:%.cp
	$(COMPILE.cxx) $< -o $@

%.o:%.cxx
	$(COMPILE.cxx) $< -o $@

# Rules for generating the tags.
#-------------------------------------
tags: $(HEADERS) $(SOURCES)
	$(ETAGS) $(ETAGSFLAGS) $(HEADERS) $(SOURCES)

ctags: $(HEADERS) $(SOURCES)
	$(CTAGS) $(CTAGSFLAGS) $(HEADERS) $(SOURCES)

# Rules for generating the executable.
#-------------------------------------
ifndef NODEP
ifneq ($(DEPS),)
$(PROGRAM):$(OBJS) $(DEPS)
else
$(PROGRAM):$(OBJS)
endif
else
$(PROGRAM):$(OBJS)
endif
ifeq ($(SRC_CXX),)              # C program
	$(LINK.c) $(OBJS) $(MY_LIBS) -o $@
	@echo Type ./$@ to execute the program.
else                            # C++ program
	$(LINK.cxx) $(OBJS) $(MY_LIBS) -o $@
	@echo Type ./$@ to execute the program.
endif

clean:
	$(RM) $(OBJS) $(PROGRAM) $(PROGRAM).exe

distclean: clean
	$(RM) TAGS tags $(DEPS)

# Show help.
help:
	@echo '----------------------------------------------------------------'
	@echo 'Generic Makefile for C/C++ Program'
	@echo 'Copyright (C) 2013 Federico "MrModd" Cosentino'
	@echo 'Version 1.0: 2013/12/03'
	@echo '----------------------------------------------------------------'
	@echo 'Based on Generic Makefile for C/C++ Program'
	@echo 'by whyglinux <whyglinux AT gmail DOT com>'
	@echo 'Version: 2008/04/05 (version 0.5)'
	@echo
	@echo 'Usage: make [TARGET]'
	@echo 'TARGETS:'
	@echo '  all       (=make) compile and link.'
	@echo '  NODEP=yes make without generating dependencies.'
	@echo '  objs      compile only (no linking).'
	@echo '  tags      create tags for Emacs editor (requires etags).'
	@echo '  ctags     create ctags for VI editor (requires ctags).'
	@echo '  clean     clean objects and the executable.'
	@echo '  distclean clean objects, the executable, dependencies and tags.'
	@echo '  show      show variables (for debug use only).'
	@echo '  help      print this message.'

# Show variables (for debug use only.)
show:
	@echo 'PROGRAM     :' $(PROGRAM)
	@echo 'SRCDIRS     :' $(SRCDIRS)
	@echo 'HEADERS     :' $(HEADERS)
	@echo 'SOURCES     :' $(SOURCES)
	@echo 'INCLUDES    :' $(INCLUDES)
	@echo 'SRC_CXX     :' $(SRC_CXX)
	@echo 'OBJS        :' $(OBJS)
	@echo 'DEPS        :' $(DEPS)
	@echo 'DEPEND      :' $(DEPEND)
	@echo 'COMPILE.c   :' $(COMPILE.c)
	@echo 'COMPILE.cxx :' $(COMPILE.cxx)
	@echo 'link.c      :' $(LINK.c)
	@echo 'link.cxx    :' $(LINK.cxx)

#############################################################################
