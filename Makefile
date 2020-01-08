#  Automatic Time-stamp: <Last changed by martino on Wednesday 08 January 2020 at CET 17:46:17>
NAME    = nested_fit3.2.exe
.SUFFIXES : .f90 .f .o .c .mod
CFLAGS  =
FFLAGS  = -fopenmp

CFILES =

# In the order: my stuff, Num. Rec., SLATEC, FITPACK, others stuff
FFILES  =  USERFCN.f USERFCN_SET.f init_interpolation.f \
	\
	dpsort.f \
	xermsg.f fdump.f j4save.f xercnt.f \
	xerhlt.f xerprn.f xersve.f xgetua.f i1mach.f\
	\
	splev.f	 curfit.f fprati.f fprota.f fpknot.f \
	fpdisc.f fpgivs.f fpcurf.f fpbspl.f fpchec.f fpback.f \
	\
	rinteg.f WOFZ.f \
#	cw.f
#	splint.f fpintb.f

F90FILES = Mod_timestamp.f90  Mod_mean_shift_cluster_analysis.f90 \
	 nested_fit.f90 nested_sampling.f90 nested_sampling_set.f90 \
	 dlog_fac.f90 sortn_slatec.f90 meanvar.f90 randn.f90 shirley_fitpack.f90 

OPT = -O2 -static
#OPT = -g  -C -static
#OPT = -O0 -g
#OPT = -O0 -g  -fbounds-check -Wall  -ffpe-trap=invalid,zero,overflow,underflow -fbacktrace -ftrapv
#OPT = -g -Wall -Wextra -Warray-temporaries -Wconversion -fimplicit-none -fbacktrace -ffree-line-length-0 -fcheck=all -ffpe-trap=zero,overflow,underflow -finit-real=nan
#OPT = -g -Wall -Wextra -Warray-temporaries -Wconversion -fbacktrace -ffree-line-length-0 -fcheck=all -ffpe-trap=zero,overflow,underflow -finit-real=nan


#LDFLAGS =  -framework veclib -L/Users/martino/lib -luserfcn
#LDFLAGS =  -framework veclib
#LDFLAGS = -framework accelerate
LDFLAGS = -framework accelerate -fopenmp
#-L/System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/Versions/A -lBLAS -lLAPACK

# Rules...
FC  = gfortran
CC  = gcc
FC90= gfortran
SRCFILES =  $(FFILES)
OBJFILES = $(CFILES:.c=.o) $(FFILES:.f=.o) $(F90FILES:.f90=.o)

.f.o:
	$(FC) -c $(FFLAGS) ${OPT} $<

.c.o:
	$(CC) -c $(CFLAGS) $<


.f90.o:
	$(FC90) -c $(FFLAGS) ${OPT} $<
# actual build
$(NAME): $(OBJFILES) $(FFILES)   $(LIBG)
	$(FC) -o $@  $(FFLAGS)  $(OBJFILES) $(LIBG) $(LDFLAGS)
	chmod 640 $@
	chmod g+x $@
	chmod u+x $@
	cp -p $@ $(HOME)/bin

clean:
	rm -f *.o
	rm -f *.mod
