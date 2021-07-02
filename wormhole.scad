module wormhole(r, a, b, thickness, angle = 360, hollow = true)
{
    if (hollow)
    {
        a_in = a - thickness/2;
        b_in = b - thickness/2;
        a_out = a + thickness/2;
        b_out = b + thickness/2;

        rotate_extrude(angle=angle)
        translate([r, 0, 0])
            difference()
            {
                scale([a_out, b_out])
                    circle(1);
                scale([a_in, b_in])
                    circle(1);
                translate([0, -b_out])
                    square([2*a_out, 2*b_out]);
            }
    }
    else
    {
        rotate_extrude(angle=angle)
        translate([r, 0, 0])
            difference()
            {
                scale([a, b])
                    circle(1);
                translate([0, -b])
                    square([2*a, 2*b]);
            }
    }
}