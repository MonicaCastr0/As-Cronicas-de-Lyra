// ==========================================
// FUNDO DA ABERTURA (área de cima: y 0 a 720)
// Cobre o azul de teste. Se quiser ver o azul de novo, apague este bloco.
// ==========================================

draw_rectangle_color(
    0, 0, parallax_largura, altura_cena,
    make_color_rgb(6, 10, 20),
    make_color_rgb(6, 10, 20),
    make_color_rgb(14, 26, 46),
    make_color_rgb(14, 26, 46),
    false
);


// ==========================================
// DESENHAR CAMADAS
// ==========================================


// CAMADA 11 - FUNDO
draw_sprite(spr_menu_bg_11, 0, x_11, 720 + sprite_get_height(spr_menu_bg_11) / 2);
draw_sprite(
    spr_menu_bg_11,
    0,
    x_11 - parallax_largura,
    720 + sprite_get_height(spr_menu_bg_11) / 2
);


// CAMADA 10
draw_sprite(spr_menu_bg_10, 0, x_10, altura_cena);
draw_sprite(spr_menu_bg_10, 0, x_10 - parallax_largura, altura_cena);


// CAMADA 09
draw_sprite(spr_menu_bg_09, 0, x_09, altura_cena);
draw_sprite(spr_menu_bg_09, 0, x_09 - parallax_largura, altura_cena);


// CAMADA 08
draw_sprite(spr_menu_bg_08, 0, x_08, altura_cena);
draw_sprite(spr_menu_bg_08, 0, x_08 - parallax_largura, altura_cena);


// LUZ 02
draw_sprite(spr_menu_bg_07, 0, x_07, altura_cena);
draw_sprite(spr_menu_bg_07, 0, x_07 - parallax_largura, altura_cena);


// CAMADA 06
draw_sprite(spr_menu_bg_06, 0, x_06, altura_cena);
draw_sprite(spr_menu_bg_06, 0, x_06 - parallax_largura, altura_cena);


// CAMADA 05
draw_sprite(spr_menu_bg_05, 0, x_05, altura_cena);
draw_sprite(spr_menu_bg_05, 0, x_05 - parallax_largura, altura_cena);


// LUZ 01
draw_sprite(spr_menu_bg_04, 0, x_04, altura_cena);
draw_sprite(spr_menu_bg_04, 0, x_04 - parallax_largura, altura_cena);


// CAMADA 03
draw_sprite(spr_menu_bg_03, 0, x_03, altura_cena);
draw_sprite(spr_menu_bg_03, 0, x_03 - parallax_largura, altura_cena);


// CAMADA 02
draw_sprite(spr_menu_bg_02, 0, x_02, altura_cena);
draw_sprite(spr_menu_bg_02, 0, x_02 - parallax_largura, altura_cena);

draw_sprite(spr_menu_bg_02, 0, x_12, altura_cena2);
draw_sprite(spr_menu_bg_02, 0, x_12 - parallax_largura, altura_cena2);


// CAMADA 01
draw_sprite(spr_menu_bg_01, 0, x_01, altura_cena);
draw_sprite(spr_menu_bg_01, 0, x_01 - parallax_largura, altura_cena);


// CAMADA 00
draw_sprite(spr_menu_bg_00, 0, x_00, altura_cena);
draw_sprite(spr_menu_bg_00, 0, x_00 - parallax_largura, altura_cena);

draw_sprite(spr_menu_logo,0, fa_center,altura_cena);
// ==========================================
// PATROCINADORES (ficam na área de cima, então saem da tela quando a câmera desce)
// ==========================================

if (patro_alpha > 0)
{
    var n_pat = array_length(patrocinadores);
    var cx = parallax_largura / 2;
    var cy = altura_cena / 2;

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // título
    draw_set_alpha(patro_alpha);
    draw_set_color(make_color_rgb(230, 190, 90));
    draw_text_transformed(cx, 160, texto_patrocinio, 1.6, 1.6, 0);

    // linha decorativa
    draw_set_color(make_color_rgb(60, 80, 100));
    draw_line_width(cx - 140, 195, cx + 140, 195, 2);

    for (var i = 0; i < n_pat; i++)
    {
        var px = parallax_largura * (i + 1) / (n_pat + 1);
        var p = patrocinadores[i];

        // logo (centralizada, qualquer origem do sprite)
        if (p.logo != -1)
        {
            var esc = min(260 / sprite_get_width(p.logo), 160 / sprite_get_height(p.logo));
            var dx = px - (sprite_get_width(p.logo) / 2 - sprite_get_xoffset(p.logo)) * esc;
            var dy = (cy - 10) - (sprite_get_height(p.logo) / 2 - sprite_get_yoffset(p.logo)) * esc;
            draw_sprite_ext(p.logo, 0, dx, dy, esc, esc, 0, c_white, patro_alpha);
        }

        // nome
        draw_set_alpha(patro_alpha);
        draw_set_color(c_white);
        draw_text_transformed(px, cy + 110, p.nome, 1.2, 1.2, 0);
    }

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
