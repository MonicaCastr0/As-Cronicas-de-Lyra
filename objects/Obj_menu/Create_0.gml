// ==========================================
// CONFIGURAÇÃO
// ==========================================

parallax_largura = 1280;

// Câmera
camera_id = view_camera[0];

camera_inicio_y = 0;
camera_fim_y = 720;

camera_y = camera_inicio_y;

// Altura onde começa a segunda área
altura_cena = 720;

altura_cena2 = 520;   // use o valor que você tinha antes
x_12 = 0;
vel_12 = 0.3;         // use a velocidade que você tinha antes


// ==========================================
// POSIÇÃO DE CADA CAMADA
// ==========================================

x_00 = 0;
x_01 = 0;
x_02 = 0;
x_03 = 0;
x_04 = 0;
x_05 = 0;
x_06 = 0;
x_07 = 0;
x_08 = 0;
x_09 = 0;
x_10 = 0;
x_11 = 0;


// ==========================================
// VELOCIDADE DE CADA CAMADA
// ==========================================

vel_00 = 0.30;
vel_01 = 0.27;
vel_02 = 0.24;
vel_03 = 0.21;
vel_04 = 0.18;
vel_05 = 0.15;
vel_06 = 0.12;
vel_07 = 0.10;
vel_08 = 0.08;
vel_09 = 0.06;
vel_10 = 0.04;
vel_11 = 0.02;


// ==========================================
// SEQUÊNCIA DE ABERTURA
// estado: 0 = patrocinadores | 1 = câmera descendo | 2 = menu
// ==========================================

estado = 0;
fase_timer = 0;

// ---------- Patrocinadores ----------
// logo: nome do sprite (ex: spr_logo_patrocinio1) ou -1 para mostrar só o nome
patrocinadores = [
    { nome: "PATROCINADOR 1", logo: -1 },
    { nome: "PATROCINADOR 2", logo: -1 },
    { nome: "PATROCINADOR 3", logo: -1 }
];

texto_patrocinio = "COM O APOIO DE";

tempo_fade_in  = 60;     // frames (60 = 1 segundo)
tempo_exibicao = 180;    // quanto tempo ficam na tela
tempo_fade_out = 45;
patro_alpha = 0;

// ---------- Descida da câmera ----------
dur_descida = 150;       // frames (150 = 2,5 segundos)

// ---------- Menu ----------
opcoes = ["INICIAR JOGO", "CARREGAR JOGO", "CONFIGURACOES"];
opcao_sel = 0;
menu_alpha = 0;

sala_jogo = Room_alternativo;          // coloque aqui a sala do jogo, ex: sala_jogo = Room_1;

aviso = "";
aviso_timer = 0;

mouse_ant_x = -1;
mouse_ant_y = -1;
mouse_mexeu = false;

// Garante que o controlador de tela existe (ele e persistente)
if (!instance_exists(Obj_config)) instance_create_depth(0, 0, 0, Obj_config);

// Retângulo de cada opção do menu (coordenadas da GUI)
rect_opcao = function(i)
{
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();
    var x1 = gw / 2 - 190;
    var y1 = gh * 0.60 + i * 66;
    return [x1, y1, x1 + 380, y1 + 52];
}

mostrar_aviso = function(texto)
{
    aviso = texto;
    aviso_timer = 150;
}

escolher_opcao = function(i)
{
    if (i == 0)
    {
        if (sala_jogo != -1) room_goto(sala_jogo);
        else mostrar_aviso("DEFINA A sala_jogo NO CREATE");
    }
    else if (i == 1)
    {
        mostrar_aviso("EM BREVE: CARREGAR JOGO");
    }
    else if (i == 2)
    {
        em_config = true;
        cfg_sel = 0;
    }
}


// ==========================================
// CONFIGURAÇÕES (tela, volume e auto-correção)
// ==========================================

em_config = false;
cfg_sel = 0;
cfg_nomes = ["TELA CHEIA", "TAMANHO DA JANELA", "ZOOM DO JOGO", "VOLUME", "CORRIGIR TELA AUTOMATICAMENTE", "VOLTAR"];

// Retângulo de cada linha da tela de configurações
cfg_rect = function(i)
{
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();
    var y1 = gh * 0.10 + 90 + i * 64;
    return [gw / 2 - 300, y1, gw / 2 + 300, y1 + 50];
}
cfg_rect_menos = function(i)
{
    var r = cfg_rect(i);
    return [r[2] - 250, r[1] + 8, r[2] - 220, r[3] - 8];
}
cfg_rect_mais = function(i)
{
    var r = cfg_rect(i);
    return [r[2] - 60, r[1] + 8, r[2] - 30, r[3] - 8];
}

// Texto do valor de cada linha
cfg_valor = function(i)
{
    var c = instance_find(Obj_config, 0);
    if (i == 0) return c.tela_cheia ? "SIM" : "NAO";
    if (i == 1)
    {
        if (c.tela_cheia) return "TELA CHEIA";
        var j = c.opcoes_janela[c.janela_idx];
        return string(j[0]) + "x" + string(j[1]);
    }
    if (i == 2) return string(c.opcoes_zoom[c.zoom_idx]) + "x";
    if (i == 3) return string(c.volume) + "%";
    return "";
}

// dir = -1 (diminui / anterior), +1 (aumenta / proximo / aciona)
cfg_mudar = function(i, dir)
{
    var c = instance_find(Obj_config, 0);
    var n;

    if (i == 0)
    {
        c.tela_cheia = !c.tela_cheia;
        c.aplicar_janela();
        c.aplicar_tela();
    }
    else if (i == 1)
    {
        n = array_length(c.opcoes_janela);
        c.janela_idx = (c.janela_idx + dir + n) mod n;
        c.aplicar_janela();
    }
    else if (i == 2)
    {
        n = array_length(c.opcoes_zoom);
        c.zoom_idx = (c.zoom_idx + dir + n) mod n;
        c.aplicar_tela();
    }
    else if (i == 3)
    {
        c.volume = clamp(c.volume + dir * 10, 0, 100);
        c.aplicar_tela();
    }
    else if (i == 4)
    {
        c.corrigir_tudo();
        mostrar_aviso("TELA CORRIGIDA");
    }
    else if (i == 5)
    {
        em_config = false;
    }

    c.salvar_config();
}

atualizar_config = function()
{
    var n = array_length(cfg_nomes);

    // teclado
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) cfg_sel = (cfg_sel + 1) mod n;
    if (keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W"))) cfg_sel = (cfg_sel - 1 + n) mod n;

    if (cfg_sel <= 3)
    {
        if (keyboard_check_pressed(vk_left))  cfg_mudar(cfg_sel, -1);
        if (keyboard_check_pressed(vk_right)) cfg_mudar(cfg_sel, 1);
    }
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) cfg_mudar(cfg_sel, 1);
    if (keyboard_check_pressed(vk_escape)) em_config = false;

    // mouse
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    var clicou = mouse_check_button_pressed(mb_left);

    for (var i = 0; i < n; i++)
    {
        var r = cfg_rect(i);
        if (!point_in_rectangle(mx, my, r[0], r[1], r[2], r[3])) continue;

        if (mouse_mexeu) cfg_sel = i;

        if (clicou && em_config)
        {
            var rm = cfg_rect_menos(i);
            var rp = cfg_rect_mais(i);

            if (i <= 3 && i != 0 && point_in_rectangle(mx, my, rm[0], rm[1], rm[2], rm[3])) cfg_mudar(i, -1);
            else if (i <= 3 && i != 0 && point_in_rectangle(mx, my, rp[0], rp[1], rp[2], rp[3])) cfg_mudar(i, 1);
            else if (i == 0 || i >= 4) cfg_mudar(i, 1);
        }
    }
}

if (variable_global_exists("pular_abertura") && global.pular_abertura)
{
    global.pular_abertura = false;
    estado = 2;
    camera_y = camera_fim_y;
    patro_alpha = 0;
}
