// ==========================================================
// CRIAR  -  Desafio da Porta Eletronica (SE / ENTAO / SENAO)
// ==========================================================

// ---------- Dados do sistema (usados nas 3 fases) ----------
energia         = 78;
codigo_correto  = "4721";
codigo_digitado = "4712";
tentativas      = 1;
temperatura     = 92;
limite_seguro   = 80;

// ---------- Estado do desafio ----------
// estado: 0 = montando | 1 = errou | 2 = acertou a fase | 3 = tudo concluido
fase_atual = 0;
estado = 0;
condicao_selecionada   = -1;
acao_entao_selecionada = -1;
acao_senao_selecionada = -1;
ramo = "";            // "entao" ou "senao" (qual lado foi executado)
msg = "";
erros_fase = 0;
erros_total = 0;
mostrar_dica = false;
shake = 0;            // tremor da janela quando erra
anim = 0;

if (!variable_global_exists("porta_aberta"))      global.porta_aberta = false;
if (!variable_global_exists("desafio_concluido")) global.desafio_concluido = false;

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

// ---------- Como cada acao aparece no codigo gerado ----------
codigo_acao = {
    abrir:    "abrir_porta();",
    bloquear: "manter_bloqueada();",
    alarme:   "ativar_alarme();",
    resfriar: "ativar_resfriamento();"
};

// ==========================================================
// AS 3 FASES
// ==========================================================
fases = [

    // ---------------- FASE 1 : ENERGIA ----------------
    {
        nome: "ENERGIA",
        titulo: "FASE 1 - ENERGIA DA PORTA",
        contexto: "A porta eletrica depende da bateria. Ela so deve abrir quando a energia estiver no minimo em 50%. Monte a regra do sistema.",
        objetivo_txt: "a porta deve ABRIR",
        objetivo: "abrir",
        variaveis: [
            ["energia", string(energia) + "%"],
            ["requisito_minimo", "50%"]
        ],
        condicoes: [
            { txt: "energia >= 50",  valor: (energia >= 50)  },
            { txt: "energia < 50",   valor: (energia < 50)   },
            { txt: "energia == 100", valor: (energia == 100) }
        ],
        entao: [
            { txt: "ABRIR PORTA",      acao: "abrir"    },
            { txt: "MANTER BLOQUEADA", acao: "bloquear" },
            { txt: "ATIVAR ALARME",    acao: "alarme"   }
        ],
        senao: [
            { txt: "MANTER BLOQUEADA", acao: "bloquear" },
            { txt: "ABRIR PORTA",      acao: "abrir"    },
            { txt: "ATIVAR ALARME",    acao: "alarme"   }
        ],
        dica: "Compare a energia com o minimo. 78 >= 50 e VERDADEIRO ou FALSO? Se for verdadeiro, quem executa?",
        explicacao: "Lembre: com energia 78, a condicao (energia >= 50) e VERDADEIRA e (energia < 50) e FALSA. Varias regras diferentes podem chegar ao mesmo resultado!"
    },

    // ---------------- FASE 2 : CODIGO ----------------
    {
        nome: "CODIGO",
        titulo: "FASE 2 - TECLADO DE CODIGO",
        contexto: "Alguem digitou um codigo no teclado da porta. O sistema precisa comparar o codigo digitado com o codigo correto.",
        objetivo_txt: "codigo errado deve ATIVAR O ALARME",
        objetivo: "alarme",
        variaveis: [
            ["codigo_digitado", codigo_digitado],
            ["codigo_correto", codigo_correto],
            ["tentativas", string(tentativas)]
        ],
        condicoes: [
            { txt: "codigo_digitado == codigo_correto", valor: (codigo_digitado == codigo_correto) },
            { txt: "codigo_digitado != codigo_correto", valor: (codigo_digitado != codigo_correto) },
            { txt: "tentativas >= 3",                    valor: (tentativas >= 3)                  }
        ],
        entao: [
            { txt: "ABRIR PORTA",      acao: "abrir"    },
            { txt: "ATIVAR ALARME",    acao: "alarme"   },
            { txt: "MANTER BLOQUEADA", acao: "bloquear" }
        ],
        senao: [
            { txt: "ATIVAR ALARME",    acao: "alarme"   },
            { txt: "MANTER BLOQUEADA", acao: "bloquear" },
            { txt: "ABRIR PORTA",      acao: "abrir"    }
        ],
        dica: "Os codigos sao diferentes, entao '==' da FALSO. Quando a condicao e falsa, quem executa? O SENAO!",
        explicacao: "Os codigos sao diferentes: '==' da FALSO e '!=' da VERDADEIRO. Por isso existem mais de um jeito certo de disparar o alarme!"
    },

    // ---------------- FASE 3 : TEMPERATURA ----------------
    {
        nome: "TEMP.",
        titulo: "FASE 3 - TEMPERATURA DO SISTEMA",
        contexto: "Os motores da porta estao esquentando. Acima do limite seguro o sistema pode queimar. Proteja o equipamento!",
        objetivo_txt: "superaquecido: ATIVAR RESFRIAMENTO",
        objetivo: "resfriar",
        variaveis: [
            ["temperatura", string(temperatura) + " C"],
            ["limite_seguro", string(limite_seguro) + " C"]
        ],
        condicoes: [
            { txt: "temperatura > limite_seguro",  valor: (temperatura > limite_seguro)  },
            { txt: "temperatura <= limite_seguro", valor: (temperatura <= limite_seguro) },
            { txt: "temperatura == 0",             valor: (temperatura == 0)             }
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
        dica: "92 e maior que 80? Entao 'temperatura > limite_seguro' e VERDADEIRA e o ENTAO e quem executa.",
        explicacao: "Com 92 C, (temperatura > limite_seguro) e VERDADEIRA e (<=) e FALSA. Operadores: > < >= <= == !="
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

        var explica;
        if (verdadeira)
            explica = "A condicao era VERDADEIRA, entao so o ENTAO roda. O SENAO e ignorado.";
        else
            explica = "A condicao era FALSA, entao so o SENAO roda. O ENTAO e ignorado.";

        msg = linha1 + "\n" + explica;
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
            msg = "Escolha uma condicao, uma acao para o ENTAO e uma para o SENAO antes de executar.";
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
    draw_set_color(selecionado ? c_white : cor_cinza);
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
