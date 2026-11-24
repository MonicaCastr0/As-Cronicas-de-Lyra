// ==========================================================
// CREATE - Desafio da Porta Eletronica (SE / ENTAO / SENAO)
// Operacao: Recuperacao do Acesso
// ==========================================================

// ---------- Dados do sistema (usados nas 3 fases) ----------
energia             = 78;
requisito_minimo     = 50;
codigo_correto      = "4721";
codigo_digitado     = "4712";
tentativas          = 1;
tentativas_limite   = 3;
temperatura         = 92;
limite_seguro       = 80;

// ---------- Estado do desafio ----------
// estado: 0 = montando | 1 = errou | 2 = acertou a fase | 3 = tudo concluido
fase_atual = 0;
estado = 0;
condicao_selecionada   = -1;
acao_entao_selecionada = -1;
acao_senao_selecionada = -1;
ramo = "";           // "entao" ou "senao" (qual lado foi executado)
msg = "";
erros_fase = 0;
erros_total = 0;
mostrar_dica = false;
shake = 0;
anim = 0;

if (!variable_global_exists("porta_aberta"))      global.porta_aberta = false;
if (!variable_global_exists("desafio_concluido")) global.desafio_concluido = false;

// ---------- Cores (tema roxo) ----------
cor_fundo       = make_color_rgb(8, 6, 18);
cor_painel      = make_color_rgb(22, 15, 37);
cor_linha       = make_color_rgb(82, 57, 112);
cor_normal      = make_color_rgb(43, 31, 62);
cor_hover       = make_color_rgb(72, 49, 100);
cor_borda       = make_color_rgb(180, 105, 255);
cor_ciano       = make_color_rgb(205, 155, 255);
cor_verde       = make_color_rgb(90, 220, 155);
cor_laranja     = make_color_rgb(185, 125, 255);
cor_vermelho    = make_color_rgb(255, 95, 115);
cor_amarelo     = make_color_rgb(235, 205, 255);
cor_cinza       = make_color_rgb(195, 185, 215);
cor_texto       = make_color_rgb(225, 215, 240);
cor_botao       = make_color_rgb(115, 60, 180);
cor_botao_hover = make_color_rgb(160, 90, 230);
cor_botao_off   = make_color_rgb(55, 43, 70);

// ---------- Como cada acao aparece no codigo gerado ----------
codigo_acao = {
    ativar_circuito: "ativar_circuito_controle();",
    abrir:           "abrir_porta();",
    bloquear:        "manter_bloqueada();",
    alarme:          "ativar_alarme();",
    resfriar:        "ativar_resfriamento();"
};

// ==========================================================
// AS 3 FASES DO DIAGNOSTICO
// ==========================================================
fases = [

    // ---------------- FASE 1: ALIMENTACAO ----------------
    {
        nome: "ENERGIA",
        titulo: "FASE 1 - ALIMENTACAO DO SISTEMA",
        contexto: "A porta nao responde. O circuito precisa de pelo menos 50% de bateria para funcionar. A carga atual e 78%. Verifique se a alimentacao pode ser ativada.",
        objetivo_txt: "ATIVAR O CIRCUITO DE CONTROLE",
        objetivo: "ativar_circuito",
        variaveis: [
            ["energia", string(energia) + "%"],
            ["requisito_minimo", string(requisito_minimo) + "%"]
        ],
        condicoes: [
            { txt: "energia >= requisito_minimo", valor: (energia >= requisito_minimo) },
            { txt: "energia < requisito_minimo",  valor: (energia < requisito_minimo)  },
            { txt: "energia == 100",              valor: (energia == 100)              }
        ],
        entao: [
            { txt: "ATIVAR CIRCUITO",    acao: "ativar_circuito" },
            { txt: "MANTER BLOQUEADA",   acao: "bloquear"        },
            { txt: "ATIVAR ALARME",      acao: "alarme"          }
        ],
        senao: [
            { txt: "MANTER BLOQUEADA",   acao: "bloquear"        },
            { txt: "ATIVAR CIRCUITO",    acao: "ativar_circuito" },
            { txt: "ATIVAR ALARME",      acao: "alarme"          }
        ],
        dica: "A bateria esta em 78% e o minimo e 50%. A comparacao energia >= requisito_minimo e VERDADEIRA. Nesse caso, qual acao deve ficar no ENTAO?",
        explicacao: "A bateria esta acima do minimo exigido. Como a condicao e VERDADEIRA, o ENTAO executa ATIVAR CIRCUITO. A porta ainda nao abre: primeiro estamos restabelecendo a alimentacao.",
        erro_txt: "A bateria tem 78%, acima do minimo de 50%. O circuito pode ser ativado. Confira qual ramo sera executado e escolha ATIVAR CIRCUITO nesse ramo."
    },

    // ---------------- FASE 2: SEGURANCA ----------------
    {
        nome: "SEGURANCA",
        titulo: "FASE 2 - TESTE DO TECLADO",
        contexto: "O circuito foi reativado. O teclado recebeu o codigo 4712, mas o codigo autorizado e 4721. Esta e a primeira tentativa invalida. Apos 3 falhas, o alarme dispara.",
        objetivo_txt: "MANTER A PORTA BLOQUEADA",
        objetivo: "bloquear",
        variaveis: [
            ["codigo_digitado", codigo_digitado],
            ["codigo_correto", codigo_correto],
            ["tentativas", string(tentativas) + " / " + string(tentativas_limite)]
        ],
        condicoes: [
            { txt: "codigo_digitado == codigo_correto", valor: (codigo_digitado == codigo_correto) },
            { txt: "codigo_digitado != codigo_correto", valor: (codigo_digitado != codigo_correto) },
            { txt: "tentativas >= tentativas_limite",  valor: (tentativas >= tentativas_limite)  }
        ],
        entao: [
            { txt: "ABRIR PORTA",        acao: "abrir"    },
            { txt: "ATIVAR ALARME",      acao: "alarme"   },
            { txt: "MANTER BLOQUEADA",   acao: "bloquear" }
        ],
        senao: [
            { txt: "ATIVAR ALARME",      acao: "alarme"   },
            { txt: "MANTER BLOQUEADA",   acao: "bloquear" },
            { txt: "ABRIR PORTA",        acao: "abrir"    }
        ],
        dica: "O codigo digitado 4712 e diferente do autorizado 4721. Uma possibilidade e usar !=: a condicao sera VERDADEIRA e o ENTAO deve manter a porta bloqueada.",
        explicacao: "O codigo digitado e diferente do codigo autorizado. Como esta e a primeira tentativa invalida, o sistema deve manter a porta bloqueada. O alarme so sera acionado quando o numero de tentativas chegar a 3.",
        erro_txt: "O codigo informado esta incorreto e esta e apenas a primeira tentativa invalida. A porta deve continuar bloqueada; o alarme so deve disparar quando tentativas >= 3."
    },

    // ---------------- FASE 3: MOTOR ----------------
    {
        nome: "MOTOR",
        titulo: "FASE 3 - TEMPERATURA DO MOTOR",
        contexto: "A seguranca do teclado foi testada. Agora verifique o motor: ele esta a 92 C, acima do limite seguro de 80 C. Resfrie o mecanismo antes de liberar a porta.",
        objetivo_txt: "ATIVAR O RESFRIAMENTO DO MOTOR",
        objetivo: "resfriar",
        variaveis: [
            ["temperatura", string(temperatura) + " C"],
            ["limite_seguro", string(limite_seguro) + " C"]
        ],
        condicoes: [
            { txt: "temperatura > limite_seguro",  valor: (temperatura > limite_seguro)  },
            { txt: "temperatura <= limite_seguro", valor: (temperatura <= limite_seguro) },
            { txt: "temperatura >= limite_seguro", valor: (temperatura >= limite_seguro) }
        ],
        entao: [
            { txt: "ATIVAR RESFRIAMENTO", acao: "resfriar" },
            { txt: "ABRIR PORTA",         acao: "abrir"    },
            { txt: "MANTER BLOQUEADA",    acao: "bloquear" }
        ],
        senao: [
            { txt: "ABRIR PORTA",         acao: "abrir"    },
            { txt: "ATIVAR RESFRIAMENTO", acao: "resfriar" },
            { txt: "ATIVAR ALARME",       acao: "alarme"   }
        ],
        dica: "O motor esta a 92 C e o limite seguro e 80 C. Como 92 > 80 e VERDADEIRO, o ENTAO deve ativar o resfriamento.",
        explicacao: "O motor esta 12 C acima do limite seguro. Como a condicao e VERDADEIRA, o ENTAO executa ATIVAR RESFRIAMENTO. Depois do diagnostico, o sistema podera liberar a porta.",
        erro_txt: "O motor esta acima da temperatura segura. O ramo que sera executado precisa acionar ATIVAR RESFRIAMENTO antes de liberar a porta."
    }
];

// ==========================================================
// LAYOUT (um lugar so, usado no Step e no Draw GUI)
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

// Retangulos [x1, y1, x2, y2]
rect_cond  = function(L, i) { return [L.esq + 510, L.topo + 108 + i * 38, L.dir - 30, L.topo + 140 + i * 38]; }
rect_entao = function(L, i) { return [L.esq + 510, L.topo + 270 + i * 38, L.dir - 30, L.topo + 302 + i * 38]; }
rect_senao = function(L, i) { return [L.esq + 510, L.topo + 432 + i * 38, L.dir - 30, L.topo + 464 + i * 38]; }
rect_botao = function(L)    { return [L.dir - 230, L.baixo - 68, L.dir - 30, L.baixo - 22]; }

mouse_em = function(r, mx, my)
{
    return point_in_rectangle(mx, my, r[0], r[1], r[2], r[3]);
}

// ==========================================================
// LOGICA
// ==========================================================
reiniciar_selecao = function()
{
    condicao_selecionada   = -1;
    acao_entao_selecionada = -1;
    acao_senao_selecionada = -1;
    ramo = "";
    msg = "";
    if (estado != 3) estado = 0;
}

avaliar = function()
{
    var fase = fases[fase_atual];
    var cond = fase.condicoes[condicao_selecionada];
    var verdadeira = cond.valor;
    var escolha;

    if (verdadeira)
    {
        escolha = fase.entao[acao_entao_selecionada];
        ramo = "entao";
    }
    else
    {
        escolha = fase.senao[acao_senao_selecionada];
        ramo = "senao";
    }

    var nome_ramo  = verdadeira ? "ENTAO" : "SENAO";
    var nome_valor = verdadeira ? "VERDADEIRO" : "FALSO";
    var linha1 = "SE (" + cond.txt + ") e " + nome_valor + " -> executou o " + nome_ramo + ": " + escolha.txt + ".";

    if (escolha.acao == fase.objetivo)
    {
        estado = 2;
        msg = linha1 + "\n" + fase.explicacao;
    }
    else
    {
        estado = 1;
        erros_fase++;
        erros_total++;
        shake = 14;
        if (erros_fase >= 2) mostrar_dica = true;

        msg = linha1 + "\n" + fase.erro_txt;
    }
}

fechar_desafio = function()
{
    global.desafio_aberto = false;
    Obj_player.pode_mover = true;
    reiniciar_selecao();
}

acao_botao = function()
{
    if (estado == 0 || estado == 1)
    {
        if (condicao_selecionada != -1 && acao_entao_selecionada != -1 && acao_senao_selecionada != -1)
        {
            avaliar();
        }
        else
        {
            estado = 0;
            msg = "Antes de executar, escolha uma condicao SE, uma acao para ENTAO e outra para SENAO.";
            shake = 6;
        }
    }
    else if (estado == 2)
    {
        if (fase_atual < array_length(fases) - 1)
        {
            fase_atual++;
            erros_fase = 0;
            mostrar_dica = false;
            estado = 0;
            reiniciar_selecao();
        }
        else
        {
            estado = 3;
            global.desafio_concluido = true;
            global.porta_aberta = true;
        }
    }
    else if (estado == 3)
    {
        fechar_desafio();
    }
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

desenhar_opcao = function(r, texto, selecionado, mx, my, cor_acento)
{
    var hover = mouse_em(r, mx, my);

    if (selecionado)
        draw_set_color(merge_color(cor_normal, cor_acento, 0.35));
    else if (hover)
        draw_set_color(cor_hover);
    else
        draw_set_color(cor_normal);

    draw_roundrect_ext(r[0], r[1], r[2], r[3], 8, 8, false);

    if (selecionado || hover)
    {
        draw_set_color(cor_acento);
        draw_rectangle(r[0], r[1] + 4, r[0] + 4, r[3] - 4, false);
    }

    if (selecionado)
    {
        draw_set_color(cor_acento);
        draw_roundrect_ext(r[0], r[1], r[2], r[3], 8, 8, true);
    }

    draw_set_valign(fa_middle);
    draw_set_color(selecionado ? c_white : cor_texto);
    if (hover && !selecionado) draw_set_color(c_white);
    draw_text(r[0] + 18, (r[1] + r[3]) / 2, texto);
    draw_set_valign(fa_top);
}

// Desenha varios pedacos coloridos na mesma linha: [[texto, cor], ...]
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
