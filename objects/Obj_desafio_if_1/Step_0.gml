// ==========================================================
// ETAPA (Step)  -  Desafio da Porta Eletronica
// ==========================================================
if (!global.desafio_aberto) exit;

anim++;
if (shake > 0) shake--;

var L  = get_layout(0);
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var fase = fases[fase_atual];

// ---------- Clique do mouse ----------
if (mouse_check_button_pressed(mb_left) && estado != 3)
{
    // So permite mexer nas opcoes enquanto nao acertou a fase
    if (estado == 0 || estado == 1)
    {
        for (var i = 0; i < 3; i++)
        {
            if (mouse_em(rect_cond(L, i), mx, my))
            {
                condicao_selecionada = i;
                estado = 0; msg = ""; ramo = "";
            }
            if (mouse_em(rect_entao(L, i), mx, my))
            {
                acao_entao_selecionada = i;
                estado = 0; msg = ""; ramo = "";
            }
            if (mouse_em(rect_senao(L, i), mx, my))
            {
                acao_senao_selecionada = i;
                estado = 0; msg = ""; ramo = "";
            }
        }
    }
}

// Botao principal (EXECUTAR / PROXIMA FASE / FECHAR)
if (mouse_check_button_pressed(mb_left) && mouse_em(rect_botao(L), mx, my))
{
    acao_botao();
}

// ---------- Atalhos de teclado ----------
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))
{
    acao_botao();
}

// Tecla H mostra / esconde a dica
if (keyboard_check_pressed(ord("H")))
{
    mostrar_dica = !mostrar_dica;
}

// Teclas 1, 2, 3 escolhem a condicao rapidamente
if (estado == 0 || estado == 1)
{
    if (keyboard_check_pressed(ord("1"))) { condicao_selecionada = 0; estado = 0; msg = ""; }
    if (keyboard_check_pressed(ord("2"))) { condicao_selecionada = 1; estado = 0; msg = ""; }
    if (keyboard_check_pressed(ord("3"))) { condicao_selecionada = 2; estado = 0; msg = ""; }
}

// ---------- ESC ----------
if (keyboard_check_pressed(vk_escape))
{
    fechar_desafio();
}
