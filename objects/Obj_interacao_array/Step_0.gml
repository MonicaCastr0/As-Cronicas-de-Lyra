
// STEP - Obj_interacao_array

if (!global.desafio_array_aberto) exit;

if (!instance_exists(dados)) {
    global.desafio_aberto = false;

    if (instance_exists(Obj_player)) {
        var jogador = instance_find(Obj_player, 0);
        jogador.pode_mover = true;
    }

    instance_destroy();
    exit;
}

var d = dados;

d.anim++;

if (d.shake > 0) {
    d.shake--;
}

var L = d.get_layout(0);
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Clique nas quatro alternativas.
if (mouse_check_button_pressed(mb_left)
&& (d.estado == 0 || d.estado == 1)) {

    for (var i = 0; i < 4; i++) {
        if (d.mouse_em(d.rect_opcao(L, i), mx, my)) {
            d.opcao_selecionada = i;
            d.estado = 0;
            d.msg = "";
        }
    }
}

// Clique no botao principal.
if (mouse_check_button_pressed(mb_left)
&& d.mouse_em(d.rect_botao(L), mx, my)) {

    if (d.estado == 3) {
        fechar_desafio();
        exit;
    } else {
        d.acao_botao();
    }
}

// ENTER ou ESPACO.
if (keyboard_check_pressed(vk_enter)
|| keyboard_check_pressed(vk_space)) {

    if (d.estado == 3) {
        fechar_desafio();
        exit;
    } else {
        d.acao_botao();
    }
}

// H mostra ou esconde a dica.
if (keyboard_check_pressed(ord("H"))) {
    d.mostrar_dica = !d.mostrar_dica;
}

// Teclas 1 a 4 selecionam alternativas.
if (d.estado == 0 || d.estado == 1) {

    if (keyboard_check_pressed(ord("1"))) {
        d.opcao_selecionada = 0;
        d.estado = 0;
        d.msg = "";
    }

    if (keyboard_check_pressed(ord("2"))) {
        d.opcao_selecionada = 1;
        d.estado = 0;
        d.msg = "";
    }

    if (keyboard_check_pressed(ord("3"))) {
        d.opcao_selecionada = 2;
        d.estado = 0;
        d.msg = "";
    }

    if (keyboard_check_pressed(ord("4"))) {
        d.opcao_selecionada = 3;
        d.estado = 0;
        d.msg = "";
    }
}

// ESC fecha o desafio.
if (keyboard_check_pressed(vk_escape)) {
    fechar_desafio();
    exit;
}
