module array(v_count, v_offset, center = false)
{
    translate(
        center?
            [
                -0.5*(v_count[0] - 1)*v_offset[0],
                -0.5*(v_count[1] - 1)*v_offset[1],
                -0.5*(v_count[2] - 1)*v_offset[2]
            ]
            : 0
    )
        for (n=[0:1:$children - 1])
        for (i=[0:1:v_count[0] - 1])
        for (j=[0:1:v_count[1] - 1])
        for (k=[0:1:v_count[2] - 1])
            translate([v_offset[0]*i, v_offset[1]*j, v_offset[2]*k])
                children(n);
}

module polar_array(count, radius, start_angle, end_angle)
{
    da = (end_angle - start_angle)/count;

    for (n=[0:1:$children - 1])
    for (i=[0:1:count - 1])
        rotate([0, 0, start_angle + da*i])
        translate([radius, 0, 0])
            children(n);
}


array(
    v_count=[2, 1, 5],
    v_offset=[5, 5, 5],
    center=true
)
{
    cube(1);
    translate([0, 5, 0])
        sphere(1);
}

polar_array(
    count=5,
    radius=10,
    start_angle=0,
    end_angle=360
)
    cube([1, 1, 2]);