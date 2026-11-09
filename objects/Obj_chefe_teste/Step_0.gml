// ==========================================================
// ETAPA (Step)  -  Desafio Final: NULLERROR  v2
// ==========================================================
if (!global.chefe_aberto)
{
    estava_aberto = false;
    exit;
}

// Ao abrir, reinicia o desafio do comeco
if (!estava_aberto)
{
    iniciar_chefe();
    estava_aberto = true;
}

anim++;
if (shake > 0) shake--;

var L  = get_layout(0);
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var clicou = mouse_check_button_pressed(mb_left);

atualizar_exec();

// ---------- ESC ----------
if (keyboard_check_pressed(vk_escape))
{
    fechar_chefe();
    exit;
}

// ---------- Dialogo aberto: so avanca ----------
if (em_dialogo)
{
    if (clicou || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))
    {
        avancar_dialogo();
    }
    exit;
}

// ---------- Vitoria ----------
if (etapa == 5)
{
    if ((clicou && mouse_em(rect_executar(L), mx, my)) || keyboard_check_pressed(vk_enter))
    {
        fechar_chefe();
    }
    exit;
}

// ---------- Observando o chefe (ENTER pula) ----------
if (etapa == 3)
{
    if (exec_ativo && (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)))
    {
        finalizar_exec();
    }
    exit;
}

// ---------- Sem interacao na introducao ou durante a execucao ----------
if (etapa == 0 || exec_ativo) exit;

// ---------- Etapas 1, 2 e 4: montar a sequencia ----------
if (clicou)
{
    for (var i = 0; i < 3; i++)
    {
        if (mouse_em(rect_paleta(L, i), mx, my)) adicionar_acao(i);
        if (mouse_em(rect_slot(L, i), mx, my))   remover_acao(i);
    }

    if (usa_loop)
    {
        if (mouse_em(rect_menos(L), mx, my)) repeticoes = max(1, repeticoes - 1);
        if (mouse_em(rect_mais(L), mx, my))  repeticoes = min(repeticoes_max, repeticoes + 1);
    }

    if (mouse_em(rect_limpar(L), mx, my))
    {
        sequencia = [];
        msg = "";
    }

    if (mouse_em(rect_executar(L), mx, my)) executar();
}

// ---------- Teclado ----------
if (keyboard_check_pressed(ord("1"))) adicionar_acao(0);
if (keyboard_check_pressed(ord("2"))) adicionar_acao(1);
if (keyboard_check_pressed(ord("3"))) adicionar_acao(2);

if (keyboard_check_pressed(vk_backspace))
{
    remover_acao(array_length(sequencia) - 1);
}

if (usa_loop)
{
    if (keyboard_check_pressed(vk_up))   repeticoes = min(repeticoes_max, repeticoes + 1);
    if (keyboard_check_pressed(vk_down)) repeticoes = max(1, repeticoes - 1);
}

if (keyboard_check_pressed(vk_enter)) executar();
