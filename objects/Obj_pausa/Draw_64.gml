// ==========================================================
// DRAW GUI  -  Obj_pausa
// (evento: Draw > Draw GUI)
// ==========================================================
if (modo == 0) exit;

var gw = display_get_gui_width();
var gh = display_get_gui_height();
var dourado = make_color_rgb(230, 190, 90);
var cinza = make_color_rgb(150, 170, 185);

// escurece o jogo
draw_set_alpha(0.65);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);
draw_set_alpha(1);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// ==========================================================
// PAUSA (1) e CONFIRMAR SAIDA (3)
// ==========================================================
if (modo == 1 || modo == 3)
{
    var lista = (modo == 1) ? pausa_opcoes : conf_opcoes;

    draw_set_color(dourado);
    if (modo == 1)
    {
        draw_text_transformed(gw / 2, gh * 0.28, "PAUSA", 2, 2, 0);
    }
    else
    {
        draw_text_transformed(gw / 2, gh * 0.27, "VOLTAR AO MENU PRINCIPAL?", 1.5, 1.5, 0);
        draw_set_color(cinza);
        draw_text(gw / 2, gh * 0.27 + 44, "O progresso que nao foi salvo sera perdido.");
    }

    for (var i = 0; i < array_length(lista); i++)
    {
        desenhar_botao_menu(rect_lista(i), lista[i], (i == sel), 1);
    }

    draw_set_alpha(0.7);
    draw_set_color(cinza);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(gw / 2, gh - 30, "SETAS + ENTER   |   ESC: " + ((modo == 1) ? "CONTINUAR" : "VOLTAR"));
    draw_set_alpha(1);
}

// ==========================================================
// CONFIGURACOES (2)
// ==========================================================
if (modo == 2)
{
    var c = instance_find(Obj_config, 0);
    var px1 = gw / 2 - 370;
    var px2 = gw / 2 + 370;
    var py1 = gh / 2 - 320;
    var py2 = py1 + 660;

    draw_set_alpha(0.92);
    draw_set_color(make_color_rgb(8, 14, 24));
    draw_roundrect_ext(px1, py1, px2, py2, 16, 16, false);
    draw_set_alpha(1);
    draw_set_color(dourado);
    draw_roundrect_ext(px1, py1, px2, py2, 16, 16, true);

    draw_set_color(dourado);
    draw_text_transformed(gw / 2, py1 + 30, "CONFIGURACOES", 1.5, 1.5, 0);
    draw_set_color(cinza);
    draw_text(gw / 2, py1 + 58, "SETAS: MUDAR   |   ENTER: APLICAR   |   ESC: VOLTAR");

    for (var i = 0; i < array_length(cfg_itens); i++)
    {
        var r = cfg_rect(i);
        var s = (i == cfg_sel);
        var cy = (r[1] + r[3]) / 2;
        var t = cfg_itens[i].tipo;
        var breve = (t == "breve");

        draw_set_alpha(breve ? 0.35 : (s ? 0.9 : 0.5));
        draw_set_color(s ? make_color_rgb(30, 52, 70) : make_color_rgb(14, 22, 34));
        draw_roundrect_ext(r[0], r[1], r[2], r[3], 10, 10, false);
        draw_set_alpha(breve ? 0.3 : (s ? 1 : 0.4));
        draw_set_color(s ? dourado : make_color_rgb(60, 80, 100));
        draw_roundrect_ext(r[0], r[1], r[2], r[3], 10, 10, true);

        draw_set_alpha(breve ? 0.55 : 1);
        draw_set_color(s ? dourado : make_color_rgb(200, 210, 220));

        if (cfg_tem_valor(i))
        {
            draw_set_halign(fa_left);
            draw_text(r[0] + 24, cy, cfg_itens[i].nome);

            var rm = cfg_rect_menos(i);
            var rp = cfg_rect_mais(i);
            draw_set_halign(fa_center);
            draw_text((rm[0] + rm[2]) / 2, cy, "<");
            draw_text((rp[0] + rp[2]) / 2, cy, ">");
            draw_set_color(c_white);
            draw_text((rm[2] + rp[0]) / 2, cy, cfg_valor(i));
        }
        else if (breve)
        {
            draw_set_halign(fa_left);
            draw_text(r[0] + 24, cy, cfg_itens[i].nome);
            draw_set_halign(fa_right);
            draw_set_color(make_color_rgb(240, 210, 80));
            draw_text(r[2] - 24, cy, "EM BREVE");
        }
        else
        {
            draw_set_halign(fa_center);
            draw_text((r[0] + r[2]) / 2, cy, cfg_itens[i].nome);
        }
    }
    draw_set_alpha(1);

    // diagnostico e status
    var d = c.diagnostico();
    draw_set_halign(fa_center);
    draw_set_color(cinza);
    draw_text(gw / 2, py1 + 620, "JANELA " + string(window_get_width()) + "x" + string(window_get_height())
        + "    GUI " + string(d.gui_w) + "x" + string(d.gui_h)
        + "    CAMERA " + string(round(d.cam_w)) + "x" + string(round(d.cam_h))
        + "    STATUS: " + c.status_tela);
}

// aviso (EM BREVE / TELA CORRIGIDA)
if (aviso_timer > 0)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(min(1, aviso_timer / 30));
    draw_set_color(make_color_rgb(240, 210, 80));
    draw_text(gw / 2, (modo == 2) ? gh / 2 - 320 + 644 : gh - 64, aviso);
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
