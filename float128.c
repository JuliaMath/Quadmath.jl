#include <stdio.h>
#include <stdint.h>
#include <quadmath.h>


typedef union
{
    __float128 value;

    struct{
        uint64_t u0;
        uint64_t u1;
    } words64;

} myfloat128;

typedef union
{
    __complex128 value;

    struct{
        uint64_t u0;
        uint64_t u1;
        uint64_t u2;
        uint64_t u3;
    } words64;

} mycomplex128;


#define F(x) (x.value)


myfloat128 convert_qd(double a) { myfloat128 res; F(res) = a; return res; } 
myfloat128 convert_qui(unsigned long a) {  myfloat128 res; F(res) = a; return res; }
myfloat128 convert_qsi(long a) {  myfloat128 res; F(res) = a; return res; }

double convert_dq(myfloat128 a) { return (double) F(a); }
float convert_fq(myfloat128 a) { return (float) F(a); }


myfloat128 neg_q(myfloat128 a) { myfloat128 res; F(res) =-F(a); return res; }

myfloat128 add_q(myfloat128 a, myfloat128 b) { myfloat128 res; F(res) = F(a)+F(b); return res; }
myfloat128 add_qd(myfloat128 a, double b) { myfloat128 res; F(res) = F(a)+b; return res; }
myfloat128 add_dq(double a, myfloat128 b) { myfloat128 res; F(res) = a+F(b); return res; }
myfloat128 add_uiq(unsigned long a, myfloat128 b) { myfloat128 res; F(res) = a+F(b); return res; }
myfloat128 add_qui(myfloat128 a, unsigned long b) { myfloat128 res; F(res) = F(a)+b; return res; }
myfloat128 add_siq(long a, myfloat128 b) { myfloat128 res; F(res) = a+F(b); return res; }
myfloat128 add_qsi(myfloat128 a, long b) { myfloat128 res; F(res) = F(a)+b; return res; }

myfloat128 sub_q(myfloat128 a, myfloat128 b) { myfloat128 res; F(res) = F(a)-F(b); return res; }
myfloat128 sub_qd(myfloat128 a, double b) { myfloat128 res; F(res) = F(a)-b; return res; }
myfloat128 sub_dq(double a, myfloat128 b) { myfloat128 res; F(res) = a-F(b); return res; }
myfloat128 sub_uiq(unsigned long a, myfloat128 b) { myfloat128 res; F(res) = a-F(b); return res; }
myfloat128 sub_qui(myfloat128 a, unsigned long b) { myfloat128 res; F(res) = F(a)-b; return res; }
myfloat128 sub_siq(long a, myfloat128 b) { myfloat128 res; F(res) = a-F(b); return res; }
myfloat128 sub_qsi(myfloat128 a, long b) { myfloat128 res; F(res) = F(a)-b; return res; }

myfloat128 mul_q(myfloat128 a, myfloat128 b) { myfloat128 res; F(res) = F(a)*F(b); return res; }
myfloat128 mul_qd(myfloat128 a, double b) { myfloat128 res; F(res) = F(a)*b; return res; }
myfloat128 mul_dq(double a, myfloat128 b) { myfloat128 res; F(res) = a*F(b); return res; }
myfloat128 mul_uiq(unsigned long a, myfloat128 b) { myfloat128 res; F(res) = a*F(b); return res; }
myfloat128 mul_qui(myfloat128 a, unsigned long b) { myfloat128 res; F(res) = F(a)*b; return res; }
myfloat128 mul_siq(long a, myfloat128 b) { myfloat128 res; F(res) = a*F(b); return res; }
myfloat128 mul_qsi(myfloat128 a, long b) { myfloat128 res; F(res) = F(a)*b; return res; }

myfloat128 div_q(myfloat128 a, myfloat128 b) { myfloat128 res; F(res) = F(a)/F(b); return res; }
myfloat128 div_qd(myfloat128 a, double b) { myfloat128 res; F(res) = F(a)/b; return res; }
myfloat128 div_dq(double a, myfloat128 b) { myfloat128 res; F(res) = a/F(b); return res; }
myfloat128 div_uiq(unsigned long a, myfloat128 b) { myfloat128 res; F(res) = a/F(b); return res; }
myfloat128 div_qui(myfloat128 a, unsigned long b) { myfloat128 res; F(res) = F(a)/b; return res; }
myfloat128 div_siq(long a, myfloat128 b) { myfloat128 res; F(res) = a/F(b); return res; }
myfloat128 div_qsi(myfloat128 a, long b) { myfloat128 res; F(res) = F(a)/b; return res; }


mycomplex128 cneg_q(mycomplex128 a) { mycomplex128 res; F(res) =-F(a); return res; }

mycomplex128 cadd_q(mycomplex128 a, mycomplex128 b) { mycomplex128 res; F(res) = F(a)+F(b); return res; }
mycomplex128 cadd_qd(mycomplex128 a, double b) { mycomplex128 res; F(res) = F(a)+b; return res; }
mycomplex128 cadd_dq(double a, mycomplex128 b) { mycomplex128 res; F(res) = a+F(b); return res; }
mycomplex128 cadd_qD(mycomplex128 a, myfloat128 b) { mycomplex128 res; F(res) = F(a)+F(b); return res; }
mycomplex128 cadd_Dq(myfloat128 a, mycomplex128 b) { mycomplex128 res; F(res) = F(a)+F(b); return res; }
mycomplex128 cadd_uiq(unsigned long a, mycomplex128 b) { mycomplex128 res; F(res) = a+F(b); return res; }
mycomplex128 cadd_qui(mycomplex128 a, unsigned long b) { mycomplex128 res; F(res) = F(a)+b; return res; }
mycomplex128 cadd_siq(long a, mycomplex128 b) { mycomplex128 res; F(res) = a+F(b); return res; }
mycomplex128 cadd_qsi(mycomplex128 a, long b) { mycomplex128 res; F(res) = F(a)+b; return res; }

mycomplex128 csub_q(mycomplex128 a, mycomplex128 b) { mycomplex128 res; F(res) = F(a)-F(b); return res; }
mycomplex128 csub_qd(mycomplex128 a, double b) { mycomplex128 res; F(res) = F(a)-b; return res; }
mycomplex128 csub_dq(double a, mycomplex128 b) { mycomplex128 res; F(res) = a-F(b); return res; }
mycomplex128 csub_qD(mycomplex128 a, myfloat128 b) { mycomplex128 res; F(res) = F(a)-F(b); return res; }
mycomplex128 csub_Dq(myfloat128 a, mycomplex128 b) { mycomplex128 res; F(res) = F(a)-F(b); return res; }
mycomplex128 csub_uiq(unsigned long a, mycomplex128 b) { mycomplex128 res; F(res) = a-F(b); return res; }
mycomplex128 csub_qui(mycomplex128 a, unsigned long b) { mycomplex128 res; F(res) = F(a)-b; return res; }
mycomplex128 csub_siq(long a, mycomplex128 b) { mycomplex128 res; F(res) = a-F(b); return res; }
mycomplex128 csub_qsi(mycomplex128 a, long b) { mycomplex128 res; F(res) = F(a)-b; return res; }

mycomplex128 cmul_q(mycomplex128 a, mycomplex128 b) { mycomplex128 res; F(res) = F(a)*F(b); return res; }
mycomplex128 cmul_qd(mycomplex128 a, double b) { mycomplex128 res; F(res) = F(a)*b; return res; }
mycomplex128 cmul_dq(double a, mycomplex128 b) { mycomplex128 res; F(res) = a*F(b); return res; }
mycomplex128 cmul_qD(mycomplex128 a, myfloat128 b) { mycomplex128 res; F(res) = F(a)*F(b); return res; }
mycomplex128 cmul_Dq(myfloat128 a, mycomplex128 b) { mycomplex128 res; F(res) = F(a)*F(b); return res; }
mycomplex128 cmul_uiq(unsigned long a, mycomplex128 b) { mycomplex128 res; F(res) = a*F(b); return res; }
mycomplex128 cmul_qui(mycomplex128 a, unsigned long b) { mycomplex128 res; F(res) = F(a)*b; return res; }
mycomplex128 cmul_siq(long a, mycomplex128 b) { mycomplex128 res; F(res) = a*F(b); return res; }
mycomplex128 cmul_qsi(mycomplex128 a, long b) { mycomplex128 res; F(res) = F(a)*b; return res; }

mycomplex128 cdiv_q(mycomplex128 a, mycomplex128 b) { mycomplex128 res; F(res) = F(a)/F(b); return res; }
mycomplex128 cdiv_qd(mycomplex128 a, double b) { mycomplex128 res; F(res) = F(a)/b; return res; }
mycomplex128 cdiv_dq(double a, mycomplex128 b) { mycomplex128 res; F(res) = a/F(b); return res; }
mycomplex128 cdiv_qD(mycomplex128 a, myfloat128 b) { mycomplex128 res; F(res) = F(a)/F(b); return res; }
mycomplex128 cdiv_Dq(myfloat128 a, mycomplex128 b) { mycomplex128 res; F(res) = F(a)/F(b); return res; }
mycomplex128 cdiv_uiq(unsigned long a, mycomplex128 b) { mycomplex128 res; F(res) = a/F(b); return res; }
mycomplex128 cdiv_qui(mycomplex128 a, unsigned long b) { mycomplex128 res; F(res) = F(a)/b; return res; }
mycomplex128 cdiv_siq(long a, mycomplex128 b) { mycomplex128 res; F(res) = a/F(b); return res; }
mycomplex128 cdiv_qsi(mycomplex128 a, long b) { mycomplex128 res; F(res) = F(a)/b; return res; }


int stringq(char *s, size_t size, const char *format, myfloat128 a)
{
    __float128 a1 = F(a);
    return quadmath_snprintf(s, size, format, a1);
}

/* myfloat128 (const char *s, char **sp) */
myfloat128 set_str_q(const char *s)
{
     myfloat128 res; F(res) = strtoflt128(s, NULL);
     return res;
}

int less_q(myfloat128 a, myfloat128 b) { return (F(a) < F(b)); }
int less_equal_q(myfloat128 a, myfloat128 b) { return (F(a) <= F(b)); }
int equal_q(myfloat128 a, myfloat128 b) { return (F(a) == F(b)); }
int greater_q(myfloat128 a, myfloat128 b) { return (F(a) > F(b)); }
int greater_equal_q(myfloat128 a, myfloat128 b) { return (F(a) >= F(b)); }

int less_qd(myfloat128 a, double b) { return (F(a) < b); }
int less_equal_qd(myfloat128 a, double b) { return (F(a) <= b); }
int equal_qd(myfloat128 a, double b) { return (F(a) == b); }
int greater_qd(myfloat128 a, double b) { return (F(a) > b); }
int greater_equal_qd(myfloat128 a, double b) { return (F(a) >= b); }

int less_dq(double a, myfloat128 b) { return (a < F(b)); }
int less_equal_dq(double a, myfloat128 b) { return (a <= F(b)); }
int equal_dq(double a, myfloat128 b) { return (a == F(b)); }
int greater_dq(double a, myfloat128 b) { return (a > F(b)); }
int greater_equal_dq(double a, myfloat128 b) { return (a >= F(b)); }

int less_qui(myfloat128 a, unsigned long b) { return (F(a) < b); }
int less_equal_qui(myfloat128 a, unsigned long b) { return (F(a) <= b); }
int equal_qui(myfloat128 a, unsigned long b) { return (F(a) == b); }
int greater_qui(myfloat128 a, unsigned long b) { return (F(a) > b); }
int greater_equal_qui(myfloat128 a, unsigned long b) { return (F(a) >= b); }

int less_uiq(unsigned long a, myfloat128 b) { return (a < F(b)); }
int less_equal_uiq(unsigned long a, myfloat128 b) { return (a <= F(b)); }
int equal_uiq(unsigned long a, myfloat128 b) { return (a == F(b)); }
int greater_uiq(unsigned long a, myfloat128 b) { return (a > F(b)); }
int greater_equal_uiq(unsigned long a, myfloat128 b) { return (a >= F(b)); }

int less_qsi(myfloat128 a, long b) { return (F(a) < b); }
int less_equal_qsi(myfloat128 a, long b) { return (F(a) <= b); }
int equal_qsi(myfloat128 a, long b) { return (F(a) == b); }
int greater_qsi(myfloat128 a, long b) { return (F(a) > b); }
int greater_equal_qsi(myfloat128 a, long b) { return (F(a) >= b); }

int less_siq(long a, myfloat128 b) { return (a < F(b)); }
int less_equal_siq(long a, myfloat128 b) { return (a <= F(b)); }
int equal_siq(long a, myfloat128 b) { return (a == F(b)); }
int greater_siq(long a, myfloat128 b) { return (a > F(b)); }
int greater_equal_siq(long a, myfloat128 b) { return (a >= F(b)); }




myfloat128 acos_q(myfloat128 x) { myfloat128 res; F(res) = acosq (F(x)); return res; }
myfloat128 acosh_q(myfloat128 x) { myfloat128 res; F(res) = acoshq (F(x)); return res; }
myfloat128 asin_q(myfloat128 x) { myfloat128 res; F(res) = asinq (F(x)); return res; }
myfloat128 asinh_q(myfloat128 x) { myfloat128 res; F(res) = asinhq (F(x)); return res; }
myfloat128 atan_q(myfloat128 x) { myfloat128 res; F(res) = atanq (F(x)); return res; }
myfloat128 atanh_q(myfloat128 x) { myfloat128 res; F(res) = atanhq (F(x)); return res; }
myfloat128 atan2_q(myfloat128 x, myfloat128 y) {  myfloat128 res; F(res) = atan2q (F(x), F(y)); return res; }
myfloat128 cbrt_q(myfloat128 x) { myfloat128 res; F(res) = cbrtq (F(x)); return res; }
myfloat128 ceil_q(myfloat128 x) { myfloat128 res; F(res) = ceilq (F(x)); return res; }
myfloat128 copysign_q(myfloat128 x, myfloat128 y) { myfloat128 res; F(res) = copysignq (F(x), F(y)); return res; }
myfloat128 cosh_q(myfloat128 x) { myfloat128 res; F(res) = coshq (F(x)); return res; }
myfloat128 cos_q(myfloat128 x) { myfloat128 res; F(res) = cosq (F(x)); return res; }
myfloat128 erf_q(myfloat128 x) { myfloat128 res; F(res) = erfq (F(x)); return res; }
myfloat128 erfc_q(myfloat128 x) { myfloat128 res; F(res) = erfcq (F(x)); return res; }
myfloat128 exp_q(myfloat128 x) { myfloat128 res; F(res) = expq (F(x)); return res; }
myfloat128 expm1_q(myfloat128 x) { myfloat128 res; F(res) = expm1q (F(x)); return res; }
myfloat128 abs_q(myfloat128 x) { myfloat128 res; F(res) = fabsq (F(x)); return res; }
myfloat128 fdim_q(myfloat128 x, myfloat128 y) { myfloat128 res; F(res) = fdimq (F(x), F(y)); return res; }
int finite_q(myfloat128 x) { return finiteq (F(x)); }
myfloat128 floor_q(myfloat128 x) { myfloat128 res; F(res) = floorq (F(x)); return res; }
myfloat128 fma_q(myfloat128 x, myfloat128 y, myfloat128 z) { myfloat128 res; F(res) = fmaq (F(x), F(y), F(z)); return res; }
myfloat128 max_q(myfloat128 x, myfloat128 y) { myfloat128 res; F(res) = fmaxq (F(x), F(y)); return res; }
myfloat128 min_q(myfloat128 x, myfloat128 y) { myfloat128 res; F(res) = fminq (F(x), F(y)); return res; }
myfloat128 fmod_q(myfloat128 x, myfloat128 y) { myfloat128 res; F(res) = fmodq (F(x), F(y)); return res; }
myfloat128 frexp_q(myfloat128 x, int *n) { myfloat128 res; F(res) = frexpq (F(x), n); return res; }
myfloat128 hypot_q(myfloat128 x, myfloat128 y) { myfloat128 res; F(res) = hypotq (F(x), F(y)); return res; }
int isinf_q(myfloat128 x) { return isinfq (F(x)); }
int ilogb_q(myfloat128 x) { return ilogbq (F(x)); }
int isnan_q(myfloat128 x) { return isnanq (F(x)); }
myfloat128 besselj0_q(myfloat128 x) { myfloat128 res; F(res) = j0q (F(x)); return res; }
myfloat128 besselj1_q(myfloat128 x) { myfloat128 res; F(res) = j1q (F(x)); return res; }
myfloat128 besselj_q(int n, myfloat128 x) { myfloat128 res; F(res) = jnq (n, F(x)); return res; }
myfloat128 ldexp_q(myfloat128 x, int n) { myfloat128 res; F(res) = ldexpq (F(x), n); return res; }
myfloat128 lgamma_q(myfloat128 x) { myfloat128 res; F(res) = lgammaq (F(x)); return res; }
long long int llrint_q(myfloat128 x) { return llrintq (F(x)); }
long long int llround_q(myfloat128 x) { return llroundq (F(x)); }
myfloat128 log_q(myfloat128 x) { myfloat128 res; F(res) = logq (F(x)); return res; }
myfloat128 log10_q(myfloat128 x) { myfloat128 res; F(res) = log10q (F(x)); return res; }
myfloat128 log2_q(myfloat128 x) { myfloat128 res; F(res) = log2q (F(x)); return res; }
myfloat128 log1p_q(myfloat128 x) { myfloat128 res; F(res) = log1pq (F(x)); return res; }
long int lrint_q(myfloat128 x) { return lrintq (F(x)); }
long int lround_q(myfloat128 x) { return lroundq (F(x)); }
myfloat128 modfq_q(myfloat128 x, myfloat128 *y) { myfloat128 res; F(res) = modfq (F(x), (__float128 *) y); return res; }
myfloat128 nan_q(const char *s) { myfloat128 res; F(res) = nanq (s); return res; }
myfloat128 nearbyint_q(myfloat128 x) { myfloat128 res; F(res) = nearbyintq (F(x)); return res; }
myfloat128 nextafter_q(myfloat128 x, myfloat128 y) { myfloat128 res; F(res) = nextafterq (F(x), F(y)); return res; }
myfloat128 pow_q(myfloat128 x, myfloat128 y) { myfloat128 res; F(res) = powq (F(x), F(y)); return res; }
myfloat128 remainder_q(myfloat128 x, myfloat128 y) { myfloat128 res; F(res) = remainderq (F(x), F(y)); return res; }
myfloat128 remquo_q(myfloat128 x, myfloat128 y, int *n) { myfloat128 res; F(res) = remquoq (F(x), F(y), n); return res; }
myfloat128 rint_q(myfloat128 x) { myfloat128 res; F(res) = rintq (F(x)); return res; }
myfloat128 round_q(myfloat128 x) { myfloat128 res; F(res) = roundq (F(x)); return res; }
myfloat128 scalbln_q(myfloat128 x, long int n) { myfloat128 res; F(res) = scalblnq (F(x), n); return res; }
myfloat128 scalbn_q(myfloat128 x, int n) { myfloat128 res; F(res) = scalbnq (F(x), n); return res; }
int signbit_q(myfloat128 x) { return  signbitq (F(x)); }
void sincos_q(myfloat128 x, myfloat128 *s, myfloat128 * c) { sincosq (F(x), (__float128 *) s, (__float128 *) c); }
myfloat128 sinh_q(myfloat128 x) { myfloat128 res; F(res) = sinhq (F(x)); return res; }
myfloat128 sin_q(myfloat128 x) { myfloat128 res; F(res) = sinq (F(x)); return res; }
myfloat128 sqrt_q(myfloat128 x) { myfloat128 res; F(res) = sqrtq (F(x)); return res; }
myfloat128 tan_q(myfloat128 x) { myfloat128 res; F(res) = tanq (F(x)); return res; }
myfloat128 tanh_q(myfloat128 x) { myfloat128 res; F(res) = tanhq (F(x)); return res; }
myfloat128 gamma_q(myfloat128 x) { myfloat128 res; F(res) = tgammaq (F(x)); return res; }
myfloat128 trunc_q(myfloat128 x) { myfloat128 res; F(res) = truncq (F(x)); return res; }
myfloat128 bessely0_q(myfloat128 x) { myfloat128 res; F(res) = y0q (F(x)); return res; }
myfloat128 bessely1_q(myfloat128 x) { myfloat128 res; F(res) = y1q (F(x)); return res; }
myfloat128 bessely_q(int n, myfloat128 x) { myfloat128 res; F(res) = ynq (n, F(x)); return res; }



myfloat128 cabs_q (mycomplex128 z) { myfloat128 res; F(res) = cabsq(F(z)); return res; };
myfloat128 cangle_q (mycomplex128 z) { myfloat128 res; F(res) = cargq(F(z)); return res; };
myfloat128 cimag_q (mycomplex128 z) { myfloat128 res; F(res) = cimagq(F(z)); return res; };
myfloat128 creal_q (mycomplex128 z) { myfloat128 res; F(res) = crealq(F(z)); return res; };
mycomplex128 cacos_q (mycomplex128 z) { mycomplex128 res; F(res) = cacosq(F(z)); return res; };
mycomplex128 cacosh_q (mycomplex128 z) { mycomplex128 res; F(res) = cacoshq(F(z)); return res; };
mycomplex128 casin_q (mycomplex128 z) { mycomplex128 res; F(res) = casinq(F(z)); return res; };
mycomplex128 casinh_q (mycomplex128 z) { mycomplex128 res; F(res) = casinhq(F(z)); return res; };
mycomplex128 catan_q (mycomplex128 z) { mycomplex128 res; F(res) = catanq(F(z)); return res; };
mycomplex128 catanh_q (mycomplex128 z) { mycomplex128 res; F(res) = catanhq(F(z)); return res; };
mycomplex128 ccos_q (mycomplex128 z) { mycomplex128 res; F(res) = ccosq(F(z)); return res; };
mycomplex128 ccosh_q (mycomplex128 z) { mycomplex128 res; F(res) = ccoshq(F(z)); return res; };
mycomplex128 cexp_q (mycomplex128 z) { mycomplex128 res; F(res) = cexpq(F(z)); return res; };
mycomplex128 ccis_q (myfloat128 z) { mycomplex128 res; F(res) = cexpiq(F(z)); return res; };
mycomplex128 clog_q (mycomplex128 z) { mycomplex128 res; F(res) = clogq(F(z)); return res; };
mycomplex128 clog10_q (mycomplex128 z) { mycomplex128 res; F(res) = clog10q(F(z)); return res; };
mycomplex128 cconj_q (mycomplex128 z) { mycomplex128 res; F(res) = conjq(F(z)); return res; };
mycomplex128 cpow_q (mycomplex128 z, mycomplex128 w) { mycomplex128 res; F(res) = cpowq(F(z), F(w)); return res; };
mycomplex128 cproj_q (mycomplex128 z) { mycomplex128 res; F(res) = cprojq(F(z)); return res; };
mycomplex128 csin_q (mycomplex128 z) { mycomplex128 res; F(res) = csinq(F(z)); return res; };
mycomplex128 csinh_q (mycomplex128 z) { mycomplex128 res; F(res) = csinhq(F(z)); return res; };
mycomplex128 csqrt_q (mycomplex128 z) { mycomplex128 res; F(res) = csqrtq(F(z)); return res; };
mycomplex128 ctan_q (mycomplex128 z) { mycomplex128 res; F(res) = ctanq(F(z)); return res; };
mycomplex128 ctanh_q (mycomplex128 z) { mycomplex128 res; F(res) = ctanhq(F(z)); return res; };


myfloat128 eps_q (void) {myfloat128 res; F(res) = FLT128_EPSILON; return res; };
myfloat128 realmax_q (void) {myfloat128 res; F(res) = FLT128_MAX; return res; };
myfloat128 realmin_q (void) {myfloat128 res; F(res) = FLT128_MIN; return res; };
myfloat128 pi_q (void) {myfloat128 res; F(res) =  M_PIq; return res; };
myfloat128 e_q (void) {myfloat128 res; F(res) = M_Eq; return res; };



