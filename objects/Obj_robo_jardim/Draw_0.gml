draw_self();   

if (perto && !instance_exists(Obj_Dialogo_Jardim) && !global.desafio_plantar_aberto && !global.pausado) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);

    draw_text(x, bbox_top - 8, "[E] Interagir");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}