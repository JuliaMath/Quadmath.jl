/* mpfr_set_float128 -- convert a machine __float128 number to
                        a multiple precision floating-point number

Copyright 2012-2015 Free Software Foundation, Inc.
Contributed by the AriC and Caramel projects, INRIA.

This file is part of the GNU MPFR Library.

The GNU MPFR Library is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation; either version 3 of the License, or (at your
option) any later version.

The GNU MPFR Library is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
License for more details.

You should have received a copy of the GNU Lesser General Public License
along with the GNU MPFR Library; see the file COPYING.LESSER.  If not, see
http://www.gnu.org/licenses/ or write to the Free Software Foundation, Inc.,
51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA. */

#define MPFR_WANT_FLOAT128
#ifdef MPFR_WANT_FLOAT128

#define IEEE_FLOAT128_MANT_DIG 113 
#define MPFR_USE_THREAD_SAFE


#include <float.h> /* for DBL_MAX */

#define MPFR_NEED_LONGLONG_H
#include "mpfr-impl.h"


int
mpfr_set_float128 (mpfr_ptr r, __float128 d, mpfr_rnd_t rnd_mode)
{
  mpfr_t t, u;
  int inexact, shift_exp;
  __float128 x;
  MPFR_SAVE_EXPO_DECL (expo);

  /* Check for NaN - We assume that systems that support __float128
     also know about NaN and won't optimize d != d incorrectly. */
  if (d != d)
    {
      MPFR_SET_NAN(r);
      MPFR_RET_NAN;
    }

  /* Check for INF */
  if (d == ((__float128) 1.0 / (__float128) 0.0))
    {
      mpfr_set_inf (r, 1);
      return 0;
    }
  else if (d == ((__float128) -1.0 / (__float128) 0.0))
    {
      mpfr_set_inf (r, -1);
      return 0;
    }
  /* Check for ZERO */
  else if (d == (__float128) 0.0)
    return mpfr_set_d (r, (double) d, rnd_mode);

  mpfr_init2 (t, IEEE_FLOAT128_MANT_DIG);
  mpfr_init2 (u, IEEE_FLOAT128_MANT_DIG);

  MPFR_SAVE_EXPO_MARK (expo);

  x = d;
  MPFR_SET_ZERO (t);  /* The sign doesn't matter. */
  shift_exp = 0; /* invariant: remainder to deal with is x*2^shift_exp */
  /* 2^(-16494) <= x < 2^16384 */
  while (x != (__float128) 0.0)
    {
      /* check overflow of double */
      if (x > (__float128) DBL_MAX || (-x) > (__float128) DBL_MAX)
        {
          __float128 div9, div10, div11, div12, div13;

#define TWO_64 18446744073709551616.0 /* 2^64 */
#define TWO_128 (TWO_64 * TWO_64)
#define TWO_256 (TWO_128 * TWO_128)
          div9 = (__float128) (double) (TWO_256 * TWO_256); /* 2^(2^9) */
          div10 = div9 * div9;
          div11 = div10 * div10; /* 2^(2^11) */
          div12 = div11 * div11; /* 2^(2^12) */
          div13 = div12 * div12; /* 2^(2^13) */
          if (ABS (x) >= div13)
            {
              x /= div13; /* exact */
              shift_exp += 8192;
              mpfr_div_2si (t, t, 8192, MPFR_RNDZ);
            }
          /* now |x| < 2^8192 */
          if (ABS (x) >= div12)
            {
              x /= div12; /* exact */
              shift_exp += 4096;
              mpfr_div_2si (t, t, 4096, MPFR_RNDZ);
            }
          /* now |x| < 2^4096 */
          if (ABS (x) >= div11)
            {
              x /= div11; /* exact */
              shift_exp += 2048;
              mpfr_div_2si (t, t, 2048, MPFR_RNDZ);
            }
          /* now |x| < 2^2048 */
          if (ABS (x) >= (0.5 * div10))
            {
              x /= (2.0 * div10); /* exact */
              shift_exp += 1025;
              mpfr_div_2si (t, t, 1025, MPFR_RNDZ);
            }
          /* now |x| < 2^1023 */
        } /* end of check overflow of double */

      /* check underflow on double */
      else if ((x < (__float128) DBL_MIN) && ((-x) < (__float128) DBL_MIN))
        {
          __float128 div9, div10, div11, div12, div13;

          div9 = (__float128) (double) 7.4583407312002067432909653e-155;
          /* div9 = 2^(-512) */
          div10 = div9  * div9;  /* 2^(-1024) */
          div11 = div10 * div10; /* 2^(-2048) */
          div12 = div11 * div11; /* 2^(-4096) */
          div13 = div12 * div12; /* 2^(-8192) */
          if (ABS (x) <= div13)
            {
              x /= div13; /* exact */
              shift_exp -= 8192;
              mpfr_mul_2si (t, t, 8192, MPFR_RNDZ);
            }
          /* now |x| > 2^(-8192) */
          if (ABS (x) <= div12)
            {
              x /= div12; /* exact */
              shift_exp -= 4096;
              mpfr_mul_2si (t, t, 4096, MPFR_RNDZ);
            }
          /* now |x| > 2^(-4096) */
          if (ABS (x) <= div11)
            {
              x /= div11; /* exact */
              shift_exp -= 2048;
              mpfr_mul_2si (t, t, 2048, MPFR_RNDZ);
            }
          /* now |x| > 2^(-2048) */
          if (ABS (x) <= (div10 * 4.0)) /* div10 * 4.0 = 2^(-1022) */
            {
              x /= (div10 * 0.25); /* exact, div10 * 0.25 = 2^(-1026) */
              shift_exp -= 1026;
              mpfr_mul_2si (t, t, 1026, MPFR_RNDZ);
            }
          /* now |x| > 2^(-1022) */
        }
      else /* no underflow: 2^(-512) <= |x| < 2^1023 */
        {
          inexact = mpfr_set_d (u, (double) x, MPFR_RNDZ);
          MPFR_ASSERTD (inexact == 0);
          if (mpfr_add (t, t, u, MPFR_RNDZ) != 0)
            {
              if (!mpfr_number_p (t))
                break;
              /* Inexact. This cannot happen unless the C implementation
                 "lies" on the precision. */
            }
          x -= (__float128) mpfr_get_d1 (u); /* exact */
        }
    }

  inexact = mpfr_mul_2si (r, t, shift_exp, rnd_mode);
  mpfr_clear (t);
  mpfr_clear (u);

  MPFR_SAVE_EXPO_FREE (expo);
  return mpfr_check_range (r, inexact, rnd_mode);
}

#endif /* MPFR_WANT_FLOAT128 */

#include <stdint.h>
#include "quadmath_wrapper.h"
int
mpfr_set_float128_xxx (mpfr_ptr r, myfloat128 d, mpfr_rnd_t rnd_mode)
{
    return mpfr_set_float128 (r, F(d), rnd_mode);
}

