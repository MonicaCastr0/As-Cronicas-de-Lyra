// Entrada
var direita = keyboard_check(vk_right);
var esquerda = keyboard_check(vk_left);
var cima = keyboard_check(vk_up);
var baixo = keyboard_check(vk_down);

var h = direita - esquerda;
var v = baixo - cima;

var andando = (h != 0 || v != 0);
var correndo = andando && keyboard_check(vk_shift);

// Velocidade
var vel = correndo ? velocidade_correr : velocidade_andar;

// Movimento horizontal com colisão
if (h != 0)
{
    var proximo_x = x + h * vel;

    var colidiu_x =
        tilemap_get_at_pixel(tilemap_parede, bbox_left + (proximo_x - x), bbox_top) != 0 ||
        tilemap_get_at_pixel(tilemap_parede, bbox_right + (proximo_x - x), bbox_top) != 0 ||
        tilemap_get_at_pixel(tilemap_parede, bbox_left + (proximo_x - x), bbox_bottom) != 0 ||
        tilemap_get_at_pixel(tilemap_parede, bbox_right + (proximo_x - x), bbox_bottom) != 0;

    if (!colidiu_x)
    {
        x = proximo_x;
    }
}

// Movimento vertical com colisão
if (v != 0)
{
    var proximo_y = y + v * vel;

    var colidiu_y =
        tilemap_get_at_pixel(tilemap_parede, bbox_left, bbox_top + (proximo_y - y)) != 0 ||
        tilemap_get_at_pixel(tilemap_parede, bbox_right, bbox_top + (proximo_y - y)) != 0 ||
        tilemap_get_at_pixel(tilemap_parede, bbox_left, bbox_bottom + (proximo_y - y)) != 0 ||
        tilemap_get_at_pixel(tilemap_parede, bbox_right, bbox_bottom + (proximo_y - y)) != 0;

    if (!colidiu_y)
    {
        y = proximo_y;
    }
}

// Profundidade (hierarquia)
depth = -bbox_bottom;

// Direção
if (andando)
{
    if (h > 0) direcao = "right";
    else if (h < 0) direcao = "left";
    else if (v > 0) direcao = "down";
    else if (v < 0) direcao = "up";
}

// Sprite (andar ou correr)
switch (direcao)
{
    case "down":
        sprite_index = correndo ? spr_player_run_down : spr_player_down;
        break;
    case "up":
        sprite_index = correndo ? spr_player_run_up : spr_player_up;
        break;
    case "left":
        sprite_index = correndo ? spr_player_run_left : spr_player_left;
        break;
    case "right":
        sprite_index = correndo ? spr_player_run_right : spr_player_right;
        break;
}

// Velocidade da animação
if (andando)
{
    image_speed = correndo ? 0.6 : 0.6;
}
else
{
    image_speed = 0;
    image_index = 0;
}

// Câmera (por último, depois de mover)
camera_set_view_pos(
    camera,
    x - camera_get_view_width(camera) / 2,
    y - camera_get_view_height(camera) / 2
);