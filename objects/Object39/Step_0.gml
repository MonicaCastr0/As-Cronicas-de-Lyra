// Verifica se o jogador existe
if (!instance_exists(Obj_player)) {
    perto = false;
    exit;
}

// Cooldown: enquanto o dialogo existe, mantem o contador cheio
if (instance_exists(Obj_Dialogo_Jardim)) cooldown = 10;
if (cooldown > 0) cooldown--;

// Calcula a distância até o jogador
var jogador = instance_find(Obj_player, 0);

perto = point_distance(
    x, y,
    jogador.x, jogador.y
) <= distancia_interacao;

// Nao interage com dialogo aberto, desafio aberto ou durante o cooldown
if (instance_exists(Obj_Dialogo_Jardim)) exit;
if (global.desafio_plantar_aberto) exit;
if (cooldown > 0) exit;

// Interagir ao apertar E
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
            with (desafio) {
                abrir();
            }
        } else {
            show_debug_message("Erro: Obj_desafio_plantar não existe na room.");
        }
    }
}