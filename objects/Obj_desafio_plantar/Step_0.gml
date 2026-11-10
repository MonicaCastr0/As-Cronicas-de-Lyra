// ==========================================================
// ETAPA (Step)  -  Desafio do Jardim (VERSAO DIFICIL)
// ==========================================================
if (!global.desafio_plantar_aberto) exit;

anim++;
if (shake > 0) shake--;

robo_pos = lerp(robo_pos, plot_atual, 0.15);

if (entrada_bloqueada > 0)
{
    entrada_bloqueada--;
    exit;
}

var L  = get_layout(0);
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var editavel = (estado == 0 || estado == 1);
var n_ferr = array_length(passos);

// ---------- Execucao da sequencia ----------
if (estado == 4)
{
    exec_timer++;
    if (exec_timer >= exec_delay)
    {
        exec_timer = 0;
        processar_execucao();
    }
}

// ---------- Cliques do mouse ----------
if (mouse_check_button_pressed(mb_left))
{
    if (editavel)
    {
        for (var i = 0; i < n_ferr; i++)
        {
            if (mouse_em(rect_ferr(L, i), mx, my))
            {
                adicionar_passo(i);
            }
        }

        for (var j = 0; j < array_length(sequencia); j++)
        {
            if (mouse_em(rect_slot(L, j), mx, my))
            {
                remover_passo(j);
                break;
            }
        }

        if (mouse_em(rect_limpar(L), mx, my))
        {
            limpar();
        }
    }

    if (mouse_em(rect_botao(L), mx, my))
    {
        acao_botao();
    }
}

// ---------- Atalhos de teclado ----------
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))
{
    acao_botao();
}

if (keyboard_check_pressed(ord("H")))
{
    mostrar_dica = !mostrar_dica;
}

// Teclas 1 a 7 escolhem a ferramenta; BACKSPACE apaga o ultimo passo
if (estado == 0 || estado == 1)
{
    for (var k = 0; k < n_ferr; k++)
    {
        if (keyboard_check_pressed(ord("1") + k)) adicionar_passo(k);
    }

    if (keyboard_check_pressed(vk_backspace) && array_length(sequencia) > 0)
    {
        remover_passo(array_length(sequencia) - 1);
    }
}

// ---------- ESC ----------
if (keyboard_check_pressed(vk_escape))
{
    fechar_desafio();
}
