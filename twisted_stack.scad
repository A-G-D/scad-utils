module twisted_stack(stack_count=1, stack_spacing, rotation_step)
{
    for (n=[0:1:$children - 1])
    for (i=[0:1:stack_count - 1])
    {
        translate([0, 0, stack_spacing*i])
        rotate([0, 0, rotation_step*i])
            children(n);
    }
}