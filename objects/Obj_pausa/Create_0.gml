// ==========================================================
// Menu de pausa: ESC abre em qualquer room, menos no menu principal.
// ==========================================================

// So pode existir UM
if (instance_number(Obj_pausa) > 1)
{
    instance_destroy();
    exit;
}

if (!variable_global_exists("pausado"))        global.pausado = false;
if (!variable_global_exists("pular_abertura")) global.pular_abertura = false;

depth = -10000;      // desenha por cima de tudo

// modo: 0 = fechado | 1 = menu de pausa | 2 = configuracoes | 3 = confirmar saida
modo = 0;
sel = 0;
cfg_sel = 0;
pode_antes = true;   // se o player podia andar antes de pausar
bloq_ant = false;    // um desafio estava aberto no passo anterior?

aviso = "";
aviso_timer = 0;

mouse_ant_x = -1;
mouse_ant_y = -1;
mouse_mexeu = false;

// ---------- Menu de pausa ----------
pausa_opcoes = ["CONTINUAR", "CONFIGURACOES", "VOLTAR AO MENU PRINCIPAL"];
conf_opcoes  = ["SIM, VOLTAR AO MENU", "NAO, CONTINUAR AQUI"];

// ---------- Configuracoes ----------
// tipo "breve" = ainda nao implementado (aparece como EM BREVE)
// Quando implementar uma, troque o tipo e trate em cfg_mudar().
cfg_itens = [
    { nome: "TELA CHEIA",            tipo: "cheia"    },
    { nome: "TAMANHO DA JANELA",     tipo: "janela"   },
    { nome: "ZOOM DO JOGO",          tipo: "zoom"     },
    { nome: "VOLUME GERAL",          tipo: "volume"   },
    { nome: "VOLUME DA MUSICA",      tipo: "breve"    },
    { nome: "VOLUME DOS EFEITOS",    tipo: "breve"    },
    { nome: "CONTROLES",             tipo: "breve"    },
    { nome: "IDIOMA",                tipo: "breve"    },
    { nome: "CORRIGIR TELA AUTOMATICAMENTE", tipo: "corrigir" },
    { nome: "VOLTAR",                tipo: "voltar"   }
];

// ==========================================================
// ABRIR / FECHAR
// ==========================================================
mostrar_aviso = function(texto)
{
    aviso = texto;
    aviso_timer = 150;
}

abrir_pausa = function()
{
    modo = 1;
    sel = 0;
    cfg_sel = 0;
    global.pausado = true;

    pode_antes = true;
    var p = instance_find(Obj_player, 0);
    if (p != noone)
    {
        if (variable_instance_exists(p, "pode_mover")) pode_antes = p.pode_mover;
        p.pode_mover = false;
    }
}

fechar_pausa = function()
{
    modo = 0;
    global.pausado = false;

    var p = instance_find(Obj_player, 0);
    if (p != noone) p.pode_mover = pode_antes;
}

voltar_ao_menu = function()
{
    global.pular_abertura = true;    // o menu pula os patrocinadores
    fechar_pausa();
    room_goto(Room_menu);
}

// ==========================================================
// RETANGULOS (coordenadas da GUI)
// ==========================================================
rect_lista = function(i)
{
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();
    var x1 = gw / 2 - 210;
    var y1 = gh * 0.40 + i * 66;
    return [x1, y1, x1 + 420, y1 + 52];
}

cfg_rect = function(i)
{
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();
    var y1 = gh / 2 - 320 + 80 + i * 52;
    return [gw / 2 - 340, y1, gw / 2 + 340, y1 + 44];
}
cfg_rect_menos = function(i)
{
    var r = cfg_rect(i);
    return [r[2] - 250, r[1] + 7, r[2] - 220, r[3] - 7];
}
cfg_rect_mais = function(i)
{
    var r = cfg_rect(i);
    return [r[2] - 60, r[1] + 7, r[2] - 30, r[3] - 7];
}

// ==========================================================
// CONFIGURACOES
// ==========================================================
cfg_tem_valor = function(i)
{
    var t = cfg_itens[i].tipo;
    return (t == "cheia" || t == "janela" || t == "zoom" || t == "volume");
}

cfg_valor = function(i)
{
    var c = instance_find(Obj_config, 0);
    var t = cfg_itens[i].tipo;

    if (t == "cheia")  return c.tela_cheia ? "SIM" : "NAO";
    if (t == "janela")
    {
        if (c.tela_cheia) return "TELA CHEIA";
        var j = c.opcoes_janela[c.janela_idx];
        return string(j[0]) + "x" + string(j[1]);
    }
    if (t == "zoom")   return string(c.opcoes_zoom[c.zoom_idx]) + "x";
    if (t == "volume") return string(c.volume) + "%";
    return "";
}

// dir = -1 (diminui / anterior), +1 (aumenta / proximo / aciona)
cfg_mudar = function(i, dir)
{
    var c = instance_find(Obj_config, 0);
    var t = cfg_itens[i].tipo;
    var n;

    if (t == "cheia")
    {
        c.tela_cheia = !c.tela_cheia;
        c.aplicar_janela();
        c.aplicar_tela();
    }
    else if (t == "janela")
    {
        n = array_length(c.opcoes_janela);
        c.janela_idx = (c.janela_idx + dir + n) mod n;
        c.aplicar_janela();
    }
    else if (t == "zoom")
    {
        n = array_length(c.opcoes_zoom);
        c.zoom_idx = (c.zoom_idx + dir + n) mod n;
        c.aplicar_tela();
    }
    else if (t == "volume")
    {
        c.volume = clamp(c.volume + dir * 10, 0, 100);
        c.aplicar_tela();
    }
    else if (t == "corrigir")
    {
        c.corrigir_tudo();
        mostrar_aviso("TELA CORRIGIDA");
    }
    else if (t == "breve")
    {
        mostrar_aviso("EM BREVE");
        return;
    }
    else if (t == "voltar")
    {
        modo = 1;
        return;
    }

    c.salvar_config();
}

// ==========================================================
// ATUALIZAR CADA TELA
// ==========================================================
escolher_pausa = function(i)
{
    if (i == 0) fechar_pausa();
    else if (i == 1) { modo = 2; cfg_sel = 0; }
    else if (i == 2) { modo = 3; sel = 1; }     // comeca em "NAO"
}

atualizar_lista = function(n, esc_volta_para)
{
    // teclado
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) sel = (sel + 1) mod n;
    if (keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W"))) sel = (sel - 1 + n) mod n;

    var acionar = -1;
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) acionar = sel;

    // mouse
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    var clicou = mouse_check_button_pressed(mb_left);

    for (var i = 0; i < n; i++)
    {
        var r = rect_lista(i);
        if (point_in_rectangle(mx, my, r[0], r[1], r[2], r[3]))
        {
            if (mouse_mexeu) sel = i;
            if (clicou) acionar = i;
        }
    }

    return acionar;
}

atualizar_pausa_menu = function()
{
    var a = atualizar_lista(array_length(pausa_opcoes), 0);
    if (a != -1) escolher_pausa(a);
    else if (keyboard_check_pressed(vk_escape)) fechar_pausa();
}

atualizar_confirmacao = function()
{
    var a = atualizar_lista(array_length(conf_opcoes), 1);
    if (a == 0) voltar_ao_menu();
    else if (a == 1) { modo = 1; sel = 0; }
    else if (keyboard_check_pressed(vk_escape)) { modo = 1; sel = 0; }
}

atualizar_config = function()
{
    var n = array_length(cfg_itens);

    // teclado
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) cfg_sel = (cfg_sel + 1) mod n;
    if (keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W"))) cfg_sel = (cfg_sel - 1 + n) mod n;

    if (cfg_tem_valor(cfg_sel))
    {
        if (keyboard_check_pressed(vk_left))  cfg_mudar(cfg_sel, -1);
        if (keyboard_check_pressed(vk_right)) cfg_mudar(cfg_sel, 1);
    }
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) cfg_mudar(cfg_sel, 1);
    if (keyboard_check_pressed(vk_escape)) { modo = 1; return; }

    // mouse
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    var clicou = mouse_check_button_pressed(mb_left);

    for (var i = 0; i < n; i++)
    {
        var r = cfg_rect(i);
        if (!point_in_rectangle(mx, my, r[0], r[1], r[2], r[3])) continue;

        if (mouse_mexeu) cfg_sel = i;

        if (clicou && modo == 2)
        {
            var rm = cfg_rect_menos(i);
            var rp = cfg_rect_mais(i);
            var t = cfg_itens[i].tipo;
            var setas = (cfg_tem_valor(i) && t != "cheia");

            if (setas && point_in_rectangle(mx, my, rm[0], rm[1], rm[2], rm[3])) cfg_mudar(i, -1);
            else if (setas && point_in_rectangle(mx, my, rp[0], rp[1], rp[2], rp[3])) cfg_mudar(i, 1);
            else if (!setas) cfg_mudar(i, 1);
        }
    }
}

// ==========================================================
// DESENHO (helper)
// ==========================================================
desenhar_botao_menu = function(r, texto, selecionado, alfa)
{
    var dourado = make_color_rgb(230, 190, 90);
    var cx = (r[0] + r[2]) / 2;
    var cy = (r[1] + r[3]) / 2;

    draw_set_alpha(alfa * (selecionado ? 0.9 : 0.6));
    draw_set_color(selecionado ? make_color_rgb(30, 52, 70) : make_color_rgb(8, 14, 24));
    draw_roundrect_ext(r[0], r[1], r[2], r[3], 12, 12, false);

    draw_set_alpha(alfa * (selecionado ? 1 : 0.5));
    draw_set_color(selecionado ? dourado : make_color_rgb(60, 80, 100));
    draw_roundrect_ext(r[0], r[1], r[2], r[3], 12, 12, true);

    draw_set_alpha(alfa);
    draw_set_color(selecionado ? dourado : make_color_rgb(200, 210, 220));
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(cx, cy, texto, selecionado ? 1.2 : 1.1, selecionado ? 1.2 : 1.1, 0);
}
