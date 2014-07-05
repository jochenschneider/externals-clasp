##
# config/mpigen/mk_c_wrapper.sh.  Generated from mk_c_wrapper.sh.in by configure.
#
# make vtlib/vt_mpiwrap.gen.c
##

# exit the script if any statement returns a non-true return value
set -e



export SRCDIR=/home/meister/Development/dependent-clasp/openmpi-1.6.5/ompi/contrib/vt/vt/config/mpigen

have_mpi2_thread=1
have_mpi2_1sided=1
have_mpi2_extcoll=1
have_mpi2_file=1
have_mpi2_proc=0 #@VT_MPIGEN_HAVE_MPI2_PROC@
have_mpi2=0
if [ $have_mpi2_thread = 1 -o $have_mpi2_1sided = 1 -o $have_mpi2_extcoll = 1 -o $have_mpi2_proc = 1 ] ; then
  have_mpi2=1
fi
mpi2_src1=""; if [ $have_mpi2 = 1 ] ; then mpi2_src1="mpi2_standard.h"; fi
mpi2_src2=""; if [ $have_mpi2_thread = 1 ] ; then mpi2_src2="mpi2_thread.h"; fi
mpi2_src3=""; if [ $have_mpi2_1sided = 1 ] ; then mpi2_src3="mpi2_1sided.h"; fi
mpi2_src4=""; if [ $have_mpi2_extcoll = 1 ] ; then mpi2_src4="mpi2_extcoll.h"; fi
mpi2_src5=""; if [ $have_mpi2_file = 1 ] ; then mpi2_src5="mpi2_file.h"; fi
mpi2_src6=""; if [ $have_mpi2_proc = 1 ] ; then mpi2_src6="mpi2_proc.h"; fi
src="mpi_standard.h $mpi2_src1 $mpi2_src2 $mpi2_src3 $mpi2_src4 $mpi2_src5 $mpi2_src6"

out=/home/meister/Development/dependent-clasp/openmpi-1.6.5/ompi/contrib/vt/vt/vtlib/vt_mpiwrap.gen.c
tmp=tmp$$
trap "rm -f $tmp.*; exit" 0 1 2 3 15

rm -f $tmp.tmp $out
for s in $src; do
  if [ ! -f $SRCDIR/$s ] ; then
    echo "$0: error: $SRCDIR/$s not found!"
    exit 1
  fi

  grep ' MPI_.*(.*)' $SRCDIR/$s \
  | sed >>$tmp.tmp \
    -e '/typedef /d' \
    -e 's/( *void *)/()/' \
    -e 's/   */ /g' \
    -e 's/ /,/' \
    -e 's/(/,/' \
    -e 's/);//' \
    -e 's/, /,/g' \
    -e 's/,$//'
done

cat <<End-of-File >$tmp.c
/**
 * VampirTrace
 * http://www.tu-dresden.de/zih/vampirtrace
 *
 * Copyright (c) 2005-2013, ZIH, TU Dresden, Federal Republic of Germany
 *
 * Copyright (c) 1998-2005, Forschungszentrum Juelich, Juelich Supercomputing
 *                          Centre, Federal Republic of Germany
 *
 * See the file COPYING in the package base directory for details
 *
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 * ! BUILT BY mk_c_wrapper.sh; DO NOT EDIT THIS FILE       !
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 **/

End-of-File

cat <<End-of-File >$tmp.awk
{
# C wrapper
#
# \$1 is the return type
# \$2 is the call name
# \$3,\$4,... parameters
  call= "grep -i \\"^"\$2"\$\\" \$SRCDIR/c_dont_generate.txt > /dev/null"
  generate=system(call)

  rettype=\$1  
  mpicall=\$2

  if (!generate) {
    printf "/* -- %s -- not generated */\n\n", mpicall
    next
  }

  optional=0

  if (index(mpicall,"MPI_Add_error_class") != 0) {
    printf "#if defined(HAVE_MPI_ADD_ERROR_CLASS) && HAVE_MPI_ADD_ERROR_CLASS\n\n"
    optional=1
  }
  if (index(mpicall,"MPI_Add_error_code") != 0) {
    printf "#if defined(HAVE_MPI_ADD_ERROR_CODE) && HAVE_MPI_ADD_ERROR_CODE\n\n"
    optional=1
  }
  if (index(mpicall,"MPI_Add_error_string") != 0) {
    printf "#if defined(HAVE_MPI_ADD_ERROR_STRING) && HAVE_MPI_ADD_ERROR_STRING\n\n"
    optional=1
  }
  if (index(mpicall,"MPI_Type_create_f90_complex") != 0) {
    printf "#if defined(HAVE_MPI_TYPE_CREATE_F90_COMPLEX) && HAVE_MPI_TYPE_CREATE_F90_COMPLEX\n\n"
    optional=1
  }
  if (index(mpicall,"MPI_Type_create_f90_integer") != 0) {
    printf "#if defined(HAVE_MPI_TYPE_CREATE_F90_INTEGER) && HAVE_MPI_TYPE_CREATE_F90_INTEGER\n\n"
    optional=1
  }
  if (index(mpicall,"MPI_Type_create_f90_real") != 0) {
    printf "#if defined(HAVE_MPI_TYPE_CREATE_F90_REAL) && HAVE_MPI_TYPE_CREATE_F90_REAL\n\n"
    optional=1
  }
  if (index(mpicall,"MPI_Type_match_size") != 0) {
    printf "#if defined(HAVE_MPI_TYPE_MATCH_SIZE) && HAVE_MPI_TYPE_MATCH_SIZE\n\n"
    optional=1
  }
  if (index(mpicall,"MPI_Win_test") != 0) {
    printf "#if defined(HAVE_PMPI_WIN_TEST) && HAVE_PMPI_WIN_TEST\n\n"
    optional=1
  }
  if (index(mpicall,"MPI_Win_lock") != 0) {
    printf "#if defined(HAVE_PMPI_WIN_LOCK) && HAVE_PMPI_WIN_LOCK\n\n"
    optional=1
  }
  if (index(mpicall,"MPI_Win_unlock") != 0) {
    printf "#if defined(HAVE_PMPI_WIN_UNLOCK) && HAVE_PMPI_WIN_UNLOCK\n\n"
    optional=1
  }
  if (index(mpicall,"MPI_Register_datarep") != 0) {
    printf "#if defined(HAVE_MPI_REGISTER_DATAREP) && HAVE_MPI_REGISTER_DATAREP\n\n"
    optional=1
  }

  printf "/* -- %s -- */\n\n", mpicall

  printf "%s %s(", rettype, mpicall
  
  if (NF > 2) {
    for (i=3; i<=NF; i++) {
      n=split(\$i,typeandpara," ")
      j=1
      if (i > 3) printf ", "
      if (n == 3) printf "%s ",typeandpara[j++]
      type[i-2]=typeandpara[j++]
      para[i-2]=typeandpara[j]
      printf "%s %s",type[i-2],para[i-2]
    }
  }
  print ")"
  print "{"

  printf"  %s result;\n", rettype
  print "  uint32_t tid;"
  print ""
  print "  GET_THREAD_ID(tid);"
  print ""
  print "  if (IS_MPI_TRACE_ON(tid))"
  print "  {"
  print "    uint64_t time;"
  print "    uint8_t was_recorded;"
  print ""
  print "    MPI_TRACE_OFF(tid);"
  print ""
  print "    time = vt_pform_wtime();"
  printf"    was_recorded = vt_enter(tid, &time, vt_mpi_regid[VT__%s]);\n", toupper(mpicall)
  print ""
  printf"    VT_UNIMCI_CHECK_PRE(%s,\n", mpicall
  printf"      ("
  if (NF > 2) {
    for (i=3; i<=NF; i++) {
      gsub("[[].*[]]","",para[i-2])
      printf para[i-2]
      printf", "
    }
  }
  print "\"\", 0, 0),"
  print "      was_recorded, &time);"
  print ""
  printf"    result = P%s(", mpicall
  if (NF > 2) {
    for (i=3; i<=NF; i++) {
      gsub("[[].*[]]","",para[i-2])
      printf para[i-2]
      if (i < NF) {
        printf", "
      }
    }
  }
  print ");"
  print ""
  printf"    VT_UNIMCI_CHECK_POST(%s,\n", mpicall
  printf"      ("
  if (NF > 2) {
    for (i=3; i<=NF; i++) {
      gsub("[[].*[]]","",para[i-2])
      printf para[i-2]
      printf ", "
    }
  }
  print "\"\", 0, 0),"
  print "      was_recorded, &time);"
  print ""
  print "    time = vt_pform_wtime();"
  print "    vt_exit(tid, &time);"
  print ""
  print "    MPI_TRACE_ON(tid);"
  print "  }"
  print "  else"
  print "  {"
  printf"    result = P%s(", mpicall
  if (NF > 2) {
    for (i=3; i<=NF; i++) {
      gsub("[[].*[]]","",para[i-2])
      printf para[i-2]
      if (i < NF) {
        printf", "
      }
    }
  }
  print ");"
  print "  }"
  print ""
  print "  return result;"
  print "}"
  print ""

  if (optional) {
    printf "#endif\n\n"
  }
}
End-of-File

gawk -f $tmp.awk -F, <$tmp.tmp >>$tmp.c
if test $? -ne 0; then exit $?; fi

mv $tmp.c $out
rm $tmp.awk

exit 0
