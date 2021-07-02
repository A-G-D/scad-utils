module pipe(ri, ro, h, i_offset=0, center=true)
{
    difference()
    {
        cylinder(r=ro, h=h, center=center);
        translate([i_offset, 0, -0.01])
            cylinder(r=ri, h=h + 0.02, center=center);
    }
}