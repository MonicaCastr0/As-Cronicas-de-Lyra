// Profundidade (fica atras/na frente da Lyra conforme a posicao)
depth = -bbox_bottom;

var jogador = instance_exists(Obj_player) ? instance_find(Obj_player, 0) : noone;

// ---------- Estado de interacao ----------
var em_dialogo = instance_exists(Obj_Dialogo_Jardim);
var em_desafio = global.desafio_plantar_aberto;
var ocupado    = em_dialogo || em_desafio || global.dialogo_ativo || global.pausado;

// Cooldown: enquanto o dialogo existe, mantem o contador cheio
if (em_dialogo) cooldown = 10;
if (cooldown > 0) cooldown--;

// ---------- Distancia da Lyra ----------
perto = false;
if (jogador != noone) {
    perto = point_distance(x, y, jogador.x, jogador.y) <= distancia_interacao;
}

// ---------- Animacao / movimento ----------
if (ocupado) {
    // PARADO: sem andar e no primeiro frame
    image_speed = 0;
    image_index = 0;

    // Vira de frente para a Lyra durante o dialogo/desafio
    if ((em_dialogo || em_desafio) && jogador != noone) {
        var dx = jogador.x - x;
        var dy = jogador.y - y;

        if (abs(dx) > abs(dy)) {
            sprite_index = (dx > 0) ? spr_robo_jardim_right : spr_robo_jardim_left;
        } else {
            sprite_index = (dy > 0) ? spr_robo_jardim_down : spr_robo_jardim_up;
        }
    }
}
else {
    // ANDANDO de um lado para o outro
    tempo_direcao--;
    if (tempo_direcao <= 0) {
        direcao *= -1;
        tempo_direcao = irandom_range(90, 240);
    }

    // Nao passa do limite da ronda
    if (x >= x_inicial + alcance) direcao = -1;
    if (x <= x_inicial - alcance) direcao = 1;

    x += velocidade * direcao;

    sprite_index = (direcao > 0) ? spr_robo_jardim_right : spr_robo_jardim_left;
    image_speed  = 0.15;
}

// ---------- Interagir ----------
if (ocupado || cooldown > 0) exit;

if (perto && keyboard_check_pressed(ord("E"))) {

    if (!global.jardim_dialogo_inicial)
    {
        // 1) Primeira vez: dialogo antes do desafio
        instance_create_depth(0, 0, -10000, Obj_Dialogo_Jardim, { modo: 0 });
    }
    else if (global.jardim_florido && !global.jardim_dialogo_final)
    {
        // 2) Desafio concluido: dialogo final (entrega a foice)
        instance_create_depth(0, 0, -10000, Obj_Dialogo_Jardim, { modo: 1 });
    }
    else
    {
        // 3) Demais vezes: abre o desafio direto
        var desafio = instance_find(Obj_desafio_plantar, 0);

        if (desafio != noone) {
            with (desafio) abrir();
        } else {
            show_debug_message("Erro: Obj_desafio_plantar nao existe na room.");
        }
    }
}