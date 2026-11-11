// CREATE - Obj_desafio_array
// Objeto de dados e logica.
// Criado pelo Obj_interacao_array na compilação

// Controle exclusivo do desafio de Arrays.
if (!variable_global_exists("desafio_array_aberto")) {
    global.desafio_array_aberto = false;
}

// Controle de conclusao.
if (!variable_global_exists("desafio_array_concluido")) {
    global.desafio_array_concluido = false;
}

// Liberacao do acesso ao chefe.
if (!variable_global_exists("acesso_boss_liberado")) {
    global.acesso_boss_liberado = false;
}

// Array inicial de quatro memorias.
memorias = [
    "Sabedoria",
    "Criacao",
    "Conhecimento",
    "Inovacao"
];

// Estado: 0 = respondendo | 1 = errou | 2 = acertou | 3 = concluido.
fase_atual = 0;
estado = 0;
opcao_selecionada = -1;
msg = "";
erros_fase = 0;
erros_total = 0;
mostrar_dica = false;
shake = 0;
anim = 0;

// Tres etapas do desafio de Arrays.
fases = [
    {
        nome: "ACESSO",
        titulo: "ETAPA 1 - ACESSANDO UMA MEMORIA",
        contexto: "O arquivo possui quatro memorias, representadas pelas quatro estatuas. O mecanismo solicita o valor armazenado no indice 2. Em Java, os indices comecam em zero.",
        pergunta: "Qual memoria esta armazenada em memorias[2]?",
        dica: "Conte os indices a partir de zero: 0, 1, 2 e 3. O indice 2 corresponde a terceira posicao.",
        memoria_visual: ["Sabedoria", "Criacao", "Conhecimento", "Inovacao"],
        opcoes: ["Sabedoria", "Criacao", "Conhecimento", "Inovacao"],
        correta: 2,
        codigo: [
            "String[] memorias = { ... };",
            "System.out.println(memorias[2]);",
            "// Resultado: *******"
        ],
        explicacao: "Exato! memorias[2] acessa o terceiro elemento. Como os indices comecam em zero, o indice 2 corresponde a terceira posicao."
    },
    {
        nome: "LOCALIZAR",
        titulo: "ETAPA 2 - LOCALIZANDO UMA MEMORIA",
        contexto: "O painel encontrou o registro 'Inovacao', mas perdeu a referencia de sua posicao. Identifique em qual indice essa memoria esta armazenada.",
        pergunta: "Em qual indice esta a memoria Inovacao?",
        dica: "Sabedoria esta no indice 0, Criacao no indice 1 e Conhecimento no indice 2. Qual indice resta para Inovacao?",
        memoria_visual: ["Sabedoria", "Criacao", "Conhecimento", "Inovacao"],
        opcoes: ["Indice 0", "Indice 1", "Indice 2", "Indice 3"],
        correta: 3,
        codigo: [
            "String[] memorias = { ... };",
            "String memoria = memorias[3];",
            "// memoria: Inovacao"
        ],
        explicacao: "Exatamente! Inovacao esta no indice 3. O indice identifica a posicao do elemento dentro do array."
    },
    {
        nome: "RESTAURAR",
        titulo: "ETAPA 3 - RESTAURANDO O ARQUIVO",
        contexto: "Uma das memorias foi corrompida. O painel informa que o espaco vazio pertence ao indice 1. Restaure o valor que originalmente ocupava essa posicao.",
        pergunta: "Qual valor deve preencher memorias[1]?",
        dica: "O indice 1 corresponde a segunda posicao do array. Observe a sequencia das quatro memorias e identifique o registro ausente.",
        memoria_visual: ["Sabedoria", "????", "Conhecimento", "Inovacao"],
        opcoes: ["Sabedoria", "Criacao", "Conhecimento", "Inovacao"],
        correta: 1,
        codigo: [
            "String[] memorias = { ... };",
            "memorias[1] = \"Criacao\";",
            "// Memoria restaurada!"
        ],
        explicacao: "Arquivo restaurado! Atribuir um valor a memorias[1] substitui o elemento armazenado naquela posicao. As quatro memorias estao novamente acessiveis."
    }
];

// Paleta visual da interface.
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

// Retorna as coordenadas da janela, centralizada na GUI.
get_layout = function(ox) {
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
};

// Retangulos das quatro alternativas e do botao.
rect_opcao = function(L, i) {
    var pos_y = L.topo + 220 + i * 58;
    return [L.esq + 520, pos_y, L.dir - 30, pos_y + 40];
};

rect_botao = function(L) {
    return [L.dir - 230, L.baixo - 68, L.dir - 30, L.baixo - 22];
};

mouse_em = function(r, mx, my) {
    return point_in_rectangle(mx, my, r[0], r[1], r[2], r[3]);
};

// Reinicia apenas a selecao da etapa atual.
reiniciar_selecao = function() {
    opcao_selecionada = -1;
    msg = "";
    if (estado != 3) estado = 0;
};

// Confere a alternativa selecionada.
avaliar = function() {
    var fase = fases[fase_atual];

    if (opcao_selecionada == fase.correta) {
        // Na ultima etapa, a resposta correta altera o proprio array.
        if (fase_atual == 2) {
            memorias[1] = "Criacao";
            fases[2].memoria_visual[1] = "Criacao";
        }

        estado = 2;
        msg = fase.explicacao;
    } else {
        estado = 1;
        erros_fase++;
        erros_total++;
        shake = 14;

        if (erros_fase >= 2) mostrar_dica = true;

        msg = "Essa nao e a resposta correta. Observe os indices e os valores do array e tente novamente.";
    }
};

// Executa o botao principal da interface.
acao_botao = function() {
    if (estado == 0 || estado == 1) {
        if (opcao_selecionada != -1) {
            avaliar();
        } else {
            estado = 0;
            msg = "Selecione uma das quatro alternativas antes de executar.";
            shake = 6;
        }
    }
    else if (estado == 2) {
        if (fase_atual < array_length(fases) - 1) {
            fase_atual++;
            erros_fase = 0;
            mostrar_dica = false;
            estado = 0;
            reiniciar_selecao();
        } else {
            estado = 3;

            // Flags exclusivas deste desafio e da passagem para o chefe.
            global.desafio_array_concluido = true;
            global.acesso_boss_liberado = true;
        }
    }
};

// Desenha um painel arredondado com titulo.
painel = function(x1, y1, x2, y2, titulo, cor) {
    draw_set_color(cor_painel);
    draw_roundrect_ext(x1, y1, x2, y2, 10, 10, false);
    draw_set_color(cor_linha);
    draw_roundrect_ext(x1, y1, x2, y2, 10, 10, true);

    if (titulo != "") {
        draw_set_color(cor);
        draw_text(x1 + 14, y1 + 8, titulo);
        draw_set_color(cor_linha);
        draw_line(x1 + 10, y1 + 28, x2 - 10, y1 + 28);
    }
};

// Desenha uma alternativa.
desenhar_opcao = function(r, texto, selecionado, mx, my, cor_acento) {
    var hover = mouse_em(r, mx, my);

    if (selecionado) {
        draw_set_color(merge_color(cor_normal, cor_acento, 0.35));
    } else if (hover) {
        draw_set_color(cor_hover);
    } else {
        draw_set_color(cor_normal);
    }

    draw_roundrect_ext(r[0], r[1], r[2], r[3], 8, 8, false);

    if (selecionado || hover) {
        draw_set_color(cor_acento);
        draw_rectangle(r[0], r[1] + 4, r[0] + 4, r[3] - 4, false);
    }

    if (selecionado) {
        draw_set_color(cor_acento);
        draw_roundrect_ext(r[0], r[1], r[2], r[3], 8, 8, true);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(selecionado ? c_white : cor_cinza);
    if (hover && !selecionado) draw_set_color(c_white);
    draw_text(r[0] + 16, (r[1] + r[3]) / 2, texto);
    draw_set_valign(fa_top);
};
