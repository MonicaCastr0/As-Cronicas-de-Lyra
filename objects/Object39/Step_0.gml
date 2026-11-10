// Verifica se o jogador existe
if (!instance_exists(Obj_player)) {
    perto = false;
    exit;
}

// Calcula a distância até o jogador
var jogador = instance_find(Obj_player, 0);

perto = point_distance(
    x, y,
    jogador.x, jogador.y
) <= distancia_interacao;

// Interagir ao apertar E
if (perto && keyboard_check_pressed(ord("E"))) {

    var desafio = instance_find(Obj_desafio_plantar, 0);

    if (desafio != noone) {
        with (desafio) {
            abrir();
        }
    } else {
        show_debug_message(
            "Erro: Obj_desafio_plantar não existe na room."
        );
    }
}