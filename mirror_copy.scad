module mirror_copy(v=[0, 0, 1])
{
    for (n=[0:1:$children - 1])
    {
        children(n);
        mirror(v)
            children(n);
    }
}