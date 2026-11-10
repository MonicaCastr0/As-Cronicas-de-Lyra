// ==========================================================
// CRIAR  -  Obj_config   (MARQUE "Persistent" NO OBJETO)
// Controla tela, camera, GUI e volume do jogo inteiro.
// Fica vivo entre as salas e se auto corrige.
// ==========================================================

// So pode existir UM. Se ja existe (veio de outra sala), este some.
if (instance_number(Obj_config) > 1)
{
    instance_destroy();
    exit;
}
if (!variable_global_exists("pausado")) global.pausado = false;
if (!instance_exists(Obj_pausa)) instance_create_depth(0, 0, 0, Obj_pausa);

// ---------- Tamanho base do jogo (nao mude no meio do jogo) ----------
base_w = 1280;
base_h = 720;

opcoes_janela = [[1280, 720], [1600, 900], [1920, 1080]];
opcoes_zoom   = [1, 1.5, 2];      // zoom da camera DENTRO do jogo (o menu sempre usa 1)

// ---------- Padroes ----------
tela_cheia = false;
janela_idx = 0;
zoom_idx   = 0;
volume     = 100;

status_tela = "OK";
status_timer = 0;
verif_timer = 0;

// ---------- Carregar o que o jogador salvou ----------
ini_open("config.ini");
tela_cheia = (ini_read_real("tela", "cheia", 0) == 1);
janela_idx = clamp(ini_read_real("tela", "janela", 0), 0, array_length(opcoes_janela) - 1);
zoom_idx   = clamp(ini_read_real("tela", "zoom", 0),   0, array_length(opcoes_zoom) - 1);
volume     = clamp(ini_read_real("som", "volume", 100), 0, 100);
ini_close();

// ==========================================================
// FUNCOES
// ==========================================================

salvar_config = function()
{
    ini_open("config.ini");
    ini_write_real("tela", "cheia",  tela_cheia ? 1 : 0);
    ini_write_real("tela", "janela", janela_idx);
    ini_write_real("tela", "zoom",   zoom_idx);
    ini_write_real("som",  "volume", volume);
    ini_close();
}

// Zoom que vale para a sala atual (menu = 1)
zoom_da_sala = function()
{
    return (room == Room_menu) ? 1 : opcoes_zoom[zoom_idx];
}

// Janela do Windows: tela cheia ou tamanho escolhido
aplicar_janela = function()
{
    if (tela_cheia)
    {
        window_set_fullscreen(true);
    }
    else
    {
        window_set_fullscreen(false);
        var j = opcoes_janela[janela_idx];
        window_set_size(j[0], j[1]);
        window_center();
    }
}

// O CORACAO: deixa superficie, GUI, viewport e camera sempre iguais
aplicar_tela = function()
{
    // 1) Viewport fixa em 1280x720 (o que aparece na janela)
    view_enabled = true;
    view_visible[0] = true;
    view_wport[0] = base_w;
    view_hport[0] = base_h;

    // 2) Superficie da aplicacao
    if (surface_exists(application_surface))
    {
        if (surface_get_width(application_surface) != base_w || surface_get_height(application_surface) != base_h)
        {
            surface_resize(application_surface, base_w, base_h);
        }
    }

    // 3) GUI sempre 1280x720: menu e desafios usam ESTE tamanho em qualquer sala
    display_set_gui_size(base_w, base_h);

    // 4) Camera: tamanho do mundo = viewport / zoom
    var z = zoom_da_sala();
    cam_w = base_w / z;
    cam_h = base_h / z;
    camera_set_view_size(view_camera[0], cam_w, cam_h);

    // 5) Volume geral
    audio_master_gain(volume / 100);
}

diagnostico = function()
{
    var z = zoom_da_sala();
    return {
        gui_w: display_get_gui_width(),
        gui_h: display_get_gui_height(),
        sup_w: surface_get_width(application_surface),
        sup_h: surface_get_height(application_surface),
        port_w: view_wport[0],
        port_h: view_hport[0],
        cam_w: camera_get_view_width(view_camera[0]),
        cam_h: camera_get_view_height(view_camera[0]),
        esp_cam_w: base_w / z,
        esp_cam_h: base_h / z
    };
}

tela_ok = function()
{
    var d = diagnostico();
    return (d.gui_w == base_w && d.gui_h == base_h
         && d.sup_w == base_w && d.sup_h == base_h
         && d.port_w == base_w && d.port_h == base_h
         && abs(d.cam_w - d.esp_cam_w) < 0.5
         && abs(d.cam_h - d.esp_cam_h) < 0.5);
}

// Chamada de tempos em tempos: se algo saiu do lugar, corrige sozinho
corrigir_tela = function()
{
    if (!tela_ok())
    {
        aplicar_tela();
        status_tela = "CORRIGIDO AUTOMATICAMENTE";
        status_timer = 300;
    }
}

// Botao "CORRIGIR TELA AUTOMATICAMENTE" das configuracoes
corrigir_tudo = function()
{
    tela_cheia = false;
    janela_idx = 0;
    zoom_idx = 0;
    aplicar_janela();
    aplicar_tela();
    salvar_config();
    status_tela = "TELA CORRIGIDA";
    status_timer = 300;
}

// ---------- Aplica ja na criacao ----------
mostrar_debug = false;
aplicar_janela();
aplicar_tela();
