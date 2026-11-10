// ==========================================================
// CRIAR - Desafio do Jardim 
// ==========================================================

// estado: 0 = montando | 1 = errou | 2 = acertou a fase | 3 = tudo concluido | 4 = executando
fase_atual = 0;
estado = 0;
sequencia = [];
msg = "";
erros_fase = 0;
erros_total = 0;
mostrar_dica = false;
shake = 0;
anim = 0;

passo_exec = 0;
passo_erro = -1;
exec_timer = 0;
exec_delay = 40;
entrada_bloqueada = 0;

plots = [];
plot_atual = 0;
robo_pos = 0;

// ---------- Estado do personagem e do jardim ----------
mao_semente = false;   // o personagem so segura UMA semente por vez
luz_ligada  = false;   // luz do jardim (acende todos os canteiros)

// ---------- Variaveis globais ----------
if (!variable_global_exists("desafio_plantar_aberto"))    global.desafio_plantar_aberto = false;
if (!variable_global_exists("desafio_plantar_concluido")) global.desafio_plantar_concluido = false;
if (!variable_global_exists("jardim_florido"))            global.jardim_florido = false;

// ---------- Cores ----------
cor_fundo       = make_color_rgb(8, 12, 18);
cor_painel      = make_color_rgb(14, 22, 30);
cor_linha       = make_color_rgb(35, 60, 75);
cor_normal      = make_color_rgb(24, 38, 48);
cor_hover       = make_color_rgb(36, 58, 72);
cor_borda       = make_color_rgb(0, 180, 220);
cor_ciano       = make_color_rgb(0, 200, 240);
cor_verde       = make_color_rgb(90, 200, 100);
cor_lima        = make_color_rgb(160, 225, 110);
cor_laranja     = make_color_rgb(255, 160, 40);
cor_vermelho    = make_color_rgb(230, 70, 70);
cor_amarelo     = make_color_rgb(240, 210, 80);
cor_roxo        = make_color_rgb(190, 130, 255);
cor_cinza       = make_color_rgb(130, 150, 160);
cor_botao       = make_color_rgb(60, 140, 60);
cor_botao_hover = make_color_rgb(80, 175, 80);
cor_botao_off   = make_color_rgb(45, 55, 62);

// ---------- Ferramentas (7) ----------
// "tipo" e FIXO e define a regra do jogo:
// 0 pegar semente | 1 cavar | 2 plantar | 3 adubar | 4 regar | 5 luz | 6 podar (armadilha)
// A ORDEM da lista so muda o que aparece na tela.
passos = [
    { tipo: 1, nome: "CAVAR A TERRA",  codigo: "preparar_solo();", cor: cor_amarelo  },
    { tipo: 6, nome: "PODAR",          codigo: "podar();",         cor: cor_vermelho },
    { tipo: 2, nome: "PLANTAR",        codigo: "plantar();",       cor: cor_lima     },
    { tipo: 5, nome: "ACENDER LUZ",    codigo: "ativar_luz();",    cor: cor_roxo     },
    { tipo: 3, nome: "ADUBAR",         codigo: "colocar_adubo();", cor: cor_laranja  },
    { tipo: 0, nome: "PEGAR SEMENTE",  codigo: "pegar_semente();", cor: cor_verde    },
    { tipo: 4, nome: "REGAR",          codigo: "regar();",         cor: cor_ciano    }
];

novo_canteiro = function(_cav, _sem, _adu, _reg)
{
    return { cavada: _cav, semeada: _sem, adubada: _adu, regada: _reg };
}

// ==========================================================
// AS 3 FASES
// slots = maximo de passos (voce precisa descobrir quantos usar)
// ==========================================================
fases = [

    // ---------------- FASE 1 ----------------
    {
        nome: "PLANTAR",
        titulo: "FASE 1 - PLANTAR UMA FLOR",
        contexto: "O canteiro esta vazio e a terra esta dura. Descubra quais passos usar e em que ordem. Cuidado: nem toda ferramenta ajuda.",
        objetivo_txt: "1 flor crescida",
        slots: 6,
        precisa_luz: false,
        mao_ini: false,
        ini: [ novo_canteiro(false, false, false, false) ],
        dica: "Para plantar, voce precisa de uma semente na mao e a terra cavada. Para adubar, a terra tambem precisa estar cavada. Para regar, precisa ter semente e adubo. Podar nao ajuda uma planta pequena.",
        explicacao: "Um algoritmo e uma lista de passos em ordem. Cada passo tem uma regra antes: so da para plantar se voce tem a semente e a terra ja foi cavada."
    },

    // ---------------- FASE 2 ----------------
    {
        nome: "ESTADO",
        titulo: "FASE 2 - TERMINAR O TRABALHO",
        contexto: "Dois canteiros estao em etapas diferentes. Voce comeca com a mao vazia. Olhe o ESTADO de cada canteiro e faca so o que falta, sem repetir nada.",
        objetivo_txt: "2 flores, sem repetir passos",
        slots: 7,
        precisa_luz: false,
        mao_ini: false,
        ini: [ novo_canteiro(true, true, false, false), novo_canteiro(true, false, true, false) ],
        dica: "Canteiro 1: ja tem semente, so falta adubo. Canteiro 2: ja tem adubo, mas falta a semente (e sua mao esta vazia). Repetir um passo que ja foi feito e erro.",
        explicacao: "Um bom algoritmo comeca olhando como as coisas estao agora e nao repete trabalho. Cada canteiro estava diferente, entao cada um precisou de passos diferentes."
    },

    // ---------------- FASE 3 ----------------
    {
        nome: "JARDIM",
        titulo: "FASE 3 - O JARDIM INTEIRO",
        contexto: "Ultima fase! Dois canteiros diferentes e uma luz que acende o jardim inteiro de uma vez. Voce so carrega UMA semente por vez.",
        objetivo_txt: "2 flores com luz acesa",
        slots: 10,
        precisa_luz: true,
        mao_ini: false,
        ini: [ novo_canteiro(true, false, true, false), novo_canteiro(false, false, false, false) ],
        dica: "Cuide de um canteiro de cada vez. Cada plantio precisa de uma semente na mao. A luz so acende quando TODOS os canteiros estiverem regados, entao ela e o ULTIMO passo.",
        explicacao: "Voce repetiu quase os mesmos passos duas vezes (pegar, plantar, regar...). E se fossem 100 canteiros?"
    }
];

// ==========================================================
// LAYOUT
// ==========================================================
get_layout = function(ox)
{
    var largura = display_get_gui_width();
    var altura  = display_get_gui_height();
    var jw = 1000;
    var jh = 640;
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

rect_ferr   = function(L, i) { return [L.esq + 510, L.topo + 100 + i * 25, L.dir - 30, L.topo + 121 + i * 25]; }
rect_slot   = function(L, i) { var _x = L.esq + 40 + i * 42; var _y = L.topo + 430; return [_x, _y, _x + 38, _y + 38]; }
rect_botao  = function(L)    { return [L.dir - 230, L.baixo - 68, L.dir - 30, L.baixo - 22]; }
rect_limpar = function(L)    { return [L.dir - 340, L.baixo - 68, L.dir - 242, L.baixo - 22]; }

mouse_em = function(r, mx, my)
{
    return point_in_rectangle(mx, my, r[0], r[1], r[2], r[3]);
}

// ==========================================================
// LOGICA DOS CANTEIROS
// ==========================================================
resetar_canteiros = function()
{
    var f = fases[fase_atual];
    plots = [];
    for (var i = 0; i < array_length(f.ini); i++)
    {
        array_push(plots, {
            cavada:  f.ini[i].cavada,
            semeada: f.ini[i].semeada,
            adubada: f.ini[i].adubada,
            regada:  f.ini[i].regada
        });
    }
    mao_semente = f.mao_ini;
    luz_ligada = false;
    plot_atual = 0;
    passo_exec = 0;
    passo_erro = -1;
    exec_timer = 0;
}

flores_prontas = function()
{
    var f = fases[fase_atual];
    if (f.precisa_luz && !luz_ligada) return 0;
    var n = 0;
    for (var i = 0; i < array_length(plots); i++)
    {
        if (plots[i].regada) n++;
    }
    return n;
}

// Aplica UM passo. Retorna "" se deu certo, ou o texto do erro.
// _p = posicao do passo na lista "passos". A regra usa o "tipo" da ferramenta.
aplicar_passo = function(_p)
{
    var f = fases[fase_atual];
    var c = plots[plot_atual];
    var tipo = passos[_p].tipo;

    if (luz_ligada) return "O jardim ja esta com a luz acesa e cheio de flores. Nao tem mais nada para fazer.";

    // canteiro ja regado: so a luz ainda faz sentido
    if (c.regada && tipo != 5) return "Este canteiro ja esta pronto. Mexer nele de novo so estraga.";

    switch (tipo)
    {
        case 0: // PEGAR SEMENTE
            if (mao_semente) return "Sua mao ja tem uma semente. Voce so carrega uma por vez.";
            mao_semente = true;
        break;

        case 1: // CAVAR A TERRA
            if (c.cavada) return "A terra deste canteiro ja foi cavada. Cavar de novo e perder tempo.";
            c.cavada = true;
        break;

        case 2: // PLANTAR
            if (!mao_semente) return "Voce tentou plantar de mao vazia. Pegue uma semente primeiro.";
            if (!c.cavada)    return "A terra esta dura. Sem cavar, a semente fica em cima e o vento leva embora.";
            if (c.semeada)    return "Este canteiro ja tem uma semente. Nao precisa de outra.";
            c.semeada = true;
            mao_semente = false;
        break;

        case 3: // ADUBAR
            if (!c.cavada)  return "O adubo nao entra na terra dura. Cave primeiro.";
            if (c.adubada)  return "Este canteiro ja tem adubo. Adubo demais queima as raizes.";
            c.adubada = true;
        break;

        case 4: // REGAR
            if (!c.semeada) return "Regar sem semente so faz lama.";
            if (!c.adubada) return "A semente nasce, mas sem adubo a planta murcha.";
            c.regada = true;
        break;

        case 5: // ACENDER LUZ
            if (!f.precisa_luz) return "A luz desta fase esta sem energia. Nada acontece.";
            for (var i = 0; i < array_length(plots); i++)
            {
                if (!plots[i].regada) return "A luz so acende quando TODOS os canteiros estiverem regados. Ainda falta um.";
            }
            luz_ligada = true;
        break;

        case 6: // PODAR (armadilha)
            return "Podar uma planta pequena so a destroi. Esse passo nao ajuda aqui.";
        break;
    }

    return "";
}

processar_execucao = function()
{
    var fase = fases[fase_atual];
    var _p = sequencia[passo_exec];
    var erro = aplicar_passo(_p);
    var nome_passo = "Passo " + string(passo_exec + 1) + " (" + passos[_p].codigo + ")";

    if (erro != "")
    {
        estado = 1;
        passo_erro = passo_exec;
        erros_fase++;
        erros_total++;
        shake = 14;
        if (erros_fase >= 3) mostrar_dica = true;
        msg = nome_passo + ": " + erro + "\nO jardineiro parou. Mude a sequencia e tente de novo.";
        return;
    }

    // canteiro regado e ainda tem outro: o personagem anda sozinho ate ele
    if (plots[plot_atual].regada && plot_atual < array_length(plots) - 1) plot_atual++;

    passo_exec++;

    // todas as flores prontas?
    if (flores_prontas() >= array_length(plots))
    {
        if (passo_exec >= array_length(sequencia))
        {
            estado = 2;
            msg = "Sua sequencia funcionou! " + fase.explicacao;
        }
        return;
    }

    if (passo_exec >= array_length(sequencia))
    {
        estado = 1;
        passo_erro = -1;
        erros_fase++;
        erros_total++;
        shake = 14;
        if (erros_fase >= 3) mostrar_dica = true;
        msg = "Nenhum passo deu erro, mas ainda falta coisa para fazer. Sua sequencia esta incompleta.";
    }
}

// ==========================================================
// EDICAO DA SEQUENCIA
// ==========================================================
voltar_a_montar = function()
{
    estado = 0;
    msg = "";
    resetar_canteiros();
}

adicionar_passo = function(_p)
{
    if (estado != 0 && estado != 1) return;
    var fase = fases[fase_atual];

    voltar_a_montar();

    if (array_length(sequencia) >= fase.slots)
    {
        msg = "A sequencia esta cheia (maximo " + string(fase.slots) + " passos). Clique em um passo para tirar.";
        shake = 6;
        return;
    }
    array_push(sequencia, _p);
}

remover_passo = function(_i)
{
    if (estado != 0 && estado != 1) return;
    array_delete(sequencia, _i, 1);
    voltar_a_montar();
}

limpar = function()
{
    if (estado != 0 && estado != 1) return;
    sequencia = [];
    voltar_a_montar();
}

// ==========================================================
// BOTOES / ABRIR / FECHAR
// ==========================================================
executar = function()
{
    if (array_length(sequencia) < 1)
    {
        estado = 0;
        msg = "Monte a sequencia antes de executar. Descubra quantos passos sao necessarios.";
        shake = 6;
        return;
    }

    resetar_canteiros();
    msg = "";
    estado = 4;
}

acao_botao = function()
{
    if (estado == 0 || estado == 1)
    {
        executar();
    }
    else if (estado == 2)
    {
        if (fase_atual < array_length(fases) - 1)
        {
            fase_atual++;
            erros_fase = 0;
            mostrar_dica = false;
            sequencia = [];
            msg = "";
            estado = 0;
            resetar_canteiros();
        }
        else
        {
            estado = 3;
            global.desafio_plantar_concluido = true;
            global.jardim_florido = true;
        }
    }
    else if (estado == 3)
    {
        fechar_desafio();
    }
}

abrir = function()
{
    if (global.desafio_plantar_concluido) estado = 3;
    global.desafio_plantar_aberto = true;
    Obj_player.pode_mover = false;
    entrada_bloqueada = 10;
}

fechar_desafio = function()
{
    global.desafio_plantar_aberto = false;
    Obj_player.pode_mover = true;

    if (estado != 3)
    {
        estado = 0;
        msg = "";
        resetar_canteiros();
    }
}

// ==========================================================
// DESENHO (funcoes de ajuda)
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

// _t = TIPO da ferramenta (0 a 6), nao a posicao na lista
desenhar_icone = function(_t, _cx, _cy, _s)
{
    switch (_t)
    {
        case 0: // pegar semente
            draw_set_color(make_color_rgb(170, 115, 55));
            draw_ellipse(_cx - _s * 0.3, _cy - _s * 0.3, _cx + _s * 0.3, _cy + _s * 0.4, false);
            draw_set_color(cor_verde);
            draw_line_width(_cx - _s * 0.5, _cy + _s * 0.55, _cx + _s * 0.5, _cy + _s * 0.55, 2);
        break;

        case 1: // cavar (pa)
            draw_set_color(cor_cinza);
            draw_line_width(_cx, _cy - _s * 0.55, _cx, _cy + _s * 0.1, 3);
            draw_set_color(cor_amarelo);
            draw_triangle(_cx - _s * 0.3, _cy + _s * 0.1, _cx + _s * 0.3, _cy + _s * 0.1, _cx, _cy + _s * 0.6, false);
        break;

        case 2: // plantar (broto)
            draw_set_color(make_color_rgb(110, 75, 40));
            draw_rectangle(_cx - _s * 0.5, _cy + _s * 0.3, _cx + _s * 0.5, _cy + _s * 0.55, false);
            draw_set_color(cor_lima);
            draw_line_width(_cx, _cy + _s * 0.3, _cx, _cy - _s * 0.3, 2);
            draw_ellipse(_cx, _cy - _s * 0.5, _cx + _s * 0.4, _cy - _s * 0.15, false);
            draw_ellipse(_cx - _s * 0.4, _cy - _s * 0.3, _cx, _cy, false);
        break;

        case 3: // adubo
            draw_set_color(cor_laranja);
            draw_rectangle(_cx - _s * 0.4, _cy - _s * 0.3, _cx + _s * 0.4, _cy + _s * 0.5, false);
            draw_set_color(cor_fundo);
            draw_line_width(_cx - _s * 0.2, _cy + _s * 0.1, _cx + _s * 0.2, _cy + _s * 0.1, 2);
            draw_line_width(_cx, _cy - _s * 0.1, _cx, _cy + _s * 0.3, 2);
        break;

        case 4: // regador
            draw_set_color(cor_ciano);
            draw_rectangle(_cx - _s * 0.45, _cy - _s * 0.2, _cx + _s * 0.25, _cy + _s * 0.5, false);
            draw_line_width(_cx + _s * 0.25, _cy + _s * 0.05, _cx + _s * 0.6, _cy - _s * 0.35, 3);
            draw_line_width(_cx - _s * 0.45, _cy - _s * 0.1, _cx - _s * 0.2, _cy - _s * 0.5, 2);
            draw_set_color(c_white);
            draw_circle(_cx + _s * 0.7, _cy - _s * 0.1, 1.5, false);
            draw_circle(_cx + _s * 0.62, _cy + _s * 0.15, 1.5, false);
        break;

        case 5: // luz
            draw_set_color(cor_roxo);
            draw_circle(_cx, _cy - _s * 0.05, _s * 0.28, false);
            draw_rectangle(_cx - _s * 0.12, _cy + _s * 0.25, _cx + _s * 0.12, _cy + _s * 0.5, false);
            for (var a = 0; a < 360; a += 60)
            {
                draw_line_width(_cx + lengthdir_x(_s * 0.4, a), _cy - _s * 0.05 + lengthdir_y(_s * 0.4, a),
                                _cx + lengthdir_x(_s * 0.6, a), _cy - _s * 0.05 + lengthdir_y(_s * 0.6, a), 2);
            }
        break;

        case 6: // podar (X vermelho)
            draw_set_color(cor_vermelho);
            draw_line_width(_cx - _s * 0.45, _cy - _s * 0.45, _cx + _s * 0.45, _cy + _s * 0.45, 3);
            draw_line_width(_cx + _s * 0.45, _cy - _s * 0.45, _cx - _s * 0.45, _cy + _s * 0.45, 3);
        break;
    }
}

desenhar_flor = function(_x, _y, _s)
{
    draw_set_color(cor_verde);
    draw_line_width(_x, _y, _x, _y - _s, 3);
    draw_ellipse(_x - _s * 0.35, _y - _s * 0.55, _x, _y - _s * 0.3, false);

    var py = _y - _s - 4;
    draw_set_color(make_color_rgb(235, 90, 150));
    for (var a = 0; a < 360; a += 72)
    {
        draw_circle(_x + lengthdir_x(_s * 0.28, a), py + lengthdir_y(_s * 0.28, a), _s * 0.22, false);
    }
    draw_set_color(cor_amarelo);
    draw_circle(_x, py, _s * 0.18, false);
}

desenhar_canteiro = function(_x, _y, _w, _h, _c, _ativo)
{
    var f = fases[fase_atual];
    var cor_terra = _c.cavada ? make_color_rgb(70, 45, 28) : make_color_rgb(120, 100, 78);
    if (_c.regada) cor_terra = make_color_rgb(45, 30, 22);

    draw_set_color(cor_terra);
    draw_roundrect_ext(_x, _y, _x + _w, _y + _h, 8, 8, false);

    if (!_c.cavada)
    {
        draw_set_color(make_color_rgb(85, 68, 50));
        draw_line(_x + 12, _y + 14, _x + 34, _y + 30);
        draw_line(_x + 34, _y + 30, _x + 30, _y + 52);
        draw_line(_x + _w - 14, _y + 18, _x + _w - 36, _y + 40);
        draw_line(_x + _w * 0.5, _y + _h - 10, _x + _w * 0.62, _y + _h - 28);
    }
    else
    {
        draw_set_color(make_color_rgb(35, 22, 14));
        draw_roundrect_ext(_x + 14, _y + _h * 0.45, _x + _w - 14, _y + _h * 0.78, 6, 6, false);
    }

    var cx = _x + _w / 2;

    if (_c.adubada)
    {
        draw_set_color(cor_laranja);
        draw_circle(_x + 18, _y + _h * 0.30, 2, false);
        draw_circle(_x + _w - 20, _y + _h * 0.34, 2, false);
        draw_circle(_x + 30, _y + _h * 0.86, 2, false);
        draw_circle(_x + _w - 28, _y + _h * 0.88, 2, false);
        draw_circle(cx, _y + _h * 0.26, 2, false);
    }

    if (_c.semeada && !_c.regada)
    {
        draw_set_color(make_color_rgb(200, 150, 75));
        draw_ellipse(cx - 5, _y + _h * 0.52, cx + 5, _y + _h * 0.70, false);
    }

    if (_c.regada)
    {
        draw_set_alpha(0.22);
        draw_set_color(cor_ciano);
        draw_roundrect_ext(_x, _y, _x + _w, _y + _h, 8, 8, false);
        draw_set_alpha(1);

        // sem luz: so um broto pequeno | com luz: flor completa
        var tam = (f.precisa_luz && !luz_ligada) ? 18 : 40;
        desenhar_flor(cx, _y + _h * 0.72, tam);

        if (luz_ligada)
        {
            draw_set_alpha(0.18);
            draw_set_color(cor_roxo);
            draw_roundrect_ext(_x, _y, _x + _w, _y + _h, 8, 8, false);
            draw_set_alpha(1);
        }
    }

    draw_set_color(_ativo ? cor_ciano : cor_linha);
    draw_roundrect_ext(_x, _y, _x + _w, _y + _h, 8, 8, true);
}

// ----------------------------------------------------------
// PERSONAGEM (sprite)
// _x, _y   = posicao dos PES do personagem (origem Bottom Center)
// _erro    = true usa spr_player_frente_erro
// _trabalhando = true faz o personagem pular de leve
// ----------------------------------------------------------
desenhar_jogador = function(_x, _y, _erro, _trabalhando)
{
    var pulo = _trabalhando ? sin(anim * 0.3) * 3 : sin(anim * 0.08) * 1.5;
    var tremor = _erro ? irandom_range(-1, 1) : 0;

    var spr = _erro ? spr_player_frente_erro : spr_player_frente;

    // altura do personagem na tela (mude aqui para deixar maior ou menor)
    var alvo_h = 100;
    var esc = alvo_h / sprite_get_height(spr);

    draw_sprite_ext(spr, 0, _x + tremor, _y + pulo, esc, esc, 0, c_white, 1);
}

// ---------- Comeco ----------
resetar_canteiros();