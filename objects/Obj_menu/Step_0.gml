// ==========================================
// ATUALIZAR PARALLAX
// ==========================================

x_00 += vel_00;
x_01 += vel_01;
x_02 += vel_02;
x_03 += vel_03;
x_04 += vel_04;
x_05 += vel_05;
x_06 += vel_06;
x_07 += vel_07;
x_08 += vel_08;
x_09 += vel_09;
x_10 += vel_10;
x_11 += vel_11;

x_12 += vel_12;



// ==========================================
// REPETIR AS CAMADAS
// ==========================================

if (x_00 >= parallax_largura) x_00 -= parallax_largura;
if (x_01 >= parallax_largura) x_01 -= parallax_largura;
if (x_02 >= parallax_largura) x_02 -= parallax_largura;
if (x_03 >= parallax_largura) x_03 -= parallax_largura;
if (x_04 >= parallax_largura) x_04 -= parallax_largura;
if (x_05 >= parallax_largura) x_05 -= parallax_largura;
if (x_06 >= parallax_largura) x_06 -= parallax_largura;
if (x_07 >= parallax_largura) x_07 -= parallax_largura;
if (x_08 >= parallax_largura) x_08 -= parallax_largura;
if (x_09 >= parallax_largura) x_09 -= parallax_largura;
if (x_10 >= parallax_largura) x_10 -= parallax_largura;
if (x_11 >= parallax_largura) x_11 -= parallax_largura;
if (x_12 >= parallax_largura) x_12 -= parallax_largura;


// ==========================================
// SEQUÊNCIA DE ABERTURA
// ==========================================

fase_timer++;

var clicou = mouse_check_button_pressed(mb_left);
var tecla  = keyboard_check_pressed(vk_anykey);

// mouse (para saber se ele se mexeu)
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
mouse_mexeu = (mx != mouse_ant_x || my != mouse_ant_y);
mouse_ant_x = mx;
mouse_ant_y = my;

// ---------- 0: patrocinadores ----------
if (estado == 0)
{
    var t_fim_in  = tempo_fade_in;
    var t_fim_exp = tempo_fade_in + tempo_exibicao;
    var t_fim_out = tempo_fade_in + tempo_exibicao + tempo_fade_out;

    if (fase_timer < t_fim_in)       patro_alpha = fase_timer / tempo_fade_in;
    else if (fase_timer < t_fim_exp) patro_alpha = 1;
    else if (fase_timer < t_fim_out) patro_alpha = 1 - (fase_timer - t_fim_exp) / tempo_fade_out;
    else
    {
        patro_alpha = 0;
        estado = 1;
        fase_timer = 0;
    }

    // qualquer tecla ou clique pula os patrocinadores
    if ((tecla || clicou) && fase_timer > 20 && estado == 0)
    {
        estado = 1;
        fase_timer = 0;
    }
}

// ---------- 1: câmera descendo (suave) ----------
else if (estado == 1)
{
    var t = clamp(fase_timer / dur_descida, 0, 1);
    var suave = -(cos(pi * t) - 1) / 2;

    camera_y = lerp(camera_inicio_y, camera_fim_y, suave);

    if (t >= 1)
    {
        camera_y = camera_fim_y;
        estado = 2;
        fase_timer = 0;
    }
}

// ---------- 2: menu ----------
else
{
    if (fase_timer > 20) menu_alpha = min(1, menu_alpha + 0.04);

    if (menu_alpha >= 0.6)
    {
        if (em_config)
        {
            atualizar_config();
        }
        else
        {
            var n = array_length(opcoes);

            // teclado
            if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
                opcao_sel = (opcao_sel + 1) mod n;
            if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")))
                opcao_sel = (opcao_sel - 1 + n) mod n;

            if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))
                escolher_opcao(opcao_sel);

            // mouse (so troca a selecao quando o mouse se mexe)
            for (var i = 0; i < n; i++)
            {
                var r = rect_opcao(i);
                if (point_in_rectangle(mx, my, r[0], r[1], r[2], r[3]))
                {
                    if (mouse_mexeu) opcao_sel = i;
                    if (clicou) escolher_opcao(i);
                }
            }
        }
    }
}

if (aviso_timer > 0) aviso_timer--;


// ==========================================
// POSIÇÃO DA CÂMERA
// (o tamanho da câmera agora é controlado pelo Obj_config)
// ==========================================

camera_set_view_pos(
    camera_id,
    0,
    camera_y
);
