// CREATE - Obj_terminal_array
// Objeto fisico da bancada/terminal.

solid = true;

// Usa a mascara do sprite atribuido ao objeto.
// No editor do sprite, ajuste a mascara para a base da bancada.
// Inicializacao do controle exclusivo de Arrays.
if (!variable_global_exists("desafio_array_aberto")) {
    global.desafio_array_aberto = false;
}

if (!variable_global_exists("desafio_array_concluido")) {
    global.desafio_array_concluido = false;
}

if (!variable_global_exists("acesso_boss_liberado")) {
    global.acesso_boss_liberado = false;
}
if (sprite_index != -1) {
    mask_index = sprite_index;
}

// Inicializa apenas se ainda nao existirem.
// Nao redefina global.desafio_aberto aqui: ela e compartilhada com outros desafios.
if (!variable_global_exists("desafio_aberto")) {
    global.desafio_aberto = false;
}

if (!variable_global_exists("desafio_array_concluido")) {
    global.desafio_array_concluido = false;
}

if (!variable_global_exists("acesso_boss_liberado")) {
    global.acesso_boss_liberado = false;
}

distancia_interacao = 48;
distancia_prompt = 32;
