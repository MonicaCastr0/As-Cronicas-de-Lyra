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
cor_fundo       = make_color_rgb(8, 12, 18);
cor_painel      = make_color_rgb(14, 22, 30);
cor_linha       = make_color_rgb(35, 60, 75);
cor_normal      = make_color_rgb(24, 38, 48);
cor_hover       = make_color_rgb(36, 58, 72);
cor_borda       = make_color_rgb(0, 180, 220);
cor_ciano       = make_color_rgb(0, 200, 240);
cor_verde       = make_color_rgb(90, 200, 100);
cor_laranja     = make_color_rgb(255, 160, 40);
cor_vermelho    = make_color_rgb(230, 70, 70);
cor_amarelo     = make_color_rgb(240, 210, 80);
cor_cinza       = make_color_rgb(130, 150, 160);
cor_botao       = make_color_rgb(60, 140, 60);
cor_botao_hover = make_color_rgb(80, 175, 80);
cor_botao_off   = make_color_rgb(45, 55, 62);
cor_null        = make_color_rgb(200, 40, 140);
cor_null_escuro = make_color_rgb(70, 10, 55);

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
    var jw = 900;
    var jh = 560;
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

// Retangulos [x1, y1, x2, y2]
rect_paleta = function(L, i)
{
    var x0 = L.esq + 44 + i * 158;
    return [x0, L.topo + 298, x0 + 148, L.topo + 338];
}
rect_slot = function(L, i)
{
    var x0 = L.esq + 44 + i * 158;
    var y0 = usa_loop ? L.topo + 386 : L.topo + 362;
    return [x0, y0, x0 + 148, y0 + 56];
}
rect_menos    = function(L) { return [L.esq + 140, L.topo + 346, L.esq + 172, L.topo + 376]; }
rect_mais     = function(L) { return [L.esq + 212, L.topo + 346, L.esq + 244, L.topo + 376]; }
rect_limpar   = function(L) { return [L.dir - 390, L.baixo - 70, L.dir - 260, L.baixo - 24]; }
rect_executar = function(L) { return [L.dir - 250, L.baixo - 70, L.dir - 30,  L.baixo - 24]; }

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
        global.chefe_derrotado = true;
        sequencia = seq_antes;
        repeticoes = rep_antes;
        corrupcao = 0;
        instrucao = "";
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
