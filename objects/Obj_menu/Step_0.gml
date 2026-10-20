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


// ==========================================
// MOVIMENTO DA CÂMERA
// ==========================================

if (camera_y < camera_fim_y)
{
    camera_y += vel_camera;

    if (camera_y > camera_fim_y)
    {
        camera_y = camera_fim_y;
    }

    camera_set_view_pos(
        camera_id,
        0,
        camera_y
    );
}