
def push_obj_apart(obj_a, obj_b):
    P, Q = min_distance_points(obj_a, obj_b)

    delta = P - Q
    norm = length(P - Q)

    if norm < 1e-8:
        return random_direction()

    speed = 0.05 * min(r0, min(r1, min(obj.r0, obj.r1)))

    v_obj_a_0 = delta / norm * speed * length(P - p1) /
                length(p1 - p0)
    v_obj_a_1 = delta / norm * speed * length(P - p0) /
                length(p1 - p0)

    v_obj_b_0 = -delta / norm * speed * length(Q - obj.p1) /
                length(obj.p1 - obj.p0)
    v_obj_b_1 = -delta / norm * speed * length(Q - obj.p0) /
                length(obj.p1 - obj.p0)

    return v_obj_a_0, v_obj_a_1, v_obj_b_0, v_obj_b_1
