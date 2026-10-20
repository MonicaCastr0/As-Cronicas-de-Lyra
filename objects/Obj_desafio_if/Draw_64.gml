if (global.desafio_aberto)
{
    var largura = display_get_gui_width();
    var altura = display_get_gui_height();

    // ==========================================
    // FUNDO
    // ==========================================

    draw_set_alpha(0.75);
    draw_set_color(c_black);

    draw_rectangle(
        0,
        0,
        largura,
        altura,
        false
    );

    draw_set_alpha(1);

    // ==========================================
    // JANELA
    // ==========================================

    var janela_largura = 850;
    var janela_altura = 600;

    var centro_x = largura / 2;
    var centro_y = altura / 2;

    var esquerda = centro_x - janela_largura / 2;
    var topo = centro_y - janela_altura / 2;
    var direita = centro_x + janela_largura / 2;
    var baixo = centro_y + janela_altura / 2;

    // Fundo da janela
    draw_set_color(make_color_rgb(10, 15, 20));

    draw_rectangle(
        esquerda,
        topo,
        direita,
        baixo,
        false
    );

    // Borda
    draw_set_color(make_color_rgb(0, 180, 220));

    draw_rectangle(
        esquerda,
        topo,
        direita,
        baixo,
        true
    );

    // ==========================================
    // TÍTULO
    // ==========================================

    draw_set_color(c_white);

    draw_text(
        esquerda + 35,
        topo + 30,
        "CODELORE // TERMINAL DE ACESSO"
    );

    draw_text(
        esquerda + 35,
        topo + 70,
        "CONSTRUA A REGRA DO SISTEMA"
    );

    // ==========================================
    // INFORMAÇÕES
    // ==========================================

    draw_text(
        esquerda + 35,
        topo + 115,
        "ENERGIA ATUAL: " + string(energia) + "%"
    );

    draw_text(
        esquerda + 35,
        topo + 145,
        "REQUISITO MINIMO: 50%"
    );

    // ==========================================
    // CONDIÇÕES
    // ==========================================

    draw_set_color(c_white);

    draw_text(
        esquerda + 35,
        topo + 190,
        "SE"
    );

    // ---------- CONDIÇÃO 1 ----------

    if (condicao_selecionada == 0)
        draw_set_color(make_color_rgb(100, 180, 80));
    else
        draw_set_color(make_color_rgb(30, 45, 55));

    draw_rectangle(
        esquerda + 100,
        topo + 180,
        esquerda + 380,
        topo + 220,
        false
    );

    draw_set_color(c_white);

    draw_text(
        esquerda + 115,
        topo + 192,
        "energia >= 50"
    );

    // ---------- CONDIÇÃO 2 ----------

    if (condicao_selecionada == 1)
        draw_set_color(make_color_rgb(100, 180, 80));
    else
        draw_set_color(make_color_rgb(30, 45, 55));

    draw_rectangle(
        esquerda + 100,
        topo + 230,
        esquerda + 380,
        topo + 270,
        false
    );

    draw_set_color(c_white);

    draw_text(
        esquerda + 115,
        topo + 242,
        "energia < 50"
    );

    // ---------- CONDIÇÃO 3 ----------

    if (condicao_selecionada == 2)
        draw_set_color(make_color_rgb(100, 180, 80));
    else
        draw_set_color(make_color_rgb(30, 45, 55));

    draw_rectangle(
        esquerda + 100,
        topo + 280,
        esquerda + 380,
        topo + 320,
        false
    );

    draw_set_color(c_white);

    draw_text(
        esquerda + 115,
        topo + 292,
        "sistema = ativo"
    );

    // ==========================================
    // ENTÃO
    // ==========================================

    draw_text(
        esquerda + 430,
        topo + 190,
        "ENTAO"
    );

    // AÇÃO 1

    if (acao_entao_selecionada == 0)
        draw_set_color(make_color_rgb(100, 180, 80));
    else
        draw_set_color(make_color_rgb(30, 45, 55));

    draw_rectangle(
        esquerda + 430,
        topo + 220,
        esquerda + 790,
        topo + 260,
        false
    );

    draw_set_color(c_white);

    draw_text(
        esquerda + 445,
        topo + 232,
        "ABRIR PORTA"
    );

    // AÇÃO 2

    if (acao_entao_selecionada == 1)
        draw_set_color(make_color_rgb(100, 180, 80));
    else
        draw_set_color(make_color_rgb(30, 45, 55));

    draw_rectangle(
        esquerda + 430,
        topo + 270,
        esquerda + 790,
        topo + 310,
        false
    );

    draw_set_color(c_white);

    draw_text(
        esquerda + 445,
        topo + 282,
        "MANTER PORTA BLOQUEADA"
    );

    // AÇÃO 3

    if (acao_entao_selecionada == 2)
        draw_set_color(make_color_rgb(100, 180, 80));
    else
        draw_set_color(make_color_rgb(30, 45, 55));

    draw_rectangle(
        esquerda + 430,
        topo + 320,
        esquerda + 790,
        topo + 360,
        false
    );

    draw_set_color(c_white);

    draw_text(
        esquerda + 445,
        topo + 332,
        "ATIVAR ALARME"
    );

    // ==========================================
    // SENÃO
    // ==========================================

    draw_text(
        esquerda + 35,
        topo + 390,
        "SENAO"
    );

    // SENÃO 1

    if (acao_senao_selecionada == 0)
        draw_set_color(make_color_rgb(100, 180, 80));
    else
        draw_set_color(make_color_rgb(30, 45, 55));

    draw_rectangle(
        esquerda + 100,
        topo + 380,
        esquerda + 400,
        topo + 420,
        false
    );

    draw_set_color(c_white);

    draw_text(
        esquerda + 115,
        topo + 392,
        "MANTER BLOQUEADA"
    );

    // SENÃO 2

    if (acao_senao_selecionada == 1)
        draw_set_color(make_color_rgb(100, 180, 80));
    else
        draw_set_color(make_color_rgb(30, 45, 55));

    draw_rectangle(
        esquerda + 100,
        topo + 430,
        esquerda + 400,
        topo + 470,
        false
    );

    draw_set_color(c_white);

    draw_text(
        esquerda + 115,
        topo + 442,
        "ABRIR PORTA"
    );

    // SENÃO 3

    if (acao_senao_selecionada == 2)
        draw_set_color(make_color_rgb(100, 180, 80));
    else
        draw_set_color(make_color_rgb(30, 45, 55));

    draw_rectangle(
        esquerda + 100,
        topo + 480,
        esquerda + 400,
        topo + 520,
        false
    );

    draw_set_color(c_white);

    draw_text(
        esquerda + 115,
        topo + 492,
        "ATIVAR ALARME"
    );

    // ==========================================
    // BOTÃO EXECUTAR
    // ==========================================
if (resultado != "")
{
    draw_set_color(c_white);

    draw_text(
        esquerda + 430,
        topo + 390,
        resultado
    );
}
    draw_set_color(make_color_rgb(70, 120, 40));

    draw_rectangle(
        centro_x + 180,
        baixo - 75,
        centro_x + 340,
        baixo - 25,
        false
    );
	
	

    draw_set_color(c_white);

    draw_text(
        centro_x + 215,
        baixo - 60,
        "EXECUTAR"
    );
	

    // ==========================================
    // INSTRUÇÃO
    // ==========================================

    draw_text(
        esquerda + 35,
        baixo - 30,
        "ESC - Fechar"
    );
}