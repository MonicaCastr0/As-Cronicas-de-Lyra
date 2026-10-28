// ==========================================================
// DRAW GUI  -  Desafio da Porta Eletronica
// (use o evento "Draw GUI", pois tudo usa coordenadas da GUI)
// ==========================================================
if (!global.desafio_aberto) exit;

var ox = (shake > 0) ? irandom_range(-shake, shake) * 0.5 : 0;
var L  = get_layout(ox);
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var fase = fases[fase_atual];
var n_fases = array_length(fases);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

// ---------- Fundo escurecido ----------
draw_set_alpha(0.82);
draw_set_color(c_black);
draw_rectangle(0, 0, L.largura, L.altura, false);
draw_set_alpha(1);

// ---------- Janela (gradiente + bordas) ----------
draw_rectangle_color(L.esq, L.topo, L.dir, L.baixo,
    cor_painel, cor_painel, cor_fundo, cor_fundo, false);

// linhas de scanner (efeito terminal)
draw_set_alpha(0.05);
draw_set_color(c_white);
for (var yy = L.topo; yy < L.baixo; yy += 6)
{
    draw_line(L.esq, yy, L.dir, yy);
}
draw_set_alpha(1);

// borda com brilho pulsante
var brilho = 0.35 + 0.15 * sin(anim * 0.05);
draw_set_color(cor_borda);
draw_set_alpha(brilho);
draw_rectangle(L.esq - 3, L.topo - 3, L.dir + 3, L.baixo + 3, true);
draw_set_alpha(1);
draw_rectangle(L.esq, L.topo, L.dir, L.baixo, true);

// cantos
var c = 22;
draw_set_color(cor_ciano);
draw_line_width(L.esq, L.topo, L.esq + c, L.topo, 3);
draw_line_width(L.esq, L.topo, L.esq, L.topo + c, 3);
draw_line_width(L.dir, L.topo, L.dir - c, L.topo, 3);
draw_line_width(L.dir, L.topo, L.dir, L.topo + c, 3);
draw_line_width(L.esq, L.baixo, L.esq + c, L.baixo, 3);
draw_line_width(L.esq, L.baixo, L.esq, L.baixo - c, 3);
draw_line_width(L.dir, L.baixo, L.dir - c, L.baixo, 3);
draw_line_width(L.dir, L.baixo, L.dir, L.baixo - c, 3);

// ==========================================================
// CABECALHO
// ==========================================================
draw_set_color(cor_ciano);
draw_text(L.esq + 30, L.topo + 12, "CODELORE // TERMINAL DE ACESSO");
draw_set_color(c_white);
draw_text(L.esq + 30, L.topo + 34, fase.titulo);

// progresso das fases
for (var i = 0; i < n_fases; i++)
{
    var px = L.dir - 330 + i * 105;
    var py = L.topo + 16;
    var feito = (i < fase_atual) || (i == fase_atual && estado >= 2);

    if (feito)
        draw_set_color(merge_color(cor_normal, cor_verde, 0.5));
    else
        draw_set_color(cor_normal);
    draw_roundrect_ext(px, py, px + 98, py + 30, 8, 8, false);

    if (i == fase_atual)
        draw_set_color(cor_ciano);
    else if (feito)
        draw_set_color(cor_verde);
    else
        draw_set_color(cor_linha);
    draw_roundrect_ext(px, py, px + 98, py + 30, 8, 8, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(feito || i == fase_atual ? c_white : cor_cinza);
    draw_text(px + 49, py + 15, string(i + 1) + ". " + fases[i].nome);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

draw_set_color(cor_linha);
draw_line(L.esq + 20, L.topo + 62, L.dir - 20, L.topo + 62);

// ==========================================================
// COLUNA ESQUERDA
// ==========================================================
var lx1 = L.esq + 30;
var lx2 = L.esq + 480;

// ---------- CONTEXTO / DICA ----------
painel(lx1, L.topo + 70, lx2, L.topo + 170,
       mostrar_dica ? "DICA  (H para esconder)" : "SITUACAO", mostrar_dica ? cor_amarelo : cor_ciano);

draw_set_color(mostrar_dica ? cor_amarelo : c_white);
draw_text_ext(lx1 + 14, L.topo + 104, mostrar_dica ? fase.dica : fase.contexto, 17, 420);

// ---------- VARIAVEIS ----------
var nv = array_length(fase.variaveis);
painel(lx1, L.topo + 178, lx2, L.topo + 290, "VARIAVEIS DO SISTEMA", cor_laranja);

for (var i = 0; i < nv; i++)
{
    var vy = L.topo + 212 + i * 24;
    draw_set_color(cor_cinza);
    draw_text(lx1 + 14, vy, fase.variaveis[i][0] + " =");
    draw_set_color(cor_amarelo);
    draw_text(lx1 + 230, vy, fase.variaveis[i][1]);
}

// objetivo
draw_set_color(cor_verde);
draw_text(lx1 + 14, L.topo + 212 + nv * 24, "OBJETIVO: " + fase.objetivo_txt);

// ---------- CODIGO GERADO ----------
var cy1 = L.topo + 298;
var cy2 = L.topo + 548;
painel(lx1, cy1, lx2, cy2, "SEU CODIGO (gerado ao vivo)", cor_verde);

var cond_txt  = (condicao_selecionada != -1)   ? fase.condicoes[condicao_selecionada].txt : "???";
var entao_txt = (acao_entao_selecionada != -1) ? codigo_acao[$ fase.entao[acao_entao_selecionada].acao] : "???";
var senao_txt = (acao_senao_selecionada != -1) ? codigo_acao[$ fase.senao[acao_senao_selecionada].acao] : "???";

var ly = cy1 + 40;
var lh = 24;

// destaque do ramo executado
if (estado == 1 || estado == 2)
{
    var cor_ramo = (estado == 2) ? cor_verde : cor_vermelho;
    var r0 = (ramo == "entao") ? 1 : 5;
    draw_set_alpha(0.22);
    draw_set_color(cor_ramo);
    draw_rectangle(lx1 + 8, ly + r0 * lh - 2, lx2 - 8, ly + (r0 + 3) * lh - 2, false);
    draw_set_alpha(1);
}

desenhar_partes(lx1 + 20, ly + 0 * lh, [["if ", cor_ciano], ["(", c_white], [cond_txt, condicao_selecionada != -1 ? cor_amarelo : cor_cinza], [")", c_white]]);
desenhar_partes(lx1 + 20, ly + 1 * lh, [["{", c_white]]);
desenhar_partes(lx1 + 20, ly + 2 * lh, [["      " + entao_txt, acao_entao_selecionada != -1 ? cor_verde : cor_cinza]]);
desenhar_partes(lx1 + 20, ly + 3 * lh, [["}", c_white]]);
desenhar_partes(lx1 + 20, ly + 4 * lh, [["else", cor_ciano]]);
desenhar_partes(lx1 + 20, ly + 5 * lh, [["{", c_white]]);
desenhar_partes(lx1 + 20, ly + 6 * lh, [["      " + senao_txt, acao_senao_selecionada != -1 ? cor_verde : cor_cinza]]);
desenhar_partes(lx1 + 20, ly + 7 * lh, [["}", c_white]]);

// ==========================================================
// COLUNA DIREITA  (SE / ENTAO / SENAO)
// ==========================================================
var rx1 = L.esq + 500;
var rx2 = L.dir - 20;

painel(rx1, L.topo + 70,  rx2, L.topo + 224, "SE  (a condicao)",            cor_ciano);
painel(rx1, L.topo + 232, rx2, L.topo + 386, "ENTAO  (se for VERDADEIRO)",  cor_verde);
painel(rx1, L.topo + 394, rx2, L.topo + 548, "SENAO  (se for FALSO)",       cor_laranja);

for (var i = 0; i < 3; i++)
{
    desenhar_opcao(rect_cond(L, i),  fase.condicoes[i].txt, condicao_selecionada == i,   mx, my, cor_ciano);
    desenhar_opcao(rect_entao(L, i), fase.entao[i].txt,     acao_entao_selecionada == i, mx, my, cor_verde);
    desenhar_opcao(rect_senao(L, i), fase.senao[i].txt,     acao_senao_selecionada == i, mx, my, cor_laranja);
}

// ==========================================================
// RODAPE: MENSAGEM + BOTAO
// ==========================================================
if (msg != "")
{
    var cor_msg = cor_amarelo;
    var titulo_msg = "";
    if (estado == 1) { cor_msg = cor_vermelho; titulo_msg = "INCORRETO!  "; }
    if (estado == 2) { cor_msg = cor_verde;    titulo_msg = "CORRETO!  ";   }

    draw_set_color(cor_msg);
    draw_text_ext(L.esq + 30, L.topo + 558, titulo_msg + msg, 17, 640);
}
else
{
    draw_set_color(cor_cinza);
    draw_text_ext(L.esq + 30, L.topo + 562, "Monte a regra: escolha uma condicao, o que fazer se for VERDADEIRO e o que fazer se for FALSO.", 17, 640);
}

// botao principal
var rb = rect_botao(L);
var pronto = (condicao_selecionada != -1 && acao_entao_selecionada != -1 && acao_senao_selecionada != -1);
var texto_botao = "EXECUTAR";
var ativo = pronto;

if (estado == 2)
{
    texto_botao = (fase_atual < n_fases - 1) ? "PROXIMA FASE" : "FINALIZAR";
    ativo = true;
}
if (estado == 3)
{
    texto_botao = "FECHAR";
    ativo = true;
}

if (!ativo)
    draw_set_color(cor_botao_off);
else if (mouse_em(rb, mx, my))
    draw_set_color(cor_botao_hover);
else
    draw_set_color(cor_botao);

draw_roundrect_ext(rb[0], rb[1], rb[2], rb[3], 10, 10, false);

if (ativo)
{
    // brilho pulsante quando precisa avancar
    if (estado == 2)
    {
        draw_set_alpha(0.4 + 0.3 * sin(anim * 0.12));
        draw_set_color(c_white);
        draw_roundrect_ext(rb[0], rb[1], rb[2], rb[3], 10, 10, true);
        draw_set_alpha(1);
    }
}

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(ativo ? c_white : cor_cinza);
draw_text((rb[0] + rb[2]) / 2, (rb[1] + rb[3]) / 2, texto_botao);

// atalhos
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(cor_cinza);
draw_text(L.dir - 30, L.baixo - 18, "ENTER executar  |  H dica  |  ESC sair");
draw_set_halign(fa_left);

// ==========================================================
// TELA FINAL (todas as fases concluidas)
// ==========================================================
if (estado == 3)
{
    draw_set_alpha(0.88);
    draw_set_color(c_black);
    draw_rectangle(L.esq + 2, L.topo + 70, L.dir - 2, L.baixo - 80, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(cor_verde);
    draw_text_transformed(L.cx, L.topo + 190, "ACESSO LIBERADO", 2, 2, 0);

    draw_set_color(c_white);
    draw_text(L.cx, L.topo + 250, "PORTA ELETRONICA ABERTA");

    draw_set_color(cor_amarelo);
    draw_text(L.cx, L.topo + 300, "Erros cometidos: " + string(erros_total));

    var nota = "Perfeito! Voce dominou o IF / ELSE!";
    if (erros_total >= 3) nota = "Muito bem! Pratique mais para ficar rapido.";
    if (erros_total >= 6) nota = "Voce conseguiu! Leia as explicacoes e tente de novo.";

    draw_set_color(cor_ciano);
    draw_text(L.cx, L.topo + 330, nota);

    draw_set_color(cor_cinza);
    draw_text_ext(L.cx, L.topo + 390, "Lembre: SE a condicao for VERDADEIRA roda o ENTAO. Se for FALSA roda o SENAO. Nunca os dois!", 17, 620);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ---------- Reset ----------
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
