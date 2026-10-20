draw_self();

if (distance_to_object(Obj_player) <= 32 && !interagindo)
{
    draw_set_color(c_white);
    draw_text(x - 40, y - 50, "E - INTERAGIR");
}