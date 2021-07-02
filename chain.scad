/*
*   Parameters:
*       a - half of major-axis length
*       b - half of minor-axis length
*       f - corner fillet radius
*/
module chain_node(a, b, f)
{
    in_rect_a = a - f;
    in_rect_b = b - f;

    union()
    {
        /*
        *   Sides
        */
        translate([a, 0, 0])
        rotate([90, 0, 0])
        translate([0, 0, -in_rect_b])
        linear_extrude(height=2*in_rect_b)
            children(0);

        translate([0, b, 0])
        rotate([0, 90, 0])
        translate([0, 0, -in_rect_a])
        linear_extrude(height=2*in_rect_a)
            children(0);

        translate([-a, 0, 0])
        rotate([90, 0, 0])
        translate([0, 0, -in_rect_b])
        linear_extrude(height=2*in_rect_b)
            children(0);

        translate([0, -b, 0])
        rotate([0, 90, 0])
        translate([0, 0, -in_rect_a])
        linear_extrude(height=2*in_rect_a)
            children(0);

        /*
        *   Fillets
        */
        translate([in_rect_a, in_rect_b, 0])
        rotate_extrude(angle=90)
        translate([f, 0, 0])
            children(0);

        translate([-in_rect_a, in_rect_b, 0])
        rotate([0, 0, 90])
        rotate_extrude(angle=90)
        translate([f, 0, 0])
            children(0);

        translate([-in_rect_a, -in_rect_b, 0])
        rotate([0, 0, 180])
        rotate_extrude(angle=90)
        translate([f, 0, 0])
            children(0);

        translate([in_rect_a, -in_rect_b, 0])
        rotate([0, 0, 270])
        rotate_extrude(angle=90)
        translate([f, 0, 0])
            children(0);
    }
}

module chain_linear(node_count, spacing, rotation_rate = [90, 0, 0])
{
    for (n=[0:1:$children - 1])
    for (i=[0:1:node_count - 1])
        translate([spacing*i, 0, 0])
        rotate([rotation_rate[0]*i, rotation_rate[1]*i, rotation_rate[2]*i])
            children(n);
}

module chain_circular(node_count, spacing, radius, rotation_rate = [90, 0, 0])
{
    dc = spacing/radius;
    da = acos(1 - 0.5*dc*dc);

    for (n=[0:1:$children - 1])
    for (i=[0:1:node_count - 1])
        rotate([0, 0, da*i])
        translate([radius, 0, 0])
        rotate([rotation_rate[0]*i, rotation_rate[1]*i, rotation_rate[2]*i + 90])
            children(n);
}

module chain_helical(node_count, spacing, radius, angle, rotation_rate = [90, 0, 0])
{
    dc = (spacing*cos(angle))/radius;
    da = acos(1 - 0.5*dc*dc);

    for (n=[0:1:$children - 1])
    for (i=[0:1:node_count - 1])
        rotate([da*i, 0, 0])
        translate([spacing*sin(angle)*i, 0, radius])
        rotate([rotation_rate[0]*i, rotation_rate[1]*i, rotation_rate[2]*i + (angle - 90)])
            children(n);
}

module chain_conical_helix(node_count, spacing, radius, alpha, beta, rotation_rate = [90, 0, 0])
{
    module node(i, radius, angle)
    {
        dc = spacing*cos_a;
        da = acos(1 - (dc*dc)/(2*radius*radius));

        rotate([angle, 0, 0])
        translate([spacing*sin_a*cos_b*i, 0, radius])
        rotate(a = 90 - alpha, v = [sin_b, 0, -cos_b])
        rotate([rotation_rate[0]*i, rotation_rate[1]*i - beta, rotation_rate[2]*i])
            children(0);

        if (i + 1 < node_count)
            node(i + 1, radius + spacing*sin_a*sin_b, angle + da)
                children(0);
    }

    sin_a = sin(alpha);
    cos_a = cos(alpha);
    sin_b = sin(beta);
    cos_b = cos(beta);

    for (n=[0:1:$children - 1])
        node(0, radius, 0)
            children(n);
}

module chain(spacing, quat_arr)
{
    module node(i, cx, cy, cz)
    {
        ax = quat_arr[i][0];
        ay = quat_arr[i][1];
        az = quat_arr[i][2];
        axy = sqrt(ax*ax + ay*ay);
        as = sqrt(ax*ax + ay*ay + az*az);

        dx = spacing*(ax/as);
        dy = spacing*(ay/as);
        dz = spacing*(az/as);

        yaw = atan2(ay, ax);
        pitch = atan2(az, axy);
        roll = (len(quat_arr[i]) < 4)? 0 : quat_arr[i][3];

        translate([dx, dy, dz])
        rotate(a=roll, v=[ax, ay, az])
        rotate(a=pitch, v=[-sin(yaw), cos(yaw), 0])
        rotate([0, 0, yaw])
            children(0);

        node(i, cx + dx, cy + dy, cz + dz)
            children(0);
    }

    for (n=[0:1:$children - 1])
        for (i=[0:1:len(quat_arr) - 1])
            node(i, 0, 0, 0)
                children(n);

}

$fa=1;
$fs=0.2;
/* 
chain_linear(10, 6, rotation_rate=[90, 0, 0])
chain_node(4, 2, 2)
    circle(1); */

chain_circular(10, 6, 20)
chain_node(4, 2, 2)
    circle(1);

chain_helical(node_count=72, spacing=6, radius=10, angle=30)
chain_node(4, 2, 2)
    circle(1);

chain_conical_helix(node_count=72, spacing=6, radius=20, alpha=30, beta=90)
chain_node(4, 2, 2)
    circle(1);

chain_conical_helix(node_count=108, spacing=6, radius=30, alpha=15, beta=15)
chain_node(4, 2, 2)
    circle(1);