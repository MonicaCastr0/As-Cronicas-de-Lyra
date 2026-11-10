// ==========================================================
// DRAW GUI - Desafio do Jardim (VERSAO DIFICIL)
// ==========================================================
if (!global.desafio_plantar_aberto) exit;

var ox = (shake > 0) ? irandom_range(-shake, shake) * 0.5 : 0;
var L  = get_layout(ox);
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var fase = fases[fase_atual];
var n_fases = array_length(fases);
var n_seq = array_length(sequencia);
var n_ferr = array_length(passos);
var editavel = (estado == 0 || estado == 1);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

// ---------- Fundo  ----------
draw_set_alpha(0.82);
draw_set_color(c_black);
draw_rectangle(0, 0, L.largura, L.altura, false);
draw_set_alpha(1);

// ---------- Janela ----------
draw_rectangle_color(L.esq, L.topo, L.dir, L.baixo,
    cor_painel, cor_painel, cor_fundo, cor_fundo, false);

draw_set_alpha(0.05);
draw_set_color(c_white);
for (var yy = L.topo; yy < L.baixo; yy += 6)
{
    draw_line(L.esq, yy, L.dir, yy);
}
draw_set_alpha(1);

var brilho = 0.35 + 0.15 * sin(anim * 0.05);
draw_set_color(cor_borda);
draw_set_alpha(brilho);
draw_rectangle(L.esq - 3, L.topo - 3, L.dir + 3, L.baixo + 3, true);
draw_set_alpha(1);
draw_rectangle(L.esq, L.topo, L.dir, L.baixo, true);

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
draw_text(L.esq + 30, L.topo + 12, "JARDINEIRO - DESAFIO DA SEQUENCIA");
draw_set_color(c_white);
draw_text(L.esq + 30, L.topo + 34, fase.titulo);

for (var i = 0; i < n_fases; i++)
{
    var px = L.dir - 330 + i * 105;
    var py = L.topo + 16;
    var feito = (i < fase_atual) || (i == fase_atual && (estado == 2 || estado == 3));

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

// ---------- SITUACAO / DICA ----------
painel(lx1, L.topo + 70, lx2, L.topo + 170,
       mostrar_dica ? "DICA  (H para esconder)" : "O QUE FAZER", mostrar_dica ? cor_amarelo : cor_ciano);

draw_set_color(mostrar_dica ? cor_amarelo : c_white);
draw_text_ext(lx1 + 14, L.topo + 104, mostrar_dica ? fase.dica : fase.contexto, 17, 420);

// ---------- CANTEIROS + ESTADO ----------
var cpy = L.topo + 178;
painel(lx1, cpy, lx2, L.topo + 378, "OBJETIVO: " + fase.objetivo_txt, cor_verde);

var pw = 100;
var ph = 90;
var pgap = 12;
var np = array_length(plots);

for (var i = 0; i < np; i++)
{
    var pxx = lx1 + 14 + i * (pw + pgap);
    desenhar_canteiro(pxx, cpy + 80, pw, ph, plots[i], i == plot_atual);
    draw_set_color(cor_cinza);
    draw_text(pxx, cpy + 174, "canteiro " + string(i + 1));
}

// ---------- PERSONAGEM (sprite) ----------
var rbx = lx1 + 14 + robo_pos * (pw + pgap) + pw / 2;
var jogador_erro = (estado == 1);
var jogador_ativo = (estado == 4);

// posicao dos pes do personagem (fica logo acima do canteiro)
var pes_y = cpy + 76;

desenhar_jogador(rbx, pes_y, jogador_erro, jogador_ativo);

// semente na mao (tipo 0 = semente)
if (mao_semente)
{
    desenhar_icone(0, rbx - 40, cpy + 52, 16);
}

// ferramenta em uso
if (estado == 4 && passo_exec < n_seq)
{
    desenhar_icone(passos[sequencia[passo_exec]].tipo, rbx + 42, cpy + 52, 18);
}

// ---------- ESTADO DE TODOS OS CANTEIROS ----------
var vx = lx1 + 240;
var vc = vx + 70;       // primeira coluna de valores
draw_set_color(cor_laranja);
draw_text(vx, cpy + 32, "ESTADO");

for (var k = 0; k < np; k++)
{
    draw_set_color(k == plot_atual ? cor_ciano : cor_cinza);
    draw_text(vc + k * 58, cpy + 32, "C" + string(k + 1));
}

var vn = ["cavada", "semeada", "adubada", "regada"];
for (var r = 0; r < 4; r++)
{
    var vy = cpy + 52 + r * 18;
    draw_set_color(cor_cinza);
    draw_text(vx, vy, vn[r]);
    for (var k = 0; k < np; k++)
    {
        var pc = plots[k];
        var val = pc.cavada;
        if (r == 1) val = pc.semeada;
        if (r == 2) val = pc.adubada;
        if (r == 3) val = pc.regada;
        draw_set_color(val ? cor_verde : cor_amarelo);
        draw_text(vc + k * 58, vy, val ? "true" : "false");
    }
}

var vy2 = cpy + 52 + 4 * 18;
draw_set_color(cor_cinza);
draw_text(vx, vy2, "mao");
draw_set_color(mao_semente ? cor_verde : cor_amarelo);
draw_text(vc, vy2, mao_semente ? "semente" : "vazia");
vy2 += 18;

if (fase.precisa_luz)
{
    draw_set_color(cor_cinza);
    draw_text(vx, vy2, "luz");
    draw_set_color(luz_ligada ? cor_verde : cor_amarelo);
    draw_text(vc, vy2, luz_ligada ? "true" : "false");
    vy2 += 18;
}

draw_set_color(cor_cinza);
draw_text(vx, vy2, "flores");
draw_set_color(cor_amarelo);
draw_text(vc, vy2, string(flores_prontas()) + " / " + string(np));

// ---------- SEQUENCIA ----------
var sy1 = L.topo + 386;
painel(lx1, sy1, lx2, L.topo + 548,
       "SUA SEQUENCIA  (" + string(n_seq) + " de " + string(fase.slots) + " passos)", cor_ciano);

for (var i = 0; i < fase.slots; i++)
{
    var rs = rect_slot(L, i);
    var cheio = (i < n_seq);
    var f_ok   = (estado == 4 && i < passo_exec) || (estado == 2 && cheio) || (estado == 3 && cheio) || (estado == 1 && passo_erro >= 0 && i < passo_erro);
    var f_atual = (estado == 4 && i == passo_exec);
    var f_erro  = (estado == 1 && i == passo_erro);
    var hover_s = editavel && cheio && mouse_em(rs, mx, my);

    var fundo = cor_normal;
    var borda = cor_linha;
    if (cheio) borda = passos[sequencia[i]].cor;
    if (f_ok)    { fundo = merge_color(cor_normal, cor_verde, 0.35); borda = cor_verde; }
    if (f_atual) { fundo = cor_hover; borda = c_white; }
    if (f_erro)  { fundo = merge_color(cor_normal, cor_vermelho, 0.4); borda = cor_vermelho; }
    if (hover_s) { fundo = cor_hover; }

    draw_set_color(fundo);
    draw_roundrect_ext(rs[0], rs[1], rs[2], rs[3], 8, 8, false);
    draw_set_color(borda);
    draw_roundrect_ext(rs[0], rs[1], rs[2], rs[3], 8, 8, true);

    if (cheio)
    {
        desenhar_icone(passos[sequencia[i]].tipo, (rs[0] + rs[2]) / 2, (rs[1] + rs[3]) / 2 - 1, 22);
    }

    if (hover_s)
    {
        draw_set_color(cor_vermelho);
        draw_text(rs[2] - 11, rs[1] + 1, "x");
    }

    draw_set_halign(fa_center);
    draw_set_color(cor_cinza);
    draw_text((rs[0] + rs[2]) / 2, rs[3] + 3, string(i + 1));
    draw_set_halign(fa_left);
}

draw_set_color(cor_cinza);
draw_text(lx1 + 14, L.topo + 516, "Clique: remove | BACKSPACE: apaga o ultimo");

// ==========================================================
// COLUNA DIREITA
// ==========================================================
var rx1 = L.esq + 500;
var rx2 = L.dir - 20;

// ---------- FERRAMENTAS ----------
painel(rx1, L.topo + 70, rx2, L.topo + 278, "FERRAMENTAS  (clique ou aperte 1 a " + string(n_ferr) + ")", cor_laranja);

for (var i = 0; i < n_ferr; i++)
{
    var rf = rect_ferr(L, i);
    var hover_f = editavel && mouse_em(rf, mx, my);

    draw_set_alpha(editavel ? 1 : 0.45);

    draw_set_color(hover_f ? cor_hover : cor_normal);
    draw_roundrect_ext(rf[0], rf[1], rf[2], rf[3], 6, 6, false);

    if (hover_f)
    {
        draw_set_color(passos[i].cor);
        draw_rectangle(rf[0], rf[1] + 3, rf[0] + 4, rf[3] - 3, false);
    }

    desenhar_icone(passos[i].tipo, rf[0] + 24, (rf[1] + rf[3]) / 2, 16);

    draw_set_valign(fa_middle);
    draw_set_color(hover_f ? c_white : cor_cinza);
    draw_text(rf[0] + 46, (rf[1] + rf[3]) / 2, string(i + 1) + "   " + passos[i].nome);

    draw_set_halign(fa_right);
    draw_set_color(passos[i].cor);
    draw_text(rf[2] - 12, (rf[1] + rf[3]) / 2, passos[i].codigo);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_alpha(1);
}

// ---------- CODIGO GERADO ----------
var cy1 = L.topo + 286;
painel(rx1, cy1, rx2, L.topo + 548, "SEU CODIGO (aparece sozinho)", cor_verde);

var ly = cy1 + 34;
var lh = 17;
var cx0 = rx1 + 20;

if (estado == 4 && passo_exec < n_seq)
{
    draw_set_alpha(0.22);
    draw_set_color(cor_ciano);
    draw_rectangle(rx1 + 8, ly + (2 + passo_exec) * lh - 1, rx2 - 8, ly + (3 + passo_exec) * lh - 1, false);
    draw_set_alpha(1);
}
if (estado == 1 && passo_erro >= 0)
{
    draw_set_alpha(0.28);
    draw_set_color(cor_vermelho);
    draw_rectangle(rx1 + 8, ly + (2 + passo_erro) * lh - 1, rx2 - 8, ly + (3 + passo_erro) * lh - 1, false);
    draw_set_alpha(1);
}
if ((estado == 2 || estado == 3) && n_seq > 0)
{
    draw_set_alpha(0.16);
    draw_set_color(cor_verde);
    draw_rectangle(rx1 + 8, ly + 2 * lh - 1, rx2 - 8, ly + (2 + n_seq) * lh - 1, false);
    draw_set_alpha(1);
}

desenhar_partes(cx0, ly, [["function ", cor_ciano], ["cuidar_do_jardim", c_white], ["()", c_white]]);
desenhar_partes(cx0, ly + lh, [["{", c_white]]);

if (n_seq == 0)
{
    desenhar_partes(cx0 + 30, ly + 2 * lh, [["// escolha as ferramentas...", cor_cinza]]);
}
for (var i = 0; i < n_seq; i++)
{
    desenhar_partes(cx0 + 30, ly + (2 + i) * lh, [[passos[sequencia[i]].codigo, passos[sequencia[i]].cor]]);
}

desenhar_partes(cx0, ly + (2 + max(n_seq, 1)) * lh, [["}", c_white]]);

// ==========================================================
// RODAPE
// ==========================================================
if (msg != "")
{
    var cor_msg = cor_amarelo;
    var titulo_msg = "";
    if (estado == 1) { cor_msg = cor_vermelho; titulo_msg = "ERROU!  "; }
    if (estado == 2) { cor_msg = cor_verde;    titulo_msg = "ACERTOU!  ";   }

    draw_set_color(cor_msg);
    draw_text_ext(L.esq + 30, L.topo + 558, titulo_msg + msg, 16, 610);
}
else if (estado == 4)
{
    draw_set_color(cor_ciano);
    draw_text_ext(L.esq + 30, L.topo + 562, "O jardineiro esta trabalhando, um passo de cada vez...", 17, 610);
}
else
{
    draw_set_color(cor_cinza);
    draw_text_ext(L.esq + 30, L.topo + 562, "Descubra a ordem e quantos passos usar. Depois clique em EXECUTAR.", 17, 610);
}

// botao LIMPAR
var rl = rect_limpar(L);
var limpar_ativo = editavel && n_seq > 0;
if (!limpar_ativo)
    draw_set_color(cor_botao_off);
else if (mouse_em(rl, mx, my))
    draw_set_color(cor_hover);
else
    draw_set_color(cor_normal);
draw_roundrect_ext(rl[0], rl[1], rl[2], rl[3], 10, 10, false);
draw_set_color(limpar_ativo ? cor_linha : cor_botao_off);
draw_roundrect_ext(rl[0], rl[1], rl[2], rl[3], 10, 10, true);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(limpar_ativo ? c_white : cor_cinza);
draw_text((rl[0] + rl[2]) / 2, (rl[1] + rl[3]) / 2, "LIMPAR");

// botao principal
var rb = rect_botao(L);
var pronto = (n_seq >= 1);
var texto_botao = "EXECUTAR";
var ativo = pronto;

if (estado == 4)
{
    texto_botao = "EXECUTANDO...";
    ativo = false;
}
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

if (ativo && estado == 2)
{
    draw_set_alpha(0.4 + 0.3 * sin(anim * 0.12));
    draw_set_color(c_white);
    draw_roundrect_ext(rb[0], rb[1], rb[2], rb[3], 10, 10, true);
    draw_set_alpha(1);
}

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(ativo ? c_white : cor_cinza);
draw_text((rb[0] + rb[2]) / 2, (rb[1] + rb[3]) / 2, texto_botao);

draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(cor_cinza);
draw_text(L.dir - 30, L.baixo - 18, "ENTER executar  |  1-" + string(n_ferr) + " ferramentas  |  H dica  |  ESC sair");
draw_set_halign(fa_left);

// ==========================================================
// TELA FINAL
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
    draw_text_transformed(L.cx, L.topo + 150, "JARDIM FLORIDO", 2, 2, 0);

    draw_set_color(c_white);
    draw_text(L.cx, L.topo + 210, "PARABENS! VOCE CUIDOU DO JARDIM!");

    draw_set_color(cor_amarelo);
    draw_text(L.cx, L.topo + 260, "Erros: " + string(erros_total));

    var nota = "Perfeito! Voce entendeu a sequencia logica!";
    if (erros_total >= 4) nota = "Muito bem! Com mais pratica voce fica ainda mais rapido.";
    if (erros_total >= 8) nota = "Voce conseguiu! Leia as explicacoes e tente de novo.";

    draw_set_color(cor_ciano);
    draw_text(L.cx, L.topo + 290, nota);

    draw_set_color(cor_cinza);
    draw_text_ext(L.cx, L.topo + 360, "Lembre: um ALGORITMO e uma lista de passos em ordem. Cada passo tem uma regra antes dele. Se a ordem muda, o resultado muda!", 17, 620);

    for (var i = 0; i < 5; i++)
    {
        desenhar_flor(L.cx + (i - 2) * 70, L.topo + 520, 30 + (i % 2) * 12);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);