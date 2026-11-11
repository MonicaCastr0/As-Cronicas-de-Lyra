var _w = display_get_gui_width();
var _h = display_get_gui_height();

// fundo preto azulado
var _topo  = make_color_rgb(13, 36, 71);
var _baixo = make_color_rgb(1, 3, 9);
draw_rectangle_color(0, 0, _w, _h, _topo, _topo, _baixo, _baixo, false);

draw_set_font(fnt_historia);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// parágrafo atual, centralizado na tela
if (estado >= 1 && seg < array_length(segs)) {
    var _s = segs[seg];
    var _restante = floor(chars);
    var _lh = string_height("A") * 1.6;           // espaçamento entre linhas
    var _n  = array_length(_s.linhas);
    var _y  = _h / 2 - (_n * _lh) / 2;            // centro vertical do bloco

    draw_set_color(_s.cor);
    draw_set_alpha(txt_alpha);
    for (var i = 0; i < _n; i++) {
        var _l = _s.linhas[i];
        var _x = _w / 2 - string_width(_l) / 2;   // centro pela largura FINAL da linha
        if (_restante > 0) draw_text(_x, _y, string_copy(_l, 1, _restante));
        _restante -= string_length(_l) + 1;
        _y += _lh;
    }
    draw_set_alpha(1);
}

// dica discreta
if (estado >= 1 && estado <= 3) {
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(111, 141, 184));
    draw_set_alpha(0.6);
    draw_text(_w / 2, _h - 36, "Qualquer tecla para avançar  •  Esc para pular");
    draw_set_alpha(1);
}

// fade por cima
draw_set_alpha(fade);
draw_set_color(c_black);
draw_rectangle(0, 0, _w, _h, false);
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);