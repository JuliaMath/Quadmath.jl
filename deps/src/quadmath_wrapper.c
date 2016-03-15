#include <stdio.h>
#include <stdint.h>
#include <quadmath.h>
#include "quadmath_wrapper.h"


myfloat128 convert_qd(double a) { __float128 res; res = a; return W(res); } 
myfloat128 convert_qui(unsigned long a) { __float128 res; res = a; return W(res); }
myfloat128 convert_qsi(long a) { __float128 res; res = a; return W(res); }

double convert_dq(myfloat128 a) { return (double) F(a); }
float convert_fq(myfloat128 a) { return (float) F(a); }

myfloat128 neg_q(myfloat128 a) { __float128 res; res = -F(a); return W(res); }

myfloat128 add_q(myfloat128 a, myfloat128 b) { __float128 res; res = F(a)+F(b); return W(res); }
myfloat128 add_qd(myfloat128 a, double b) { __float128 res; res = F(a)+b; return W(res); }
myfloat128 add_dq(double a, myfloat128 b) { __float128 res; res = a+F(b); return W(res); }
myfloat128 add_uiq(unsigned long a, myfloat128 b) { __float128 res; res = a+F(b); return W(res); }
myfloat128 add_qui(myfloat128 a, unsigned long b) { __float128 res; res = F(a)+b; return W(res); }
myfloat128 add_siq(long a, myfloat128 b) { __float128 res; res = a+F(b); return W(res); }
myfloat128 add_qsi(myfloat128 a, long b) { __float128 res; res = F(a)+b; return W(res); }

myfloat128 sub_q(myfloat128 a, myfloat128 b) { __float128 res; res = F(a)-F(b); return W(res); }
myfloat128 sub_qd(myfloat128 a, double b) { __float128 res; res = F(a)-b; return W(res); }
myfloat128 sub_dq(double a, myfloat128 b) { __float128 res; res = a-F(b); return W(res); }
myfloat128 sub_uiq(unsigned long a, myfloat128 b) { __float128 res; res = a-F(b); return W(res); }
myfloat128 sub_qui(myfloat128 a, unsigned long b) { __float128 res; res = F(a)-b; return W(res); }
myfloat128 sub_siq(long a, myfloat128 b) { __float128 res; res = a-F(b); return W(res); }
myfloat128 sub_qsi(myfloat128 a, long b) { __float128 res; res = F(a)-b; return W(res); }

myfloat128 mul_q(myfloat128 a, myfloat128 b) { __float128 res; res = F(a)*F(b); return W(res); }
myfloat128 mul_qd(myfloat128 a, double b) { __float128 res; res = F(a)*b; return W(res); }
myfloat128 mul_dq(double a, myfloat128 b) { __float128 res; res = a*F(b); return W(res); }
myfloat128 mul_uiq(unsigned long a, myfloat128 b) { __float128 res; res = a*F(b); return W(res); }
myfloat128 mul_qui(myfloat128 a, unsigned long b) { __float128 res; res = F(a)*b; return W(res); }
myfloat128 mul_siq(long a, myfloat128 b) { __float128 res; res = a*F(b); return W(res); }
myfloat128 mul_qsi(myfloat128 a, long b) { __float128 res; res = F(a)*b; return W(res); }

myfloat128 div_q(myfloat128 a, myfloat128 b) { __float128 res; res = F(a)/F(b); return W(res); }
myfloat128 div_qd(myfloat128 a, double b) { __float128 res; res = F(a)/b; return W(res); }
myfloat128 div_dq(double a, myfloat128 b) { __float128 res; res = a/F(b); return W(res); }
myfloat128 div_uiq(unsigned long a, myfloat128 b) { __float128 res; res = a/F(b); return W(res); }
myfloat128 div_qui(myfloat128 a, unsigned long b) { __float128 res; res = F(a)/b; return W(res); }
myfloat128 div_siq(long a, myfloat128 b) { __float128 res; res = a/F(b); return W(res); }
myfloat128 div_qsi(myfloat128 a, long b) { __float128 res; res = F(a)/b; return W(res); }

mycomplex128 cneg_q(mycomplex128 a) { __complex128 res; res = -C(a); return Z(res); }

mycomplex128 cadd_q(mycomplex128 a, mycomplex128 b) { __complex128 res; res = C(a)+C(b); return Z(res); }
mycomplex128 cadd_qd(mycomplex128 a, double b) { __complex128 res; res = C(a)+b; return Z(res); }
mycomplex128 cadd_dq(double a, mycomplex128 b) { __complex128 res; res = a+C(b); return Z(res); }
mycomplex128 cadd_qD(mycomplex128 a, myfloat128 b) { __complex128 res; res = C(a)+C(b); return Z(res); }
mycomplex128 cadd_Dq(myfloat128 a, mycomplex128 b) { __complex128 res; res = C(a)+C(b); return Z(res); }
mycomplex128 cadd_uiq(unsigned long a, mycomplex128 b) { __complex128 res; res = a+C(b); return Z(res); }
mycomplex128 cadd_qui(mycomplex128 a, unsigned long b) { __complex128 res; res = C(a)+b; return Z(res); }
mycomplex128 cadd_siq(long a, mycomplex128 b) { __complex128 res; res = a+C(b); return Z(res); }
mycomplex128 cadd_qsi(mycomplex128 a, long b) { __complex128 res; res = C(a)+b; return Z(res); }

mycomplex128 csub_q(mycomplex128 a, mycomplex128 b) { __complex128 res; res = C(a)-C(b); return Z(res); }
mycomplex128 csub_qd(mycomplex128 a, double b) { __complex128 res; res = C(a)-b; return Z(res); }
mycomplex128 csub_dq(double a, mycomplex128 b) { __complex128 res; res = a-C(b); return Z(res); }
mycomplex128 csub_qD(mycomplex128 a, myfloat128 b) { __complex128 res; res = C(a)-C(b); return Z(res); }
mycomplex128 csub_Dq(myfloat128 a, mycomplex128 b) { __complex128 res; res = C(a)-C(b); return Z(res); }
mycomplex128 csub_uiq(unsigned long a, mycomplex128 b) { __complex128 res; res = a-C(b); return Z(res); }
mycomplex128 csub_qui(mycomplex128 a, unsigned long b) { __complex128 res; res = C(a)-b; return Z(res); }
mycomplex128 csub_siq(long a, mycomplex128 b) { __complex128 res; res = a-C(b); return Z(res); }
mycomplex128 csub_qsi(mycomplex128 a, long b) { __complex128 res; res = C(a)-b; return Z(res); }

mycomplex128 cmul_q(mycomplex128 a, mycomplex128 b) { __complex128 res; res = C(a)*C(b); return Z(res); }
mycomplex128 cmul_qd(mycomplex128 a, double b) { __complex128 res; res = C(a)*b; return Z(res); }
mycomplex128 cmul_dq(double a, mycomplex128 b) { __complex128 res; res = a*C(b); return Z(res); }
mycomplex128 cmul_qD(mycomplex128 a, myfloat128 b) { __complex128 res; res = C(a)*C(b); return Z(res); }
mycomplex128 cmul_Dq(myfloat128 a, mycomplex128 b) { __complex128 res; res = C(a)*C(b); return Z(res); }
mycomplex128 cmul_uiq(unsigned long a, mycomplex128 b) { __complex128 res; res = a*C(b); return Z(res); }
mycomplex128 cmul_qui(mycomplex128 a, unsigned long b) { __complex128 res; res = C(a)*b; return Z(res); }
mycomplex128 cmul_siq(long a, mycomplex128 b) { __complex128 res; res = a*C(b); return Z(res); }
mycomplex128 cmul_qsi(mycomplex128 a, long b) { __complex128 res; res = C(a)*b; return Z(res); }

mycomplex128 cdiv_q(mycomplex128 a, mycomplex128 b) { __complex128 res; res = C(a)/C(b); return Z(res); }
mycomplex128 cdiv_qd(mycomplex128 a, double b) { __complex128 res; res = C(a)/b; return Z(res); }
mycomplex128 cdiv_dq(double a, mycomplex128 b) { __complex128 res; res = a/C(b); return Z(res); }
mycomplex128 cdiv_qD(mycomplex128 a, myfloat128 b) { __complex128 res; res = C(a)/C(b); return Z(res); }
mycomplex128 cdiv_Dq(myfloat128 a, mycomplex128 b) { __complex128 res; res = C(a)/C(b); return Z(res); }
mycomplex128 cdiv_uiq(unsigned long a, mycomplex128 b) { __complex128 res; res = a/C(b); return Z(res); }
mycomplex128 cdiv_qui(mycomplex128 a, unsigned long b) { __complex128 res; res = C(a)/b; return Z(res); }
mycomplex128 cdiv_siq(long a, mycomplex128 b) { __complex128 res; res = a/C(b); return Z(res); }
mycomplex128 cdiv_qsi(mycomplex128 a, long b) { __complex128 res; res = C(a)/b; return Z(res); }


int stringq(char *s, size_t size, const char *format, myfloat128 a)
{
    __float128 a1 = F(a);
    return quadmath_snprintf(s, size, format, a1);
}

/* myfloat128 (const char *s, char **sp) */
myfloat128 set_str_q(const char *s)
{
     __float128 res = strtoflt128(s, NULL);
     return W(res);
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


myfloat128 acos_q(myfloat128 x) { __float128 res; res = acosq (F(x)); return W(res); }
myfloat128 acosh_q(myfloat128 x) { __float128 res; res = acoshq (F(x)); return W(res); }
myfloat128 asin_q(myfloat128 x) { __float128 res; res = asinq (F(x)); return W(res); }
myfloat128 asinh_q(myfloat128 x) { __float128 res; res = asinhq (F(x)); return W(res); }
myfloat128 atan_q(myfloat128 x) { __float128 res; res = atanq (F(x)); return W(res); }
myfloat128 atanh_q(myfloat128 x) { __float128 res; res = atanhq (F(x)); return W(res); }
myfloat128 atan2_q(myfloat128 x, myfloat128 y) {  __float128 res; res = atan2q (F(x), F(y)); return W(res); }
myfloat128 cbrt_q(myfloat128 x) { __float128 res; res = cbrtq (F(x)); return W(res); }
myfloat128 ceil_q(myfloat128 x) { __float128 res; res = ceilq (F(x)); return W(res); }
myfloat128 copysign_q(myfloat128 x, myfloat128 y) { __float128 res; res = copysignq (F(x), F(y)); return W(res); }
myfloat128 cosh_q(myfloat128 x) { __float128 res; res = coshq (F(x)); return W(res); }
myfloat128 cos_q(myfloat128 x) { __float128 res; res = cosq (F(x)); return W(res); }
myfloat128 erf_q(myfloat128 x) { __float128 res; res = erfq (F(x)); return W(res); }
myfloat128 erfc_q(myfloat128 x) { __float128 res; res = erfcq (F(x)); return W(res); }
myfloat128 exp_q(myfloat128 x) { __float128 res; res = expq (F(x)); return W(res); }
myfloat128 expm1_q(myfloat128 x) { __float128 res; res = expm1q (F(x)); return W(res); }
myfloat128 abs_q(myfloat128 x) { __float128 res; res = fabsq (F(x)); return W(res); }
myfloat128 fdim_q(myfloat128 x, myfloat128 y) { __float128 res; res = fdimq (F(x), F(y)); return W(res); }
int finite_q(myfloat128 x) { return finiteq (F(x)); }
myfloat128 floor_q(myfloat128 x) { __float128 res; res = floorq (F(x)); return W(res); }
myfloat128 fma_q(myfloat128 x, myfloat128 y, myfloat128 z) { __float128 res; res = fmaq (F(x), F(y), F(z)); return W(res); }
myfloat128 max_q(myfloat128 x, myfloat128 y) { __float128 res; res = fmaxq (F(x), F(y)); return W(res); }
myfloat128 min_q(myfloat128 x, myfloat128 y) { __float128 res; res = fminq (F(x), F(y)); return W(res); }
myfloat128 fmod_q(myfloat128 x, myfloat128 y) { __float128 res; res = fmodq (F(x), F(y)); return W(res); }
myfloat128 frexp_q(myfloat128 x, int *n) { __float128 res; res = frexpq (F(x), n); return W(res); }
myfloat128 hypot_q(myfloat128 x, myfloat128 y) { __float128 res; res = hypotq (F(x), F(y)); return W(res); }
int isinf_q(myfloat128 x) { return isinfq (F(x)); }
int ilogb_q(myfloat128 x) { return ilogbq (F(x)); }
int isnan_q(myfloat128 x) { return isnanq (F(x)); }
myfloat128 besselj0_q(myfloat128 x) { __float128 res; res = j0q (F(x)); return W(res); }
myfloat128 besselj1_q(myfloat128 x) { __float128 res; res = j1q (F(x)); return W(res); }
myfloat128 besselj_q(int n, myfloat128 x) { __float128 res; res = jnq (n, F(x)); return W(res); }
myfloat128 ldexp_q(myfloat128 x, int n) { __float128 res; res = ldexpq (F(x), n); return W(res); }
myfloat128 lgamma_q(myfloat128 x) { __float128 res; res = lgammaq (F(x)); return W(res); }
long long int llrint_q(myfloat128 x) { return llrintq (F(x)); }
long long int llround_q(myfloat128 x) { return llroundq (F(x)); }
myfloat128 log_q(myfloat128 x) { __float128 res; res = logq (F(x)); return W(res); }
myfloat128 log10_q(myfloat128 x) { __float128 res; res = log10q (F(x)); return W(res); }
myfloat128 log2_q(myfloat128 x) { __float128 res; res = log2q (F(x)); return W(res); }
myfloat128 log1p_q(myfloat128 x) { __float128 res; res = log1pq (F(x)); return W(res); }
long int lrint_q(myfloat128 x) { return lrintq (F(x)); }
long int lround_q(myfloat128 x) { return lroundq (F(x)); }
myfloat128 modfq_q(myfloat128 x, myfloat128 *y) { __float128 res; res = modfq (F(x), (__float128 *) y); return W(res); }
myfloat128 nan_q(const char *s) { __float128 res; res = nanq (s); return W(res); }
myfloat128 nearbyint_q(myfloat128 x) { __float128 res; res = nearbyintq (F(x)); return W(res); }
myfloat128 nextafter_q(myfloat128 x, myfloat128 y) { __float128 res; res = nextafterq (F(x), F(y)); return W(res); }
myfloat128 pow_q(myfloat128 x, myfloat128 y) { __float128 res; res = powq (F(x), F(y)); return W(res); }
myfloat128 remainder_q(myfloat128 x, myfloat128 y) { __float128 res; res = remainderq (F(x), F(y)); return W(res); }
myfloat128 remquo_q(myfloat128 x, myfloat128 y, int *n) { __float128 res; res = remquoq (F(x), F(y), n); return W(res); }
myfloat128 rint_q(myfloat128 x) { __float128 res; res = rintq (F(x)); return W(res); }
myfloat128 round_q(myfloat128 x) { __float128 res; res = roundq (F(x)); return W(res); }
myfloat128 scalbln_q(myfloat128 x, long int n) { __float128 res; res = scalblnq (F(x), n); return W(res); }
myfloat128 scalbn_q(myfloat128 x, int n) { __float128 res; res = scalbnq (F(x), n); return W(res); }
int signbit_q(myfloat128 x) { return  signbitq (F(x)); }
void sincos_q(myfloat128 x, myfloat128 *s, myfloat128 * c) { sincosq (F(x), (__float128 *) s, (__float128 *) c); }
myfloat128 sinh_q(myfloat128 x) { __float128 res; res = sinhq (F(x)); return W(res); }
myfloat128 sin_q(myfloat128 x) { __float128 res; res = sinq (F(x)); return W(res); }
myfloat128 sqrt_q(myfloat128 x) { __float128 res; res = sqrtq (F(x)); return W(res); }
myfloat128 tan_q(myfloat128 x) { __float128 res; res = tanq (F(x)); return W(res); }
myfloat128 tanh_q(myfloat128 x) { __float128 res; res = tanhq (F(x)); return W(res); }
myfloat128 gamma_q(myfloat128 x) { __float128 res; res = tgammaq (F(x)); return W(res); }
myfloat128 trunc_q(myfloat128 x) { __float128 res; res = truncq (F(x)); return W(res); }
myfloat128 bessely0_q(myfloat128 x) { __float128 res; res = y0q (F(x)); return W(res); }
myfloat128 bessely1_q(myfloat128 x) { __float128 res; res = y1q (F(x)); return W(res); }
myfloat128 bessely_q(int n, myfloat128 x) { __float128 res; res = ynq (n, F(x)); return W(res); }


myfloat128 cabs_q (mycomplex128 z) { __float128 res; res = cabsq(C(z)); return W(res); }
myfloat128 cangle_q (mycomplex128 z) { __float128 res; res = cargq(C(z)); return W(res); }
myfloat128 cimag_q (mycomplex128 z) { __float128 res; res = cimagq(C(z)); return W(res); }
myfloat128 creal_q (mycomplex128 z) { __float128 res; res = crealq(C(z)); return W(res); }
mycomplex128 cacos_q (mycomplex128 z) { __complex128 res; res = cacosq(C(z)); return Z(res); }
mycomplex128 cacosh_q (mycomplex128 z) { __complex128 res; res = cacoshq(C(z)); return Z(res); }
mycomplex128 casin_q (mycomplex128 z) { __complex128 res; res = casinq(C(z)); return Z(res); }
mycomplex128 casinh_q (mycomplex128 z) { __complex128 res; res = casinhq(C(z)); return Z(res); }
mycomplex128 catan_q (mycomplex128 z) { __complex128 res; res = catanq(C(z)); return Z(res); }
mycomplex128 catanh_q (mycomplex128 z) { __complex128 res; res = catanhq(C(z)); return Z(res); }
mycomplex128 ccos_q (mycomplex128 z) { __complex128 res; res = ccosq(C(z)); return Z(res); }
mycomplex128 ccosh_q (mycomplex128 z) { __complex128 res; res = ccoshq(C(z)); return Z(res); }
mycomplex128 cexp_q (mycomplex128 z) { __complex128 res; res = cexpq(C(z)); return Z(res); }
mycomplex128 ccis_q (myfloat128 z) { __complex128 res; res = cexpiq(C(z)); return Z(res); }
mycomplex128 clog_q (mycomplex128 z) { __complex128 res; res = clogq(C(z)); return Z(res); }
mycomplex128 clog10_q (mycomplex128 z) { __complex128 res; res = clog10q(C(z)); return Z(res); }
mycomplex128 cconj_q (mycomplex128 z) { __complex128 res; res = conjq(C(z)); return Z(res); }
mycomplex128 cpow_q (mycomplex128 z, mycomplex128 w) { __complex128 res; res = cpowq(C(z), C(w)); return Z(res); }
mycomplex128 cproj_q (mycomplex128 z) { __complex128 res; res = cprojq(C(z)); return Z(res); }
mycomplex128 csin_q (mycomplex128 z) { __complex128 res; res = csinq(C(z)); return Z(res); }
mycomplex128 csinh_q (mycomplex128 z) { __complex128 res; res = csinhq(C(z)); return Z(res); }
mycomplex128 csqrt_q (mycomplex128 z) { __complex128 res; res = csqrtq(C(z)); return Z(res); }
mycomplex128 ctan_q (mycomplex128 z) { __complex128 res; res = ctanq(C(z)); return Z(res); }
mycomplex128 ctanh_q (mycomplex128 z) { __complex128 res; res = ctanhq(C(z)); return Z(res); }


myfloat128 eps_q (void) {__float128 res; res = FLT128_EPSILON; return W(res); };
myfloat128 realmax_q (void) {__float128 res; res = FLT128_MAX; return W(res); };
myfloat128 realmin_q (void) {__float128 res; res = FLT128_MIN; return W(res); };
myfloat128 pi_q (void) {__float128 res; res =  M_PIq; return W(res); };
myfloat128 e_q (void) {__float128 res; res = M_Eq; return W(res); };



