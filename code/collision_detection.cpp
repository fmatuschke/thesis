// https://www.john.geek.nz/2009/03/code-shortest-distance-between-any-two-line-segments/
auto const &P0 = p0;
auto const &P1 = p1;
auto const &Q0 = cone.p0;
auto const &Q1 = cone.p1;

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

// vm::Vec3<double> dP;
// dP = w + (u * sc) - (v * tc);
auto P = P0 + u * sc;
auto Q = Q0 + v * tc;

return std::make_tuple(P, Q);