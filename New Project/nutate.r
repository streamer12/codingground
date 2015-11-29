source('polyidl.r')
source('cirrange.r')
nutate = function( jd) {

  dtor = pi/180.0
                                        #  form time in julian centuries from 1900.0
  t = (jd - 2451545.0)/36525

  coeff1 = c(297.85036,  445267.111480, -0.0019142, 1/189474 )
  d = polyidl(t, coeff1)*dtor
  
  d = cirrange(d,radians=T)

  coeff2 = c(357.52772, 35999.050340, -0.0001603, -1/3e5 )
  m = polyidl(t,coeff2)*dtor
  m = cirrange(m,radians=T)
  coeff3 = c(134.96298, 477198.867398, 0.0086972, 1.0/5.625e4 )
  mprime = polyidl(t,coeff3)*dtor
  mprime = cirrange(mprime,radians=T)
  coeff4 = c(93.27191, 483202.017538, -0.0036825, -1.0/3.27270e5 )
  f = polyidl(t, coeff4 )*dtor 
  f = cirrange(f,radians=T)
  coeff5 = c(125.04452, -1934.136261, 0.0020708, 1./4.5e5)
  omega = polyidl(t, coeff5)*dtor
  omega = cirrange(omega,radians=T)
  d_lng = c(0,-2,0,0,0,0,-2,0,0,-2,-2,-2,0,2,0,2,0,0,-2,0,2,0,0,-2,0,-2,0,0,2,
    -2,0,-2,0,0,2,2,0,-2,0,2,2,-2,-2,2,2,0,-2,-2,0,-2,-2,0,-1,-2,1,0,0,-1,0,0, 
    2,0,2)
  m_lng = c(0,0,0,0,1,0,1,0,0,-1,integer(17),2,0,2,1,0,-1,0,0,0,1,1,-1,0, 
    0,0,0,0,0,-1,-1,0,0,0,1,0,0,1,0,0,0,-1,1,-1,-1,0,-1)
  mp_lng = c(0,0,0,0,0,1,0,0,1,0,1,0,-1,0,1,-1,-1,1,2,-2,0,2,2,1,0,0,-1,0,-1, 
    0,0,1,0,2,-1,1,0,1,0,0,1,2,1,-2,0,1,0,0,2,2,0,1,1,0,0,1,-2,1,1,1,-1,3,0)
  f_lng = c(0,2,2,0,0,0,2,2,2,2,0,2,2,0,0,2,0,2,0,2,2,2,0,2,2,2,2,0,0,2,0,0, 
    0,-2,2,2,2,0,2,2,0,2,2,0,0,0,2,0,2,0,2,-2,0,0,0,2,2,0,0,2,2,2,2)
  om_lng = c(1,2,2,2,0,0,2,1,2,2,0,1,2,0,1,2,1,1,0,1,2,2,0,2,0,0,1,0,1,2,1, 
    1,1,0,1,2,2,0,2,1,0,2,1,1,1,0,1,1,1,1,1,0,0,0,0,0,2,0,0,2,2,2,2)
  sin_lng = c(-171996, -13187, -2274, 2062, 1426, 712, -517, -386, -301, 217, 
    -158, 129, 123, 63, 63, -59, -58, -51, 48, 46, -38, -31, 29, 29, 26, -22, 
    21, 17, 16, -16, -15, -13, -12, 11, -10, -8, 7, -7, -7, -7, 
    6,6,6,-6,-6,5,-5,-5,-5,4,4,4,-4,-4,-4,3,-3,-3,-3,-3,-3,-3,-3 )
  
  sdelt = c(-174.2, -1.6, -0.2, 0.2, -3.4, 0.1, 1.2, -0.4, 0, -0.5, 0, 0.1, 
    0,0,0.1, 0,-0.1,numeric(10), -0.1, 0, 0.1, numeric(33) ) 
  cos_lng = c( 92025, 5736, 977, -895, 54, -7, 224, 200, 129, -95,0,-70,-53,0, 
    -33, 26, 32, 27, 0, -24, 16,13,0,-12,0,0,-10,0,-8,7,9,7,6,0,5,3,-3,0,3,3,
    0,-3,-3,3,3,0,3,3,3, integer(14) )
  cdelt = c(8.9, -3.1, -0.5, 0.5, -0.1, 0.0, -0.6, 0.0, -0.1, 0.3, numeric(53) )
  n = length(jd)
  nut_long = numeric(n)
  nut_obliq = numeric(n)
  arg = d*d_lng + m*m_lng +mprime*mp_lng +
    f*f_lng +omega*om_lng
  sarg = t(sin(arg))
  carg = t(cos(arg))
  for(i in 1:n) {
    nut_long[i] =  0.0001*sum( (sdelt*t[i] + sin_lng)*sarg[,i] )
    nut_obliq[i] = 0.0001*sum( (cdelt*t[i] + cos_lng)*carg[,i] )
  }
return (list(nut_long = nut_long, nut_obliq = nut_obliq))
}
