// ==========================================
// DRAW GUI - OPÇÕES DO MENU E CONFIGURAÇÕES
// (evento: Draw > Draw GUI)
// ==========================================

if (menu_alpha <= 0) exit;

var gw = display_get_gui_width();
var gh = display_get_gui_height();
var dourado = make_color_rgb(230, 190, 90);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (!em_config)
{
    // ---------------- MENU PRINCIPAL ----------------
    for (var i = 0; i < array_length(opcoes); i++)
    {
        var r = rect_opcao(i);
        var sel = (i == opcao_sel);
        var cx = (r[0] + r[2]) / 2;
        var cy = (r[1] + r[3]) / 2;

        // fundo do botão
        draw_set_alpha(menu_alpha * (sel ? 0.85 : 0.55));
        draw_set_color(sel ? make_color_rgb(30, 52, 70) : make_color_rgb(8, 14, 24));
        draw_roundrect_ext(r[0], r[1], r[2], r[3], 12, 12, false);

        // borda
        draw_set_alpha(menu_alpha * (sel ? 1 : 0.5));
        draw_set_color(sel ? dourado : make_color_rgb(60, 80, 100));
        draw_roundrect_ext(r[0], r[1], r[2], r[3], 12, 12, true);

        // texto
        draw_set_alpha(menu_alpha);
        draw_set_color(sel ? dourado : make_color_rgb(200, 210, 220));
        draw_text_transformed(cx, cy, opcoes[i], sel ? 1.4 : 1.25, sel ? 1.4 : 1.25, 0);

        // setinhas na opção selecionada
        if (sel)
        {
            var balanco = sin(current_time * 0.008) * 4;
            draw_text(r[0] - 22 - balanco, cy, ">");
            draw_text(r[2] + 22 + balanco, cy, "<");
        }
    }

    // dica de controles
    draw_set_alpha(menu_alpha * 0.6);
    draw_set_color(make_color_rgb(150, 170, 185));
    draw_text(gw / 2, gh - 28, "SETAS + ENTER   |   OU USE O MOUSE");
}
else
{
    // ---------------- CONFIGURAÇÕES ----------------
    var c = instance_find(Obj_config, 0);
    var px1 = gw / 2 - 330;
    var px2 = gw / 2 + 330;
    var py1 = gh * 0.10;
    var py2 = py1 + 590;

    // painel
    draw_set_alpha(menu_alpha * 0.88);
    draw_set_color(make_color_rgb(8, 14, 24));
    draw_roundrect_ext(px1, py1, px2, py2, 16, 16, false);
    draw_set_alpha(menu_alpha);
    draw_set_color(dourado);
    draw_roundrect_ext(px1, py1, px2, py2, 16, 16, true);

    draw_set_color(dourado);
    draw_text_transformed(gw / 2, py1 + 42, "CONFIGURACOES", 1.6, 1.6, 0);

    // linhas
    for (var i = 0; i < array_length(cfg_nomes); i++)
    {
        var r = cfg_rect(i);
        var sel = (i == cfg_sel);
        var cy = (r[1] + r[3]) / 2;
        var tem_valor = (i <= 3);

        draw_set_alpha(menu_alpha * (sel ? 0.9 : 0.5));
        draw_set_color(sel ? make_color_rgb(30, 52, 70) : make_color_rgb(14, 22, 34));
        draw_roundrect_ext(r[0], r[1], r[2], r[3], 10, 10, false);
        draw_set_alpha(menu_alpha * (sel ? 1 : 0.4));
        draw_set_color(sel ? dourado : make_color_rgb(60, 80, 100));
        draw_roundrect_ext(r[0], r[1], r[2], r[3], 10, 10, true);

        draw_set_alpha(menu_alpha);
        draw_set_color(sel ? dourado : make_color_rgb(200, 210, 220));

        if (tem_valor)
        {
            draw_set_halign(fa_left);
            draw_text(r[0] + 24, cy, cfg_nomes[i]);

            var rm = cfg_rect_menos(i);
            var rp = cfg_rect_mais(i);
            draw_set_halign(fa_center);
            draw_text((rm[0] + rm[2]) / 2, cy, "<");
            draw_text((rp[0] + rp[2]) / 2, cy, ">");
            draw_set_color(c_white);
            draw_text((rm[2] + rp[0]) / 2, cy, cfg_valor(i));
        }
        else
        {
            draw_set_halign(fa_center);
            draw_text((r[0] + r[2]) / 2, cy, cfg_nomes[i]);
        }
    }

    // diagnóstico (mostra o que o jogo está usando agora)
    var d = c.diagnostico();
    var ult = cfg_rect(array_length(cfg_nomes) - 1);
    var yd = ult[3] + 34;

    draw_set_halign(fa_center);
    draw_set_alpha(menu_alpha * 0.75);
    draw_set_color(make_color_rgb(150, 170, 185));
    draw_text(gw / 2, yd, "JANELA " + string(window_get_width()) + "x" + string(window_get_height())
        + "    GUI " + string(d.gui_w) + "x" + string(d.gui_h)
        + "    CAMERA " + string(round(d.cam_w)) + "x" + string(round(d.cam_h)));

    draw_set_alpha(menu_alpha);
    draw_set_color((c.status_tela == "OK") ? make_color_rgb(90, 200, 100) : make_color_rgb(240, 210, 80));
    draw_text(gw / 2, yd + 28, "STATUS: " + c.status_tela);

    // dica de controles
    draw_set_alpha(menu_alpha * 0.6);
    draw_set_color(make_color_rgb(150, 170, 185));
    draw_text(gw / 2, gh - 28, "SETAS: MUDAR   |   ENTER: APLICAR   |   ESC: VOLTAR");
}

// aviso (em breve / tela corrigida)
if (aviso_timer > 0)
{
    draw_set_halign(fa_center);
    draw_set_alpha(min(1, aviso_timer / 30));
    draw_set_color(make_color_rgb(240, 210, 80));
    draw_text(gw / 2, gh - 64, aviso);
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
