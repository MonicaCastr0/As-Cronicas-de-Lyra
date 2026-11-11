
// STEP - Obj_terminal_array

if (!instance_exists(Obj_player)) exit;
if (global.desafio_array_concluido) exit;
if (global.desafio_array_aberto) exit;

var jogador = instance_nearest(x, y, Obj_player);

if (jogador == noone) exit;

// Centro da area ocupada por Lyra.
var centro_x = (jogador.bbox_left + jogador.bbox_right) / 2;
var centro_y = (jogador.bbox_top + jogador.bbox_bottom) / 2;

// Ponto mais proximo do terminal em relacao ao jogador.
var proximo_x = clamp(centro_x, bbox_left, bbox_right);
var proximo_y = clamp(centro_y, bbox_top, bbox_bottom);

// Distancia entre Lyra e a area fisica da bancada.
var distancia = point_distance(
    centro_x,
    centro_y,
    proximo_x,
    proximo_y
);

var perto = distancia <= 64;

if (perto && keyboard_check_pressed(ord("E"))) {

    global.desafio_array_aberto = true;
    jogador.pode_mover = false;

    instance_create_depth(0, 0, 0, Obj_interacao_array);
}
