// ==========================================================
// ETAPA (Step)  -  Obj_config
// ==========================================================

// A cada meio segundo confere se a tela continua certa e corrige sozinho
verif_timer++;
if (verif_timer >= 30)
{
    verif_timer = 0;
    corrigir_tela();
}

if (status_timer > 0)
{
    status_timer--;
    if (status_timer == 0) status_tela = "OK";
}

// F11 liga/desliga tela cheia em qualquer parte do jogo
if (keyboard_check_pressed(vk_f11))
{
    tela_cheia = !tela_cheia;
    aplicar_janela();
    salvar_config();
}

   if (keyboard_check_pressed(vk_f1)) mostrar_debug = !mostrar_debug;
