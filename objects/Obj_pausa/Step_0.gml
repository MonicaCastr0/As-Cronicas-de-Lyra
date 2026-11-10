// ==========================================================
// ETAPA (Step)  -  Obj_pausa
// ==========================================================

// Algum desafio aberto? (o ESC dele fecha o desafio, nao abre a pausa)
var bloqueado = (variable_global_exists("desafio_aberto") && global.desafio_aberto)
             || (variable_global_exists("chefe_aberto")   && global.chefe_aberto);

// mouse (para saber se ele se mexeu)
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
mouse_mexeu = (mx != mouse_ant_x || my != mouse_ant_y);
mouse_ant_x = mx;
mouse_ant_y = my;

if (modo == 0)
{
    // ESC abre a pausa, menos no menu principal e com desafio aberto
    if (keyboard_check_pressed(vk_escape) && room != Room_menu && !bloqueado && !bloq_ant)
    {
        abrir_pausa();
    }
}
else if (modo == 1) atualizar_pausa_menu();
else if (modo == 2) atualizar_config();
else if (modo == 3) atualizar_confirmacao();

bloq_ant = bloqueado;

if (aviso_timer > 0) aviso_timer--;
