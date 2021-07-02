use <mirror_copy.scad>

module conic_section(cone_h, cone_angle, plane_angle, plane_offset = 0, mirror_cone = true, normalize_origin = false)
{
    cone_r = cone_h/tan(cone_angle);
    d = plane_offset*(sin(cone_angle)/sin(plane_angle - cone_angle));
    D = plane_offset*(sin(2*cone_angle)*sin(plane_angle))/((sin(cone_angle + plane_angle)*sin(plane_angle - cone_angle)));

    translate(normalize_origin? mirror_cone? [-d + D/2, 0] : [-d, 0] : [0, 0])
    projection(true)
    rotate([0, plane_angle, 0])
    translate([-plane_offset, 0, 0])
        if (mirror_cone)
            union()
            {
                mirror_copy([0, 0, 1])
                translate([0, 0, -cone_h/2])
                    cylinder(
                        r1=cone_r,
                        r2=0,
                        h=cone_h,
                        center=true
                    );
            }
        else
            mirror([0, 0, 1])
            translate([0, 0, -cone_h/2])
                cylinder(r1=cone_r, r2=0, h=cone_h, center=true);
}

$fs=1;
$fa=0.05;

translate([0, 40, 0])
    conic_section(
        cone_h=10,
        cone_angle=30,
        plane_angle=60,
        plane_offset=5,
        mirror_cone=true,
        normalize_origin=true
    );

translate([0, 0, 0])
    conic_section(
        cone_h=10,
        cone_angle=60,
        plane_angle=80,
        plane_offset=2,
        mirror_cone=false,
        normalize_origin=true
    );

/* translate([0, -40, 0])
    conic_section(
        cone_h=10,
        cone_angle=60,
        plane_angle=60,
        plane_offset=2,
        mirror_cone=false,
        normalize_origin=true
    ); */