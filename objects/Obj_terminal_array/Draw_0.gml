
// DRAW - Obj_terminal_array

draw_self();

if (!instance_exists(Obj_player)) exit;
if (global.desafio_array_concluido) exit;
if (global.desafio_array_aberto) exit;

var jogador = instance_nearest(x, y, Obj_player);

if (jogador == noone) exit;

// Centro de Lyra.
var centro_x = (jogador.bbox_left + jogador.bbox_right) / 2;
var centro_y = (jogador.bbox_top + jogador.bbox_bottom) / 2;

// Ponto mais proximo da bancada.
var proximo_x = clamp(centro_x, bbox_left, bbox_right);
var proximo_y = clamp(centro_y, bbox_top, bbox_bottom);

var distancia = point_distance(
    centro_x,
    centro_y,
    proximo_x,
    proximo_y
);

if (distancia <= 64) {

    draw_set_color(c_white);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text(
        (bbox_left + bbox_right) / 2,
        bbox_top - 30,
        "E - INTERAGIR"
    );

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
