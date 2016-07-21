#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"
#include "petrovich.h"

#define MY_CXT_KEY "MR::Petrovich::XS::_guts" XS_VERSION

typedef struct {
    petr_context_t* petr_ctx;
} my_cxt_t;

START_MY_CXT;

SV * _inflect(const char *data, size_t len, petr_name_kind_t kind, petr_gender_t gender, petr_case_t dest_case) {
    dMY_CXT;

    size_t dest_buf_size = len*2;
    SV *ret = newSVpvn("",dest_buf_size);

    char *dest = SvPVutf8_nolen(ret);
    size_t dest_len;

    int code = petr_inflect(MY_CXT.petr_ctx,data,len,kind,gender,dest_case,dest,dest_buf_size,&dest_len); 
    if(code != 0) return &PL_sv_undef;
    
    SvCUR_set(ret, dest_len);
    return ret;
}

MODULE = MR::Petrovich::XS		PACKAGE = MR::Petrovich::XS		

BOOT:
{
    MY_CXT_INIT;
    MY_CXT.petr_ctx = NULL;
}

int 
init_from_file(path)
    const char *path
CODE:
    dMY_CXT;
    RETVAL = petr_init_from_file(path, &MY_CXT.petr_ctx);
OUTPUT:
    RETVAL

void
free_context()
CODE:
    dMY_CXT;
    petr_free_context(MY_CXT.petr_ctx);

SV *
_inflect_name(data,len,kind,gender,dest_case)
    const char *data
    size_t len
    petr_name_kind_t kind
    petr_gender_t gender
    petr_case_t dest_case
CODE:
    RETVAL = _inflect(data,len,kind,gender,dest_case);
OUTPUT:
    RETVAL

SV *
_inflect_first_name(data,len,gender,dest_case)
    const char *data
    size_t len
    petr_gender_t gender
    petr_case_t dest_case
CODE:
    RETVAL = _inflect(data,len,NAME_FIRST,gender,dest_case);
OUTPUT:
    RETVAL

SV *
_inflect_middle_name(data,len,gender,dest_case)
    const char *data
    size_t len
    petr_gender_t gender
    petr_case_t dest_case
CODE:
    RETVAL = _inflect(data,len,NAME_MIDDLE,gender,dest_case);
OUTPUT:
    RETVAL

SV *
_inflect_last_name(data,len,gender,dest_case)
    const char *data
    size_t len
    petr_gender_t gender
    petr_case_t dest_case
CODE:
    RETVAL = _inflect(data,len,NAME_LAST,gender,dest_case);
OUTPUT:
    RETVAL
