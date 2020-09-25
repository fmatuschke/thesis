def ShortestPointToLineSegment(q, p0, p1):
    v = p1 - p0
    w = q - p0
    
    c1 = np.dot(w, v)
    if (c1 < 0) # check p0 side
        return p0, 0

    c2 = np.dot(v, v)
    if (c2 <= c1) # check p1 side
        return p1, 1
    
    b = c1 / c2
    pb = s0 + v * b
    
    return pb, b