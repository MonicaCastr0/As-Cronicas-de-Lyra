if (global.desafio_aberto)
{
    var largura = display_get_gui_width();
    var altura = display_get_gui_height();

    var janela_largura = 850;
    var janela_altura = 600;

    var centro_x = largura / 2;
    var centro_y = altura / 2;

    var esquerda = centro_x - janela_largura / 2;
    var topo = centro_y - janela_altura / 2;
    var baixo = centro_y + janela_altura / 2;

    // ==========================================
    // MOUSE
    // ==========================================

    var mouse_x_gui = device_mouse_x_to_gui(0);
    var mouse_y_gui = device_mouse_y_to_gui(0);

    if (mouse_check_button_pressed(mb_left))
    {
        // ======================================
        // CONDIÇÕES
        // ======================================

        if (point_in_rectangle(
            mouse_x_gui,
            mouse_y_gui,
            esquerda + 100,
            topo + 180,
            esquerda + 380,
            topo + 220
        ))
        {
            condicao_selecionada = 0;
        }

        if (point_in_rectangle(
            mouse_x_gui,
            mouse_y_gui,
            esquerda + 100,
            topo + 230,
            esquerda + 380,
            topo + 270
        ))
        {
            condicao_selecionada = 1;
        }

        if (point_in_rectangle(
            mouse_x_gui,
            mouse_y_gui,
            esquerda + 100,
            topo + 280,
            esquerda + 380,
            topo + 320
        ))
        {
            condicao_selecionada = 2;
        }

        // ======================================
        // ENTÃO
        // ======================================

        if (point_in_rectangle(
            mouse_x_gui,
            mouse_y_gui,
            esquerda + 430,
            topo + 220,
            esquerda + 790,
            topo + 260
        ))
        {
            acao_entao_selecionada = 0;
        }

        if (point_in_rectangle(
            mouse_x_gui,
            mouse_y_gui,
            esquerda + 430,
            topo + 270,
            esquerda + 790,
            topo + 310
        ))
        {
            acao_entao_selecionada = 1;
        }

        if (point_in_rectangle(
            mouse_x_gui,
            mouse_y_gui,
            esquerda + 430,
            topo + 320,
            esquerda + 790,
            topo + 360
        ))
        {
            acao_entao_selecionada = 2;
        }

        // ======================================
        // SENÃO
        // ======================================

        if (point_in_rectangle(
            mouse_x_gui,
            mouse_y_gui,
            esquerda + 100,
            topo + 380,
            esquerda + 400,
            topo + 420
        ))
        {
            acao_senao_selecionada = 0;
        }

        if (point_in_rectangle(
            mouse_x_gui,
            mouse_y_gui,
            esquerda + 100,
            topo + 430,
            esquerda + 400,
            topo + 470
        ))
        {
            acao_senao_selecionada = 1;
        }

        if (point_in_rectangle(
            mouse_x_gui,
            mouse_y_gui,
            esquerda + 100,
            topo + 480,
            esquerda + 400,
            topo + 520
        ))
        {
            acao_senao_selecionada = 2;
        }
		
		
		// ======================================
// BOTÃO EXECUTAR
// ======================================

if (point_in_rectangle(
    mouse_x_gui,
    mouse_y_gui,
    centro_x + 180,
    baixo - 75,
    centro_x + 340,
    baixo - 25
))
{
    if (condicao_selecionada == 0 &&
        acao_entao_selecionada == 0 &&
        acao_senao_selecionada == 0)
    {
        resultado = "CORRETO!";
    }
    else
    {
        resultado = "INCORRETO!";
    }
}
    }

    // ==========================================
    // ESC
    // ==========================================

    if (keyboard_check_pressed(vk_escape))
    {
        global.desafio_aberto = false;

        Obj_player.pode_mover = true;
    }
}