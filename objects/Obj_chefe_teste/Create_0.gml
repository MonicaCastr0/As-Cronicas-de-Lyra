// ==========================================================
// CRIAR  -  Desafio Final: NULLERROR (Repeticao / Loop)  v2
// Objeto: Obj_chefe_desafio
// Para abrir:  global.chefe_aberto = true;  Obj_player.pode_mover = false;
// ==========================================================

if (!variable_global_exists("chefe_aberto"))    global.chefe_aberto = false;
if (!variable_global_exists("chefe_derrotado")) global.chefe_derrotado = false;

estava_aberto = false;   // detecta o momento em que o desafio abre (reinicia tudo)

// ==========================================================
// SPRITES DA LYRA  -  TROQUE PELOS NOMES DOS SEUS SPRITES
// Exemplo:  spr_lyra_parada = spr_lyra_idle;
// Deixe -1 onde nao tiver sprite.
// o desafio usa o sprite atual do Obj_player.
// ==========================================================
spr_lyra_parada  = spr_player_combat;   // parada / respirando (animacao em loop)
spr_lyra_defesa  = spr_player_combatDef;   // opcional: animacao de defesa
spr_lyra_ataque  = spr_player_combatAtk;   // opcional: animacao de ataque
spr_lyra_acender = -1;   // opcional: animacao de acender a tocha
lyra_altura   = 130;     // altura da Lyra na tela (pixels)
lyra_espelhar = false;   // true se o sprite olha para a ESQUERDA

// ---------- Cores ----------
cor_fundo       = make_color_rgb(14, 8, 28);
cor_painel      = make_color_rgb(32, 18, 56);
cor_linha       = make_color_rgb(92, 58, 132);
cor_normal      = make_color_rgb(46, 28, 78);
cor_hover       = make_color_rgb(68, 44, 108);
cor_borda       = make_color_rgb(165, 100, 235);
cor_ciano       = make_color_rgb(0, 200, 240);
cor_verde       = make_color_rgb(90, 200, 100);
cor_laranja     = make_color_rgb(255, 160, 40);
cor_vermelho    = make_color_rgb(230, 70, 70);
cor_amarelo     = make_color_rgb(240, 210, 80);
cor_cinza       = make_color_rgb(130, 150, 160);
cor_botao       = make_color_rgb(60, 140, 60);
cor_botao_hover = make_color_rgb(80, 175, 80);
cor_botao_off   = make_color_rgb(58, 42, 84);
cor_null        = make_color_rgb(200, 40, 140);
cor_null_escuro = make_color_rgb(70, 10, 55);

// novas (roxo)
cor_janela_topo = make_color_rgb(52, 26, 92);
cor_janela_base = make_color_rgb(20, 10, 38);
cor_roxo_claro  = make_color_rgb(190, 140, 255);
// ==========================================================
// ESTADO
// etapa: 0 = introducao | 1 = treino na mao | 2 = treino com REPETIR
//        3 = observar o chefe | 4 = chefe (aplicar o REPETIR) | 5 = vitoria
// ==========================================================
etapa = 0;
anim = 0;
shake = 0;
msg = "";
msg_cor = cor_amarelo;
instrucao = "";

corrupcao = 100;            // "vida" do NullError
dano_golpe = 34;            // cada contra-ataque certo tira isso

sequencia = [];             // acoes escolhidas pelo jogador
repeticoes = 1;             // valor do REPETIR [n] VEZES
repeticoes_max = 6;

// configurado por entrar_etapa()
tam_seq = 3;                // espacos da sequencia
usa_loop = false;           // mostra o REPETIR?
ciclos_alvo = 1;            // quantas repeticoes sao necessarias
tochas_total = 3;
tochas_acesas = 0;
dur_exec = 45;              // frames por passo na execucao
acoes_atuais = ["ACENDER", "ESPERAR"];

// ---------- Acoes e eventos ----------
padrao_boss = ["ATAQUE", "ATAQUE", "PAUSA"];
padrao = padrao_boss;       // eventos de UM ciclo
// resposta certa para cada evento
contra = { TOCHA: "ACENDER", ATAQUE: "DEFESA", PAUSA: "ATAQUE" };
codigo_acao = {
    ACENDER: "acender_tocha();",
    ESPERAR: "esperar();",
    DEFESA:  "defender();",
    ATAQUE:  "atacar();",
    PAUSA:   "pausar();"
};

nome_acao = function(a)
{
    if (a == "ACENDER") return "ACENDER TOCHA";
    return a;
}

cor_acao = function(a)
{
    if (a == "ATAQUE")  return cor_vermelho;
    if (a == "DEFESA")  return cor_ciano;
    if (a == "ACENDER") return cor_laranja;
    return cor_amarelo;
}

// ---------- Dialogos ----------
em_dialogo = false;
dialogo = [];
dialogo_idx = 0;
dialogo_proximo = 0;

// ---------- Execucao animada ----------
exec_ativo = false;
exec_modo = "";             // "demo" | "run"
exec_ciclos = 0;
exec_ciclo = 0;
exec_passo = 0;
exec_timer = 0;
exec_dur = 40;
exec_seq = [];
exec_erros = 0;
exec_erro_txt = "";
exec_evento_atual = "";
exec_lyra_atual = "";
exec_resultado = "";        // "", "ok", "erro", "sem_alvo"
codigo_destaque = -1;

// ==========================================================
// LAYOUT (um lugar so, usado no Step e no Draw GUI)
// ==========================================================
get_layout = function(ox)
{
    var largura = display_get_gui_width();
    var altura  = display_get_gui_height();
    var jw = min(1120, largura - 40);
    var jh = min(640,  altura - 40);
    var cx = largura / 2 + ox;
    var cy = altura / 2;

    return {
        largura: largura,
        altura: altura,
        cx: cx,
        cy: cy,
        jw: jw,
        jh: jh,
        esq: cx - jw / 2,
        dir: cx + jw / 2,
        topo: cy - jh / 2,
        baixo: cy + jh / 2
    };
}

// Retangulos [x1, y1, x2, y2]  (coluna 1 = acoes, coluna 2 = sequencia)
rect_paleta = function(L, i)
{
    var y0 = L.topo + 292 + 44 + i * 58;
    return [L.esq + 46, y0, L.esq + 314, y0 + 50];
}
rect_slot = function(L, i)
{
    var y0 = L.topo + 292 + (usa_loop ? 96 : 44) + i * 56;
    return [L.esq + 384, y0, L.esq + 696, y0 + 48];
}
rect_menos    = function(L) { return [L.esq + 480, L.topo + 292 + 42, L.esq + 512, L.topo + 292 + 74]; }
rect_mais     = function(L) { return [L.esq + 566, L.topo + 292 + 42, L.esq + 598, L.topo + 292 + 74]; }
rect_limpar   = function(L) { return [L.dir - 410, L.baixo - 72, L.dir - 280, L.baixo - 26]; }
rect_executar = function(L) { return [L.dir - 270, L.baixo - 72, L.dir - 30,  L.baixo - 26]; }


mouse_em = function(r, mx, my)
{
    return point_in_rectangle(mx, my, r[0], r[1], r[2], r[3]);
}

// ==========================================================
// ETAPAS
// ==========================================================
entrar_etapa = function(e)
{
    var seq_antes = sequencia;      // a vitoria mostra o loop que o jogador montou
    var rep_antes = repeticoes;

    etapa = e;
    sequencia = [];
    msg = "";
    repeticoes = 1;
    corrupcao = 100;
    tochas_acesas = 0;
    exec_ativo = false;
    em_dialogo = false;

    if (e == 0 || e == 1)
    {
        // TREINO 1: repetir NA MAO (3 tochas, 3 comandos)
        acoes_atuais = ["ACENDER", "ESPERAR"];
        padrao = ["TOCHA", "TOCHA", "TOCHA"];
        tam_seq = 3;
        usa_loop = false;
        ciclos_alvo = 1;
        tochas_total = 3;
        dur_exec = 45;
        instrucao = "Acenda as 3 tochas: escolha ACENDER TOCHA para cada espaco e clique em EXECUTAR.";
    }
    else if (e == 2)
    {
        // TREINO 2: o REPETIR (5 tochas, 1 comando)
        acoes_atuais = ["ACENDER", "ESPERAR"];
        padrao = ["TOCHA"];
        tam_seq = 1;
        usa_loop = true;
        ciclos_alvo = 5;
        tochas_total = 5;
        dur_exec = 28;
        instrucao = "Agora sao 5 tochas, mas so 1 espaco. Escolha o comando e quantas vezes o REPETIR roda.";
    }
    else if (e == 3)
    {
        // CHEFE: observar
        padrao = padrao_boss;
        tam_seq = 3;
        usa_loop = false;
        ciclos_alvo = 3;
        instrucao = "Observe o padrao do NullError...  (ENTER pula)";
        iniciar_exec("demo", 3, []);
    }
    else if (e == 4)
    {
        // CHEFE: aplicar o REPETIR
        acoes_atuais = ["DEFESA", "ATAQUE", "ESPERAR"];
        padrao = padrao_boss;
        tam_seq = 3;
        usa_loop = true;
        ciclos_alvo = 3;
        dur_exec = 30;
        instrucao = "Responda a cada golpe do NullError e escolha quantas vezes o REPETIR roda.";
    }
    else if (e == 5)
    {
        global.chefe_fase1_concluida = true;
sequencia = seq_antes;
repeticoes = rep_antes;
corrupcao = 0;
instrucao = "";
iniciar_quebra();
    }
}

iniciar_chefe = function()
{
    entrar_etapa(1);
    etapa = 0;
    abrir_dialogo([
        ["NARRADOR", "NullError corrompe tudo repetindo a mesma sequencia. Para enfrenta-lo, Lyra precisa dominar a REPETICAO."],
        ["LYRA", "Primeiro vou treinar com algo simples: acender as tochas da arena."]
    ], 1);
}

// ==========================================================
// DIALOGOS
// ==========================================================
abrir_dialogo = function(lista, proxima)
{
    dialogo = lista;
    dialogo_idx = 0;
    dialogo_proximo = proxima;
    em_dialogo = true;
}

avancar_dialogo = function()
{
    dialogo_idx++;
    if (dialogo_idx < array_length(dialogo)) return;

    em_dialogo = false;
    entrar_etapa(dialogo_proximo);
}

// ==========================================================
// EXECUCAO ANIMADA (passo a passo)
// ==========================================================
iniciar_exec = function(modo, ciclos, seq)
{
    exec_ativo = true;
    exec_modo = modo;
    exec_ciclos = ciclos;
    exec_ciclo = 0;
    exec_passo = 0;
    exec_timer = -20;         // pequena pausa antes de comecar
    exec_seq = seq;
    exec_erros = 0;
    exec_erro_txt = "";
    exec_evento_atual = "";
    exec_lyra_atual = "";
    exec_resultado = "";
    exec_dur = (modo == "demo") ? 55 : dur_exec;
    msg = "";

    tochas_acesas = 0;
    corrupcao = 100;
}

avaliar_passo = function()
{
    var ev = padrao[exec_passo];
    var l = (exec_modo == "demo") ? "" : exec_seq[exec_passo];
    exec_resultado = "";
    exec_lyra_atual = l;

    // repeticoes alem do necessario: nao tem alvo
    if (exec_modo == "run" && exec_ciclo >= ciclos_alvo)
    {
        exec_evento_atual = "";
        exec_resultado = "sem_alvo";
        return;
    }

    exec_evento_atual = ev;
    if (exec_modo == "demo") return;

    var esperado = contra[$ ev];

    if (l == esperado)
    {
        exec_resultado = "ok";
        if (ev == "TOCHA") tochas_acesas++;
        if (l == "ATAQUE") corrupcao = max(0, corrupcao - dano_golpe);
    }
    else
    {
        exec_resultado = "erro";
        exec_erros++;
        if (exec_erro_txt == "")
        {
            exec_erro_txt = "No passo " + string(exec_passo + 1) + " era preciso " + nome_acao(esperado)
                          + " (voce escolheu " + nome_acao(l) + ").";
        }
        if (ev == "ATAQUE") shake = 12;
    }
}

atualizar_exec = function()
{
    if (!exec_ativo) return;

    exec_timer++;
    if (exec_timer == 1) avaliar_passo();

    if (exec_timer >= exec_dur)
    {
        exec_timer = 0;
        exec_passo++;
        if (exec_passo >= array_length(padrao))
        {
            exec_passo = 0;
            exec_ciclo++;
            if (exec_ciclo >= exec_ciclos) finalizar_exec();
        }
    }
}

finalizar_exec = function()
{
    exec_ativo = false;
    exec_evento_atual = "";
    exec_lyra_atual = "";
    exec_passo = 0;
    exec_timer = 0;

    // ---------- Demonstracao do chefe ----------
    if (exec_modo == "demo")
    {
        abrir_dialogo([
            ["NARRADOR", "NullError ataca sempre assim: ATAQUE, ATAQUE, PAUSA... e repete tudo 3 vezes."],
            ["LYRA", "Agora e comigo. Vou responder a cada golpe... e usar o REPETIR."]
        ], 4);
        return;
    }

    // ---------- Erro na sequencia ----------
    if (exec_erros > 0)
    {
        msg = "Quase! " + exec_erro_txt + " Ajuste e execute de novo.";
        msg_cor = cor_vermelho;
        return;
    }

    // ---------- Sequencia certa, numero de repeticoes errado ----------
    if (exec_ciclos < ciclos_alvo)
    {
        if (etapa == 4)
            msg = "NullError ainda esta de pe! Voce repetiu so " + string(exec_ciclos) + " vez(es) e ele ataca " + string(ciclos_alvo) + " vezes.";
        else
            msg = "Faltaram tochas! Voce repetiu so " + string(exec_ciclos) + " vez(es) e eram " + string(ciclos_alvo) + ".";
        msg_cor = cor_amarelo;
        return;
    }
    if (exec_ciclos > ciclos_alvo)
    {
        msg = "Voce repetiu a mais! So eram " + string(ciclos_alvo) + " repeticoes, o resto foi sem alvo.";
        msg_cor = cor_amarelo;
        return;
    }

    // ---------- Tudo certo ----------
    if (etapa == 1)
    {
        abrir_dialogo([
            ["NARRADOR", "Voce escreveu o MESMO comando 3 vezes. E se fossem 50 tochas?"],
            ["LYRA", "Deve existir um jeito de mandar repetir sem escrever tudo de novo..."],
            ["NARRADOR", "Existe: REPETIR [n] VEZES. O que fica dentro dele roda n vezes."]
        ], 2);
    }
    else if (etapa == 2)
    {
        abrir_dialogo([
            ["NARRADOR", "Uma linha so, cinco tochas acesas. Isso e uma REPETICAO, ou loop."],
            ["LYRA", "NullError tambem repete os golpes... vou usar isso contra ele."]
        ], 3);
    }
    else if (etapa == 4)
    {
        entrar_etapa(5);
    }
}

// ==========================================================
// ACOES DO JOGADOR
// ==========================================================
adicionar_acao = function(i)
{
    if (i >= array_length(acoes_atuais)) return;
    if (array_length(sequencia) < tam_seq) array_push(sequencia, acoes_atuais[i]);
    msg = "";
}

remover_acao = function(i)
{
    if (i >= 0 && i < array_length(sequencia)) array_delete(sequencia, i, 1);
    msg = "";
}

executar = function()
{
    if (array_length(sequencia) < tam_seq)
    {
        msg = "Preencha todos os espacos da sequencia antes de executar.";
        msg_cor = cor_amarelo;
        shake = 6;
        return;
    }
    iniciar_exec("run", usa_loop ? repeticoes : 1, sequencia);
}

fechar_chefe = function()
{
    global.chefe_aberto = false;
    if (instance_exists(Obj_player)) Obj_player.pode_mover = true;
}

// ==========================================================
// CODIGO MOSTRADO NA TELA
// ==========================================================
linha_slot = function(i, indent)
{
    var pre = indent ? "    " : "";
    if (i < array_length(sequencia))
    {
        var a = sequencia[i];
        return [[pre, c_white], [codigo_acao[$ a], cor_acao(a)]];
    }
    return [[pre, c_white], ["???", cor_cinza]];
}

montar_codigo = function()
{
    var linhas = [];
    codigo_destaque = -1;

    if (etapa == 3)
    {
        // codigo do NullError
        linhas = [
            [["// NullError", cor_cinza]],
            [["atacar();", cor_vermelho]],
            [["atacar();", cor_vermelho]],
            [["pausar();", cor_amarelo]]
        ];
        if (exec_ativo && exec_evento_atual != "") codigo_destaque = 1 + exec_passo;
    }
    else if (usa_loop || etapa >= 4)
    {
        linhas = [
            [["for ", cor_ciano], ["(var i = 0; i < ", c_white], [string(repeticoes), cor_amarelo], ["; i++)", c_white]],
            [["{", c_white]]
        ];
        for (var i = 0; i < tam_seq; i++) array_push(linhas, linha_slot(i, true));
        array_push(linhas, [["}", c_white]]);
        if (exec_ativo && exec_modo == "run" && exec_ciclo < exec_ciclos) codigo_destaque = 2 + exec_passo;
    }
    else
    {
        linhas = [ [["// um comando por tocha", cor_cinza]] ];
        for (var i = 0; i < tam_seq; i++) array_push(linhas, linha_slot(i, false));
        if (exec_ativo && exec_modo == "run") codigo_destaque = 1 + exec_passo;
    }

    return linhas;
}

// ==========================================================
// DESENHO (helpers)
// ==========================================================
painel = function(x1, y1, x2, y2, titulo, cor)
{
    draw_set_color(cor_painel);
    draw_roundrect_ext(x1, y1, x2, y2, 10, 10, false);
    draw_set_color(cor_linha);
    draw_roundrect_ext(x1, y1, x2, y2, 10, 10, true);

    if (titulo != "")
    {
        draw_set_color(cor);
        draw_text(x1 + 14, y1 + 8, titulo);
        draw_set_color(cor_linha);
        draw_line(x1 + 10, y1 + 28, x2 - 10, y1 + 28);
    }
}

// Varios pedacos coloridos na mesma linha: [[texto, cor], ...]
desenhar_partes = function(x, y, partes)
{
    var px = x;
    for (var i = 0; i < array_length(partes); i++)
    {
        draw_set_color(partes[i][1]);
        draw_text(px, y, partes[i][0]);
        px += string_width(partes[i][0]);
    }
}

// Bloco de codigo: linhas = [ [[texto, cor], ...], ... ]
desenhar_codigo = function(x, y, linhas, destaque, w)
{
    var lh = 18;
    for (var i = 0; i < array_length(linhas); i++)
    {
        if (i == destaque)
        {
            draw_set_alpha(0.25);
            draw_set_color(cor_amarelo);
            draw_rectangle(x - 6, y + i * lh - 1, x + w, y + (i + 1) * lh - 1, false);
            draw_set_alpha(1);
        }
        desenhar_partes(x, y + i * lh, linhas[i]);
    }
}

desenhar_botao = function(r, texto, ativo, mx, my, cor_base, cor_alt)
{
    if (!ativo)                   draw_set_color(cor_botao_off);
    else if (mouse_em(r, mx, my)) draw_set_color(cor_alt);
    else                          draw_set_color(cor_base);

    draw_roundrect_ext(r[0], r[1], r[2], r[3], 10, 10, false);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(ativo ? c_white : cor_cinza);
    draw_text((r[0] + r[2]) / 2, (r[1] + r[3]) / 2, texto);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Cartao de acao (ATAQUE / DEFESA / ...)
desenhar_card = function(cx, y1, w, h, texto, cor, destaque)
{
    var x1 = cx - w / 2;
    var x2 = cx + w / 2;

    draw_set_color(merge_color(cor_normal, cor, destaque ? 0.55 : 0.18));
    draw_roundrect_ext(x1, y1, x2, y1 + h, 8, 8, false);
    draw_set_color(cor);
    draw_roundrect_ext(x1, y1, x2, y1 + h, 8, 8, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(destaque ? c_white : cor_cinza);
    draw_text(cx, y1 + h / 2, texto);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ==========================================================
// LYRA  (usa os sprites configurados la em cima)
// px = centro, py = pes da Lyra
// ==========================================================
desenhar_lyra_simples = function(px, py)
{
    var bob = sin(anim * 0.08) * 3;
    draw_set_color(cor_borda);
    draw_rectangle(px - 18, py - 20, px - 4, py, false);
    draw_rectangle(px + 4,  py - 20, px + 18, py, false);
    draw_set_color(cor_ciano);
    draw_roundrect_ext(px - 22, py - 90 + bob, px + 22, py - 20, 8, 8, false);
    draw_set_color(make_color_rgb(235, 205, 175));
    draw_circle(px, py - 106 + bob, 16, false);
    draw_set_color(make_color_rgb(120, 60, 150));
    draw_rectangle(px - 16, py - 124 + bob, px + 16, py - 112 + bob, false);
}

desenhar_lyra = function(px, py, acao, prog)
{
    var spr = spr_lyra_parada;
    var especial = false;

    if (acao == "DEFESA" && spr_lyra_defesa != -1)          { spr = spr_lyra_defesa;  especial = true; }
    else if (acao == "ATAQUE" && spr_lyra_ataque != -1)     { spr = spr_lyra_ataque;  especial = true; }
    else if (acao == "ACENDER" && spr_lyra_acender != -1)   { spr = spr_lyra_acender; especial = true; }

    // sem sprite configurado: usa o sprite atual do player
    if (spr == -1 && instance_exists(Obj_player)) spr = Obj_player.sprite_index;

    if (spr == -1)
    {
        desenhar_lyra_simples(px, py);
        return;
    }

    var n = sprite_get_number(spr);
    var frame;
    if (especial) frame = clamp(floor(prog * n), 0, n - 1);   // toca uma vez durante a acao
    else          frame = floor(anim * 0.15) mod n;           // animacao em loop

    var esc = lyra_altura / sprite_get_height(spr);
    var dir = lyra_espelhar ? -1 : 1;

    // alinha o centro do sprite em px e os pes em py, qualquer que seja a origem
    var dx = px - (sprite_get_width(spr) / 2 - sprite_get_xoffset(spr)) * esc * dir;
    var dy = py - (sprite_get_height(spr) - sprite_get_yoffset(spr)) * esc;

    draw_sprite_ext(spr, frame, dx, dy, esc * dir, esc, 0, c_white, 1);
}

// ==========================================================
// QUEBRA DE PERSPECTIVA  -  final do desafio 4 (NullError)
// COLE NO FINAL DO CREATE DO Obj_chefe_desafio
// (o resto do Create continua como esta, com seus sprites e sons)
// ==========================================================

if (!variable_global_exists("chefe_fase1_concluida")) global.chefe_fase1_concluida = false;

// ---------- Configuracao ----------
spr_nullerror = -1;      // sprite da figura grande do NullError. -1 = desenho provisorio por codigo
sala_arena = asset_get_index("Room_arena_final");   // fica -1 ate a room existir

// Falas do dialogo final: [quem, texto]
// TEXTOS PROVISORIOS: troque pelos definitivos quando a equipe escrever.
falas_final = [
    ["NULLERROR", "A batalha vai continuar em outra perspectiva, Lyra."],
    ["NULLERROR", "[FALA 2 - escreva aqui]"],
    ["LYRA",      "[FALA 3 - escreva aqui]"]
];
fala_vel = 45;           // caracteres por segundo (mesmo valor do dialogo do amigo)

// ---------- Estado da animacao ----------
q_fase = 0;              // 0 = rachando | 1 = estilhacos caindo
q_timer = 0;
q_espera = 45;           // pausa antes de comecar a rachar (frames)
q_dur_rachar = 100;      // quanto tempo as rachaduras crescem (frames)
q_flash = 0;
q_cracks = [];
q_shards = [];

final_fase = 0;          // 0 = quebra | 1 = dialogo | 2 = escurecendo | 3 = saindo
fala_idx = 0;
fala_chars = 0;
fala_tempo = 0;
nn_aparece = 0;
fade_preto = 0;


// ==========================================================
// PREPARAR A QUEBRA (rachaduras e estilhacos aleatorios)
// ==========================================================
iniciar_quebra = function()
{
    q_fase = 0;
    q_timer = 0;
    q_flash = 0;
    final_fase = 0;
    fala_idx = 0;
    fala_chars = 0;
    fala_tempo = 0;
    nn_aparece = 0;
    fade_preto = 0;

    // ----- rachaduras (pontos relativos ao centro da janela) -----
    q_cracks = [];
    var n = 9;
    for (var i = 0; i < n; i++)
    {
        var ang = i * (360 / n) + random_range(-14, 14);
        var px = 0;
        var py = 0;
        var pts = [[0, 0]];
        var nseg = irandom_range(5, 7);

        for (var s = 0; s < nseg; s++)
        {
            ang += random_range(-24, 24);
            var comp = random_range(45, 80);
            px += lengthdir_x(comp, ang);
            py += lengthdir_y(comp, ang);
            array_push(pts, [px, py]);

            // ramificacao
            if (s >= 1 && s < nseg - 1 && irandom(2) == 0)
            {
                var bang = ang + choose(-1, 1) * random_range(30, 55);
                var bx = px;
                var by = py;
                var bpts = [[bx, by]];
                repeat (irandom_range(2, 3))
                {
                    bx += lengthdir_x(random_range(28, 50), bang);
                    by += lengthdir_y(random_range(28, 50), bang);
                    bang += random_range(-20, 20);
                    array_push(bpts, [bx, by]);
                }
                array_push(q_cracks, { pts: bpts, atraso: (s + 1) / nseg * 0.85 });
            }
        }
        array_push(q_cracks, { pts: pts, atraso: 0 });
    }

    // ----- estilhacos (a janela tem 900x560) -----
    q_shards = [];
    var LL = get_layout(0);
    var jw = LL.jw;
    var jh = LL.jh;
    var cols = 13;
    var rows = 7;

    var gvx = array_create(cols + 1);
    var gvy = array_create(cols + 1);
    for (var a = 0; a <= cols; a++)
    {
        gvx[a] = array_create(rows + 1, 0);
        gvy[a] = array_create(rows + 1, 0);
        for (var b = 0; b <= rows; b++)
        {
            var jx = (a > 0 && a < cols) ? random_range(-20, 20) : 0;
            var jy = (b > 0 && b < rows) ? random_range(-20, 20) : 0;
            gvx[a][b] = a * jw / cols + jx;
            gvy[a][b] = b * jh / rows + jy;
        }
    }

    for (var a = 0; a < cols; a++)
    {
        for (var b = 0; b < rows; b++)
        {
            var tris = [
                [[gvx[a][b],     gvy[a][b]],     [gvx[a + 1][b],     gvy[a + 1][b]],     [gvx[a][b + 1], gvy[a][b + 1]]],
                [[gvx[a + 1][b], gvy[a + 1][b]], [gvx[a + 1][b + 1], gvy[a + 1][b + 1]], [gvx[a][b + 1], gvy[a][b + 1]]]
            ];

            for (var t = 0; t < 2; t++)
            {
                var tr = tris[t];
                var ccx = (tr[0][0] + tr[1][0] + tr[2][0]) / 3;
                var ccy = (tr[0][1] + tr[1][1] + tr[2][1]) / 3;
                var ddx = ccx - jw / 2;
                var ddy = ccy - jh / 2;
                var dist = point_distance(0, 0, ddx, ddy);

                array_push(q_shards, {
                    cx: ccx,
                    cy: ccy,
                    p: [
                        [tr[0][0] - ccx, tr[0][1] - ccy],
                        [tr[1][0] - ccx, tr[1][1] - ccy],
                        [tr[2][0] - ccx, tr[2][1] - ccy]
                    ],
                    vx: ddx * 0.012 + random_range(-1.2, 1.2),
                    vy: ddy * 0.008 + random_range(-5, -1),
                    ang: 0,
                    vang: random_range(-4, 4),
                    atraso: floor(dist / 25) + irandom(6),
                    alfa: 1,
                    col: merge_color(cor_painel, (irandom(4) == 0) ? cor_null_escuro : cor_normal, random(0.6))
                });
            }
        }
    }
}

// ==========================================================
// ATUALIZAR (chamada pelo Step a cada frame, na etapa 5)
// ==========================================================
atualizar_final = function(clicou)
{
    q_timer++;
    if (q_flash > 0) q_flash = max(0, q_flash - 0.045);

    // ---------- 0: rachando ----------
    if (q_fase == 0)
    {
        var p = clamp((q_timer - q_espera) / q_dur_rachar, 0, 1);
        if (q_timer > q_espera) shake = floor(1 + p * 8);   // o tremor cresce

        if (q_timer >= q_espera + q_dur_rachar + 12)
        {
            q_fase = 1;
            q_timer = 0;
            q_flash = 1;
            shake = 16;
        }
        return;
    }

    // ---------- 1: estilhacos caindo ----------
    for (var i = 0; i < array_length(q_shards); i++)
    {
        var sh = q_shards[i];
        if (q_timer < sh.atraso) continue;

        sh.cx += sh.vx;
        sh.cy += sh.vy;
        sh.vy += 0.55;
        sh.ang += sh.vang;
        sh.alfa = max(0, sh.alfa - 0.007);
    }

    // o dialogo comeca enquanto os ultimos estilhacos ainda caem
    if (final_fase == 0 && q_timer >= 100) final_fase = 1;

    // ---------- dialogo (typewriter igual ao do amigo) ----------
    if (final_fase == 1)
    {
        nn_aparece = min(1, nn_aparece + 0.025);

        var texto = falas_final[fala_idx][1];
        var total = string_length(texto);

        if (fala_chars < total)
        {
            fala_tempo += (delta_time / 1000000) * fala_vel;
            fala_chars = min(floor(fala_tempo), total);
        }

        var avancar = keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter)
                   || keyboard_check_pressed(vk_space) || clicou;

        if (avancar && nn_aparece >= 0.9)
        {
            if (fala_chars < total)
            {
                // ainda digitando: completa a frase
                fala_chars = total;
                fala_tempo = total;
            }
            else if (fala_idx < array_length(falas_final) - 1)
            {
                fala_idx++;
                fala_chars = 0;
                fala_tempo = 0;
            }
            else
            {
                final_fase = 2;
            }
        }
    }
    // ---------- escurece e teletransporta ----------
    else if (final_fase == 2)
    {
        fade_preto = min(1, fade_preto + 0.02);
        if (fade_preto >= 1)
        {
            final_fase = 3;
            teletransportar();
        }
    }
}

teletransportar = function()
{
    global.chefe_aberto = false;

    if (sala_arena != -1)
    {
        room_goto(sala_arena);
    }
    else
    {
        // a room da arena ainda nao existe: volta ao jogo sem travar
        show_debug_message("Crie a room com o nome exato: Room_arena_final");
        fechar_chefe();
    }
}

// ==========================================================
// DESENHO
// ==========================================================

// Rachaduras por cima da janela (antes de quebrar)
desenhar_rachaduras = function(L)
{
    var prog = clamp((q_timer - q_espera) / q_dur_rachar, 0, 1);
    if (prog <= 0) return;

    for (var i = 0; i < array_length(q_cracks); i++)
    {
        var cr = q_cracks[i];
        var pts = cr.pts;
        var total = array_length(pts) - 1;
        var local = clamp((prog - cr.atraso) / max(0.01, 1 - cr.atraso), 0, 1);
        var ate = local * total;

        for (var s = 0; s < total; s++)
        {
            if (s >= ate) break;
            var f = min(1, ate - s);

            var x1 = L.cx + pts[s][0];
            var y1 = L.cy + pts[s][1];
            var x2 = x1 + (pts[s + 1][0] - pts[s][0]) * f;
            var y2 = y1 + (pts[s + 1][1] - pts[s][1]) * f;

            draw_set_alpha(0.45);
            draw_set_color(cor_null);
            draw_line_width(x1, y1, x2, y2, 5);
            draw_set_alpha(1);
            draw_set_color(c_white);
            draw_line_width(x1, y1, x2, y2, 2);
        }
    }

    // piscadas de glitch
    if (irandom(7) == 0)
    {
        draw_set_alpha(0.25);
        draw_set_color(cor_null);
        var gl = irandom(L.jh - 24);
        draw_rectangle(L.esq, L.topo + gl, L.dir, L.topo + gl + irandom_range(4, 18), false);
    }
    draw_set_alpha(1);
}

// Pedacos da janela caindo
desenhar_estilhacos = function(L)
{
    for (var i = 0; i < array_length(q_shards); i++)
    {
        var sh = q_shards[i];
        if (sh.alfa <= 0) continue;

        var co = dcos(sh.ang);
        var si = dsin(sh.ang);
        var xs = [0, 0, 0];
        var ys = [0, 0, 0];

        for (var k = 0; k < 3; k++)
        {
            var qx = sh.p[k][0];
            var qy = sh.p[k][1];
            xs[k] = L.esq + sh.cx + qx * co - qy * si;
            ys[k] = L.topo + sh.cy + qx * si + qy * co;
        }

        draw_set_alpha(sh.alfa);
        draw_triangle_color(xs[0], ys[0], xs[1], ys[1], xs[2], ys[2],
            sh.col, merge_color(sh.col, cor_borda, 0.25), sh.col, false);
        draw_set_color(cor_borda);
        draw_triangle(xs[0], ys[0], xs[1], ys[1], xs[2], ys[2], true);
    }
    draw_set_alpha(1);
}

// NullError desenhado por codigo (provisorio), px = centro, py = pes, esc = escala
desenhar_nullerror = function(px, py, esc, alfa)
{
    draw_set_alpha(alfa);
    draw_set_color(cor_null_escuro);
    draw_rectangle(px - 48 * esc, py - 112 * esc, px + 48 * esc, py - 8 * esc, false);

    for (var s = 0; s < 4; s++)
    {
        var sy = py - 112 * esc + s * 26 * esc;
        var so = sin(anim * 0.2 + s * 1.7) * 7 * esc;
        draw_set_color((s mod 2 == 0) ? cor_null : cor_null_escuro);
        draw_rectangle(px - 48 * esc + so, sy, px + 48 * esc + so, sy + 12 * esc, false);
    }

    draw_set_color(c_white);
    draw_rectangle(px - 30 * esc, py - 92 * esc, px - 12 * esc, py - 80 * esc, false);
    draw_rectangle(px + 12 * esc, py - 92 * esc, px + 30 * esc, py - 80 * esc, false);
    draw_set_color(cor_vermelho);
    draw_rectangle(px - 22 * esc, py - 52 * esc, px + 22 * esc, py - 44 * esc, false);
    draw_set_alpha(1);
}

// Usa o sprite do NullError se existir; senao o desenho provisorio
desenhar_nullerror_grande = function(px, py, altura_alvo, alfa)
{
    if (spr_nullerror != -1 && sprite_exists(spr_nullerror))
    {
        var esc = altura_alvo / sprite_get_height(spr_nullerror);
        var dx = px - (sprite_get_width(spr_nullerror) / 2 - sprite_get_xoffset(spr_nullerror)) * esc;
        var dy = py - (sprite_get_height(spr_nullerror) - sprite_get_yoffset(spr_nullerror)) * esc;
        var fr = floor(anim * 0.12) mod sprite_get_number(spr_nullerror);
        draw_sprite_ext(spr_nullerror, fr, dx, dy, esc, esc, 0, c_white, alfa);
    }
    else
    {
        desenhar_nullerror(px, py, altura_alvo / 104, alfa);    // 104 = altura do desenho base
    }
}

// Dialogo final: mesmo estilo do dialogo do amigo, em tamanho maior
desenhar_dialogo_final = function(gw, gh)
{
    var fala = falas_final[fala_idx];
    var quem = fala[0];
    var texto = fala[1];
    var suave = 1 - power(1 - nn_aparece, 3);

    // NullError enorme, subindo por tras da caixa
    var fx = gw * 0.72;
    var fy = gh - 90 + (1 - suave) * 300 + sin(anim * 0.05) * 5;
    desenhar_nullerror_grande(fx, fy, gh * 0.74, suave);

    // caixa
    var m = 40;
    var x1 = m;
    var y1 = gh - 230;
    var x2 = gw - m;
    var y2 = gh - 30;
    var alfa_caixa = min(1, nn_aparece * 3);

    draw_set_alpha(0.94 * alfa_caixa);
    draw_set_color(make_color_rgb(20, 29, 34));
    draw_rectangle(x1, y1, x2, y2, false);

    draw_set_alpha(alfa_caixa);
    draw_set_color(make_color_rgb(190, 157, 91));
    draw_rectangle(x1, y1, x2, y2, true);
    draw_rectangle(x1 + 3, y1 + 3, x2 - 3, y2 - 3, true);

    // nome
    var cor_nome = make_color_rgb(225, 190, 112);
    if (quem == "NULLERROR") cor_nome = cor_null;
    if (quem == "LYRA")      cor_nome = cor_ciano;
    draw_set_color(cor_nome);
    draw_text_transformed(x1 + 30, y1 + 16, quem, 1.5, 1.5, 0);

    // texto digitando
    draw_set_color(c_white);
    draw_text_ext_transformed(x1 + 30, y1 + 62, string_copy(texto, 1, fala_chars),
        24, (x2 - x1 - 60) / 1.3, 1.3, 1.3, 0);

    // indicador de avanco
    if (fala_chars >= string_length(texto) && nn_aparece >= 0.9)
    {
        draw_set_halign(fa_right);
        draw_set_color(make_color_rgb(225, 190, 112));
        draw_set_alpha(0.5 + 0.5 * abs(sin(anim * 0.08)));
        draw_text(x2 - 24, y2 - 34, "[ E ]");
        draw_set_halign(fa_left);
    }
    draw_set_alpha(1);
}

// Chamada pelo Draw GUI na etapa 5 (rachaduras, estilhacos, dialogo e fade)
desenhar_final = function(L)
{
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();

    if (q_fase == 0)
    {
        desenhar_rachaduras(L);
    }
    else
    {
        // o mundo aparece escurecido, a janela ja nao existe
        draw_set_alpha(0.7);
        draw_set_color(c_black);
        draw_rectangle(0, 0, gw, gh, false);
        draw_set_alpha(1);

        desenhar_estilhacos(L);

        if (final_fase >= 1) desenhar_dialogo_final(gw, gh);

        // clarao da quebra
        if (q_flash > 0)
        {
            draw_set_alpha(q_flash);
            draw_set_color(c_white);
            draw_rectangle(0, 0, gw, gh, false);
        }

        // fade para preto antes de trocar de room
        if (fade_preto > 0)
        {
            draw_set_alpha(fade_preto);
            draw_set_color(c_black);
            draw_rectangle(0, 0, gw, gh, false);
        }
    }

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
