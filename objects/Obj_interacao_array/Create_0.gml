// CREATE - Obj_interacao_array
// Controla a abertura, a entrada do jogador e a interface visual.
// Este objeto e criado pelo Obj_terminal_array; nao o coloque manualmente na sala.

dados = instance_create_depth(0, 0, 0, Obj_desafio_array);

// Se a criacao do objeto de dados falhar, devolve o controle ao jogador.
if (dados == noone) {
    global.desafio_aberto = false;
    if (instance_exists(Obj_player)) {
        var jogador = instance_find(Obj_player, 0);
        jogador.pode_mover = true;
    }
    instance_destroy();
    exit;
}

// Encerra a interface, libera Lyra e remove o objeto de dados.
fechar_desafio = function() {
    global.desafio_aberto = false;

    if (instance_exists(Obj_player)) {
        var jogador = instance_find(Obj_player, 0);
        jogador.pode_mover = true;
    }

    if (instance_exists(dados)) {
        with (dados) instance_destroy();
    }

    instance_destroy();
};
