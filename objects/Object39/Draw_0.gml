if (perto) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);

    draw_text(x, y - 32, "[E] Interagir");

    // Restaura as configurações de desenho
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}