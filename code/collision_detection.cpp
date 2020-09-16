bool Cone::CollideWith(const Cone cone) const {
   vm::Vec3<double> P, Q;
   std::tie(P, Q) = MinDistanceVectorCones(cone);
   double min_dist = vm::length(P - Q);
   if (min_dist < (r + cone.r))
      return true;

   return false;
}

std::tuple<vm::Vec3<double>, vm::Vec3<double>>
Cone::MinDistanceLineSegments(
    const vm::Vec3<double> P0,
    const vm::Vec3<double> P1,
    const vm::Vec3<double> Q0,
    const vm::Vec3<double> Q1) const {
       
   // https://www.john.geek.nz/
   auto const u = P1 - P0;
   auto const v = Q1 - Q0;
   auto const w = P0 - Q0;

   auto const a = vm::dot(u, u);
   auto const b = vm::dot(u, v);
   auto const c = vm::dot(v, v);
   auto const d = vm::dot(u, w);
   auto const e = vm::dot(v, w);
   auto const f = a * c - b * b;

   double sc, sN, sD = f;
   double tc, tN, tD = f;

   if (f < 1e-5f) {
      sN = 0.0;
      sD = 1.0;
      tN = e;
      tD = c;
   } else {
      sN = b * e - c * d;
      tN = a * e - b * d;
      if (sN < 0.0) {
         sN = 0.0;
         tN = e;
         tD = c;
      } else if (sN > sD) {
         sN = sD;
         tN = e + b;
         tD = c;
      }
   }

   if (tN < 0.0) {
      tN = 0.0;

      if (-d < 0.0)
         sN = 0.0;
      else if (-d > a)
         sN = sD;
      else {
         sN = -d;
         sD = a;
      }
   } else if (tN > tD) {
      tN = tD;
      if ((-d + b) < 0.0)
         sN = 0;
      else if ((-d + b) > a)
         sN = sD;
      else {
         sN = (-d + b);
         sD = a;
      }
   }

   if (std::abs(sN) < 1e-5f)
      sc = 0.0;
   else
      sc = sN / sD;
   if (std::abs(tN) < 1e-5f)
      tc = 0.0;
   else
      tc = tN / tD;

   auto P = P0 + u * sc;
   auto Q = Q0 + v * tc;

   return std::make_tuple(P, Q);
}