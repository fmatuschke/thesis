def MinDistance(cone_a, cone_b):
   # from https://www.john.geek.nz

   u = cone_a.p1 - cone_a.p0
   v = cone_b.p1 - cone_b.p0
   w = cone_a.p0 - cone_b.p0

   a = np.dot(u, u)
   b = np.dot(u, v)
   c = np.dot(v, v)
   d = np.dot(u, w)
   e = np.dot(v, w)
   f = a * c - b * b

   if f < 1e-5:
      sN = 0.0
      sD = 1.0
      tN = e
      tD = c
   else:
      sN = b * e - c * d
      tN = a * e - b * d
      if sN < 0.0:
         sN = 0.0
         tN = e
         tD = c
      elif sN > sD:
         sN = sD
         tN = e + b
         tD = c

   if tN < 0.0:
      tN = 0.0

      if -d < 0.0:
         sN = 0.0
      elif -d > a:
         sN = sD
      else
         sN = -d
         sD = a
   elif tN > tD:
      tN = tD
      if (-d + b) < 0.0:
         sN = 0
      elif (-d + b) > a:
         sN = sD
      else
         sN = (-d + b)
         sD = a

   if np.abs(sN) < 1e-5:
      sc = 0.0
   else:
      sc = sN / sD
   if np.abs(tN) < 1e-5:
      tc = 0.0
   else:
      tc = tN / tD

   P = cone_a.p0 + u * sc
   Q = cone_b.p0 + v * tc
   length = np.linalg.norm(P, Q)
   return length, P, Q
