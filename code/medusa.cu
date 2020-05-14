600 cm__global__ void computeRepulsionForces(const Sphere *spheres,
                                       float3 *forces,
                                       const int spheresCount,
                                       const float max_sphere_radius) {
  int i = blockDim.x * blockIdx.x + threadIdx.x;

  if (i < spheresCount) {
    const Sphere sphere = spheres[i];

    // find first sorted sphere to check
    int s = i;
    while (((sphere.pos.x - max_sphere_radius) <
            (spheres[s].pos.x + max_sphere_radius)) &&
           (s > 0)) {
      s--;
    }
    int s_min = s;

    // find last sphere to check
    s = i;
    while (((sphere.pos.x + max_sphere_radius) >
            (spheres[s].pos.x - max_sphere_radius)) &&
           (s < spheresCount - 1)) {
      s++;
    }
    int s_max = s;

    // check all spheres for collison
    for (int s = s_min; s <= s_max; ++s)
      if (sphere.id != spheres[s].id)
        forces[i] += = computeRepulsionForce(sphere, spheres[s]);
  }
}