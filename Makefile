# Either option 1 or 2
# 1
# The GACODE_ROOT environmental variable should point to the root directory where GACODE is installed.
# Environment variable GACODE_PLATFORM should be set to one of the following systems:
#   ALCF_BGP ALCF_CETUS BABBAGE BANACH CAOS CARVER CMODWS DELPHI
#   DROP EDISON_CRAY EDISON_INTEL FT GFORTRAN_CORE2 GFORTRAN_OSX
#   GFORTRAN_OSX_64 GFORTRAN_OSX_BELLI GFORTRAN_OSX_MACPORTS
#   GFORTRAN_OSX_TECHX GFORTRAN_PENRYN GFORTRAN_TECHX HOPPER_CRAY
#   HOPPER_INTEL HPC_ITER IFORT_CORE2 IFORT_PENRYN JAC LINDGREN
#   LOHAN LOKI LOKI_SCRATCH METIUS NEWT OSX_MOUNTAINLION PACER
#   PGFORTRAN_OSX PG_OPT64 PG_OPT64_FFTW PG_OPT64_MUMPS PPPL
#   PPPL_PATHSCALE RANGER SATURN TITAN_CRAY VENUS
# 2
# Define CC, CFLAGS, FC, FFLAGS, ARCH here or at the command line
#
ifdef GACODE_ROOT
	include $(GACODE_ROOT)/platform/build/make.inc.$(GACODE_PLATFORM)
else
	CC=cc
	CFLAGS=
	FC=gfortran
	FFLAGS=
	ARCH=ar cr
endif

LLIB = libbrainfusetf.a

EXEC = brainfusetf_run.exe

OBJECTS = brainfusetf_lib.o brainfusetf_exe.o

libs: libbrainfusetf.a

libbrainfusetf.a: brainfusetf_lib.o Makefile
	$(ARCH) libbrainfusetf.a $<

brainfusetf_run.exe : brainfusetf.c libbrainfusetf.a
	$(CC) $(CFLAGS) -o $@ -I./ -L./ $< -lbrainfusetf -lm

%.o : %.c
	$(CC) $(CFLAGS) -c $< -I./

all: $(LLIB) $(EXEC) toq_profiles_test

eped1nn/toq_profiles.o:eped1nn/toq_profiles.f90
	cd eped1nn; $(FC) -c toq_profiles.f90

toq_profiles_test: eped1nn/toq_profiles.o eped1nn/toq_profiles_test.f90
	cd eped1nn; $(FC) -o toq_profiles_test toq_profiles.o toq_profiles_test.f90

clean:
	rm -f *.o  *.a *~ $(EXEC) *.mod eped1nn/*.mod eped1nn/*.o eped1nn/*.a eped1nn/toq_profiles_test

omfit_install:
	cp -f brainfuse.py brainfusetf.py $(OMFIT_ROOT)/src/classes/
