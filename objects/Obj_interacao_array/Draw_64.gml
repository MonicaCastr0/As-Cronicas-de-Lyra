// DRAW GUI - Obj_interacao_array
// Interface do desafio. As variaveis e os dados pertencem a Obj_desafio_array.
show_debug_message(
    "Largura GUI: " + string(display_get_gui_width())
);

if (!global.desafio_array_aberto) exit;
if (!instance_exists(dados)) exit;

var d = dados;
var ox = (d.shake > 0) ? irandom_range(-d.shake, d.shake) * 0.5 : 0;
var L = d.get_layout(ox);
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var fase = d.fases[d.fase_atual];
var n_fases = array_length(d.fases);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Fundo escurecido.
draw_set_alpha(0.82);
draw_set_color(c_black);
draw_rectangle(0, 0, L.largura, L.altura, false);
draw_set_alpha(1);

// Janela.
draw_rectangle_color(L.esq, L.topo, L.dir, L.baixo,
    d.cor_painel, d.cor_painel, d.cor_fundo, d.cor_fundo, false);

// Linhas de scanner.
draw_set_alpha(0.05);
draw_set_color(c_white);
for (var yy = L.topo; yy < L.baixo; yy += 6) {
    draw_line(L.esq, yy, L.dir, yy);
}
draw_set_alpha(1);

// Borda com brilho.
var brilho = 0.35 + 0.15 * sin(d.anim * 0.05);
draw_set_color(d.cor_borda);
draw_set_alpha(brilho);
draw_rectangle(L.esq - 3, L.topo - 3, L.dir + 3, L.baixo + 3, true);
draw_set_alpha(1);
draw_rectangle(L.esq, L.topo, L.dir, L.baixo, true);

// Cantos.
var c = 22;
draw_set_color(d.cor_ciano);
draw_line_width(L.esq, L.topo, L.esq + c, L.topo, 3);
draw_line_width(L.esq, L.topo, L.esq, L.topo + c, 3);
draw_line_width(L.dir, L.topo, L.dir - c, L.topo, 3);
draw_line_width(L.dir, L.topo, L.dir, L.topo + c, 3);
draw_line_width(L.esq, L.baixo, L.esq + c, L.baixo, 3);
draw_line_width(L.esq, L.baixo, L.esq, L.baixo - c, 3);
draw_line_width(L.dir, L.baixo, L.dir - c, L.baixo, 3);
draw_line_width(L.dir, L.baixo, L.dir, L.baixo - c, 3);

// Cabecalho.
draw_set_color(d.cor_ciano);
draw_text(L.esq + 30, L.topo + 12, "CODELORE // ARQUIVO DAS ARQUITETAS");
draw_set_color(c_white);
draw_text(L.esq + 30, L.topo + 34, fase.titulo);

// Progresso das etapas.
for (var i = 0; i < n_fases; i++) {
    var px = L.dir - 330 + i * 105;
    var py = L.topo + 16;
    var feito = (i < d.fase_atual) || (i == d.fase_atual && d.estado >= 2);

    draw_set_color(feito ? merge_color(d.cor_normal, d.cor_verde, 0.5) : d.cor_normal);
    draw_roundrect_ext(px, py, px + 98, py + 30, 8, 8, false);

    if (i == d.fase_atual) draw_set_color(d.cor_ciano);
    else if (feito) draw_set_color(d.cor_verde);
    else draw_set_color(d.cor_linha);

    draw_roundrect_ext(px, py, px + 98, py + 30, 8, 8, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(feito || i == d.fase_atual ? c_white : d.cor_cinza);
    draw_text(px + 49, py + 15, string(i + 1) + ". " + d.fases[i].nome);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

draw_set_color(d.cor_linha);
draw_line(L.esq + 20, L.topo + 62, L.dir - 20, L.topo + 62);

// Coluna esquerda: contexto/dica.
var lx1 = L.esq + 30;
var lx2 = L.esq + 480;

d.painel(lx1, L.topo + 70, lx2, L.topo + 164,
    d.mostrar_dica ? "DICA (H PARA ESCONDER)" : "SITUACAO",
    d.mostrar_dica ? d.cor_amarelo : d.cor_ciano);

draw_set_color(d.mostrar_dica ? d.cor_amarelo : c_white);
draw_text_ext(lx1 + 14, L.topo + 104,
    d.mostrar_dica ? fase.dica : fase.contexto, 16, 420);

// Visualizacao do array.
d.painel(lx1, L.topo + 172, lx2, L.topo + 300, "ARRAY DE MEMORIAS", d.cor_laranja);

var box_y1 = L.topo + 218;
var box_y2 = L.topo + 278;
var box_x = lx1 + 12;
var box_gap = 5;
var box_w = 100;

for (var i = 0; i < 4; i++) {
    var bx1 = box_x + i * (box_w + box_gap);
    var bx2 = bx1 + box_w;
    var item = fase.memoria_visual[i];

    draw_set_color(d.cor_normal);
    draw_roundrect_ext(bx1, box_y1, bx2, box_y2, 6, 6, false);

  draw_set_color((item == "????") ? d.cor_vermelho : c_white);

var largura_texto = string_width(item);
var escala_texto = min(1, (box_w - 12) / max(1, largura_texto));

draw_text_transformed(
    bx1 + box_w / 2,
    box_y1 + 39,
    item,
    escala_texto,
    1,
    0
);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(d.cor_amarelo);
    draw_text(bx1 + box_w / 2, box_y1 + 13, "[" + string(i) + "]");
    draw_set_color((item == "????") ? d.cor_vermelho : c_white);
    draw_text(bx1 + box_w / 2, box_y1 + 39, item);
}
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Codigo Java.
var cy1 = L.topo + 308;
var cy2 = L.topo + 548;
d.painel(lx1, cy1, lx2, cy2, "REPRESENTACAO EM CODIGO)", d.cor_verde);

for (var i = 0; i < array_length(fase.codigo); i++) {
    var code_y = cy1 + 48 + i * 38;
    draw_set_color(i == 1 ? d.cor_verde : d.cor_cinza);
    draw_text(lx1 + 18, code_y, fase.codigo[i]);
}

// Coluna direita: pergunta e alternativas.
var rx1 = L.esq + 500;
var rx2 = L.dir - 20;

d.painel(rx1, L.topo + 70, rx2, L.topo + 164,
    "SOLICITACAO DO MECANISMO", d.cor_ciano);
draw_set_color(c_white);
draw_text_ext(rx1 + 14, L.topo + 108, fase.pergunta, 17, 440);

d.painel(rx1, L.topo + 172, rx2, L.topo + 474,
    "SELECIONE UMA RESPOSTA", d.cor_laranja);

for (var i = 0; i < 4; i++) {
    d.desenhar_opcao(
        d.rect_opcao(L, i),
        string(i + 1) + "  -  " + fase.opcoes[i],
        d.opcao_selecionada == i,
        mx, my, d.cor_ciano
    );
}

// Mensagem.
if (d.msg != "") {
    var cor_msg = d.cor_amarelo;
    var titulo_msg = "";

    if (d.estado == 1) { cor_msg = d.cor_vermelho; titulo_msg = "INCORRETO!  "; }
    if (d.estado == 2) { cor_msg = d.cor_verde; titulo_msg = "CORRETO!  "; }

    draw_set_color(cor_msg);
    draw_text_ext(L.esq + 30, L.topo + 558, titulo_msg + d.msg, 16, 650);
} else {
    draw_set_color(d.cor_cinza);
    draw_text_ext(L.esq + 30, L.topo + 562,
        "Escolha uma alternativa e pressione EXECUTAR. Use H para consultar uma dica.",
        16, 650);
}

// Botao principal.
var rb = d.rect_botao(L);
var pronto = (d.opcao_selecionada != -1);
var texto_botao = "EXECUTAR";
var ativo = pronto;

if (d.estado == 2) {
    texto_botao = (d.fase_atual < n_fases - 1) ? "PROXIMA ETAPA" : "FINALIZAR";
    ativo = true;
}
if (d.estado == 3) {
    texto_botao = "FECHAR";
    ativo = true;
}

if (!ativo) draw_set_color(d.cor_botao_off);
else if (d.mouse_em(rb, mx, my)) draw_set_color(d.cor_botao_hover);
else draw_set_color(d.cor_botao);

draw_roundrect_ext(rb[0], rb[1], rb[2], rb[3], 10, 10, false);

if (ativo && d.estado == 2) {
    draw_set_alpha(0.4 + 0.3 * sin(d.anim * 0.12));
    draw_set_color(c_white);
    draw_roundrect_ext(rb[0], rb[1], rb[2], rb[3], 10, 10, true);
    draw_set_alpha(1);
}

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(ativo ? c_white : d.cor_cinza);
draw_text((rb[0] + rb[2]) / 2, (rb[1] + rb[3]) / 2, texto_botao);

// Atalhos.
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(d.cor_cinza);
draw_text(L.dir - 30, L.baixo - 18,
    "1-4 SELECIONAR  |  ENTER EXECUTAR  |  H DICA  |  ESC SAIR");

// Tela final.
if (d.estado == 3) {
    draw_set_alpha(0.90);
    draw_set_color(c_black);
    draw_rectangle(L.esq + 2, L.topo + 70, L.dir - 2, L.baixo - 80, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(d.cor_verde);
    draw_text_transformed(L.cx, L.topo + 190, "ARQUIVO RESTAURADO", 2, 2, 0);

    draw_set_color(c_white);
    draw_text(L.cx, L.topo + 250, "AS QUATRO MEMORIAS FORAM RECUPERADAS");

    draw_set_color(d.cor_amarelo);
    draw_text(L.cx, L.topo + 300, "Erros cometidos: " + string(d.erros_total));

    var nota = "Excelente! Voce compreendeu como acessar elementos de um array.";
    if (d.erros_total >= 3) nota = "Muito bem! Continue praticando o uso dos indices.";
    if (d.erros_total >= 6) nota = "Desafio concluido! Revise as explicacoes para fixar o conceito.";

    draw_set_color(d.cor_ciano);
    draw_text_ext(L.cx, L.topo + 330, nota, 16, 650);

    draw_set_color(d.cor_cinza);
    draw_text_ext(L.cx, L.topo + 390,
        "Um array armazena varios elementos. Cada elemento pode ser acessado ou alterado por seu indice, que em Java comeca em zero. O acesso lateral ao santuario foi liberado.",
        16, 650);

    draw_set_color(c_white);
    draw_text(L.cx, L.topo + 470, "PRESSIONE ENTER OU ESC PARA FECHAR");
}

// Restaura configuracoes de desenho para nao afetar outras interfaces.
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
