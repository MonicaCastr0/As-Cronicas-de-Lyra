// ==========================================================
// DRAW GUI  -  Desafio Final: NULLERROR  v2
// (use o evento "Draw GUI", pois tudo usa coordenadas da GUI)
// ==========================================================
if (!global.chefe_aberto) exit;

var ox = (shake > 0) ? irandom_range(-shake, shake) * 0.5 : 0;
var L  = get_layout(ox);
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var montando = (etapa == 1 || etapa == 2 || etapa == 4);
var chefe_na_tela = (etapa >= 3);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);

// ---------- Fundo escurecido ----------
draw_set_alpha(0.85);
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
draw_set_color(chefe_na_tela ? cor_null : cor_borda);
draw_set_alpha(brilho);
draw_rectangle(L.esq - 3, L.topo - 3, L.dir + 3, L.baixo + 3, true);
draw_set_alpha(1);
draw_rectangle(L.esq, L.topo, L.dir, L.baixo, true);

// ==========================================================
// CABECALHO (simples)
// ==========================================================
var rotulos = ["INTRODUCAO", "TREINO 1/2  -  NA MAO", "TREINO 2/2  -  REPETIR", "CHEFE  -  OBSERVE", "CHEFE  -  NULLERROR", "VITORIA"];

draw_set_color(c_white);
draw_text(L.esq + 30, L.topo + 14, "CODELORE  //  " + rotulos[etapa]);

draw_set_halign(fa_right);
draw_set_color(cor_cinza);
draw_text(L.dir - 30, L.topo + 14, "ESC - sair");
draw_set_halign(fa_left);

draw_set_color(cor_linha);
draw_line(L.esq + 20, L.topo + 44, L.dir - 20, L.topo + 44);

// ==========================================================
// ARENA
// ==========================================================
painel(L.esq + 30, L.topo + 52, L.dir - 30, L.topo + 250, "", cor_null);

var gy  = L.topo + 232;
var lxp = L.esq + 190;
var bx  = L.esq + 690;
var prog  = clamp(exec_timer / exec_dur, 0, 0.999);
var golpe = sin(prog * pi);
var bob = sin(anim * 0.08) * 3;

var lyra_x = lxp;
var boss_x = bx;
if (chefe_na_tela && exec_lyra_atual == "ATAQUE")   lyra_x += golpe * 70;
if (chefe_na_tela && exec_evento_atual == "ATAQUE") boss_x -= golpe * 70;

// ---------- contador (canto esquerdo) ----------
draw_set_color(cor_amarelo);
if (!chefe_na_tela)
{
    draw_text(L.esq + 46, L.topo + 62, "TOCHAS  " + string(tochas_acesas) + " / " + string(tochas_total));
}
else if (exec_ativo)
{
    draw_text(L.esq + 46, L.topo + 62, "CICLO  " + string(min(exec_ciclo + 1, exec_ciclos)) + " / " + string(exec_ciclos));
}

// ---------- Lyra ----------
draw_set_alpha(0.3);
draw_set_color(c_black);
draw_ellipse(lyra_x - 32, gy - 6, lyra_x + 32, gy + 6, false);
draw_set_alpha(1);

var acao_lyra = (exec_ativo) ? exec_lyra_atual : "";
desenhar_lyra(lyra_x, gy, acao_lyra, prog);

// efeitos quando nao ha sprite proprio para a acao
if (acao_lyra == "DEFESA" && spr_player_combat == -1)
{
    draw_set_alpha(0.35);
    draw_set_color(cor_ciano);
    draw_circle(lyra_x + 30, gy - lyra_altura * 0.5, 38, false);
    draw_set_alpha(1);
    draw_circle(lyra_x + 30, gy - lyra_altura * 0.5, 38, true);
}
if (acao_lyra == "ATAQUE" && spr_lyra_ataque == -1)
{
    draw_set_color(c_white);
    draw_line_width(lyra_x + 24, gy - lyra_altura * 0.5, lyra_x + 84, gy - lyra_altura * 0.7, 5);
}
if (exec_resultado == "erro" && exec_evento_atual == "ATAQUE" && exec_timer > 0 && exec_timer < 12)
{
    draw_set_alpha(0.45);
    draw_set_color(cor_vermelho);
    draw_roundrect_ext(lyra_x - 40, gy - lyra_altura - 6, lyra_x + 40, gy, 8, 8, false);
    draw_set_alpha(1);
}

// cartao com a acao que a Lyra esta fazendo
if (exec_ativo && exec_lyra_atual != "")
{
    desenhar_card(lxp, L.topo + 62, 130, 26, nome_acao(exec_lyra_atual), cor_acao(exec_lyra_atual), true);
}

// ---------- Tochas (treinos) ----------
if (!chefe_na_tela)
{
    for (var k = 0; k < tochas_total; k++)
    {
        var tx = L.esq + 480 + (k + 0.5) * (360 / tochas_total);
        var acesa = (k < tochas_acesas);

        draw_set_color(cor_linha);
        draw_rectangle(tx - 4, gy - 44, tx + 4, gy, false);

        if (acesa)
        {
            var recem = (k == tochas_acesas - 1 && exec_ativo && exec_timer > 0 && exec_timer < 14);
            var fr = 12 + sin(anim * 0.3 + k) * 2 + (recem ? 6 : 0);

            draw_set_alpha(0.25);
            draw_set_color(cor_laranja);
            draw_circle(tx, gy - 56, fr + 14, false);
            draw_set_alpha(1);
            draw_set_color(cor_laranja);
            draw_circle(tx, gy - 56, fr, false);
            draw_set_color(cor_amarelo);
            draw_circle(tx, gy - 54, fr * 0.55, false);
        }
        else
        {
            draw_set_color(cor_normal);
            draw_circle(tx, gy - 54, 9, false);
            draw_set_color(cor_linha);
            draw_circle(tx, gy - 54, 9, true);
        }
    }
}

// ---------- NullError (chefe) ----------
if (chefe_na_tela)
{
    var boss_alpha = (etapa >= 4) ? 0.35 + 0.65 * (corrupcao / 100) : 1;

    draw_set_alpha(0.3);
    draw_set_color(c_black);
    draw_ellipse(boss_x - 56, gy - 6, boss_x + 56, gy + 6, false);

    draw_set_alpha(boss_alpha);
    draw_set_color(cor_null_escuro);
    draw_rectangle(boss_x - 48, gy - 112 + bob, boss_x + 48, gy - 8, false);
    for (var s = 0; s < 4; s++)
    {
        var sy = gy - 112 + bob + s * 26;
        var so = sin(anim * 0.2 + s * 1.7) * 7;
        draw_set_color((s mod 2 == 0) ? cor_null : cor_null_escuro);
        draw_rectangle(boss_x - 48 + so, sy, boss_x + 48 + so, sy + 12, false);
    }
    draw_set_color(c_white);
    draw_rectangle(boss_x - 30, gy - 92 + bob, boss_x - 12, gy - 80 + bob, false);
    draw_rectangle(boss_x + 12, gy - 92 + bob, boss_x + 30, gy - 80 + bob, false);
    draw_set_color(cor_vermelho);
    draw_rectangle(boss_x - 22, gy - 52 + bob, boss_x + 22, gy - 44 + bob, false);
    draw_set_alpha(1);

    if (exec_resultado == "ok" && exec_lyra_atual == "ATAQUE" && exec_timer > 0 && exec_timer < 10)
    {
        draw_set_alpha(0.6);
        draw_set_color(c_white);
        draw_rectangle(boss_x - 48, gy - 112, boss_x + 48, gy - 8, false);
        draw_set_alpha(1);
    }

    // padrao do NullError (3 cartoes) + barra de corrupcao
    for (var i = 0; i < 3; i++)
    {
        var dest = (exec_ativo && exec_passo == i && exec_evento_atual != "");
        desenhar_card(bx + (i - 1) * 92, L.topo + 62, 84, 26, padrao_boss[i], cor_acao(padrao_boss[i]), dest);
    }

    draw_set_color(cor_normal);
    draw_rectangle(bx - 100, L.topo + 98, bx + 100, L.topo + 108, false);
    draw_set_color(cor_null);
    draw_rectangle(bx - 100, L.topo + 98, bx - 100 + 200 * (corrupcao / 100), L.topo + 108, false);
    draw_set_color(cor_linha);
    draw_rectangle(bx - 100, L.topo + 98, bx + 100, L.topo + 108, true);
}

// ---------- resultado do passo (curto, no centro da arena) ----------
if (exec_ativo && exec_resultado != "" && exec_timer > 0)
{
    var rt = "";
    var rc = c_white;
    if (exec_resultado == "ok")
    {
        if (exec_evento_atual == "TOCHA")        rt = "ACESA!";
        else if (exec_lyra_atual == "ATAQUE")    rt = "CONTRA-ATAQUE!";
        else                                     rt = "DEFENDEU!";
        rc = cor_verde;
    }
    else if (exec_resultado == "erro")
    {
        rt = (exec_evento_atual == "ATAQUE") ? "ATINGIDA!" : "ERROU";
        rc = cor_vermelho;
    }
    else if (exec_resultado == "sem_alvo")
    {
        rt = "SEM ALVO";
        rc = cor_cinza;
    }
    draw_set_halign(fa_center);
    draw_set_color(rc);
    draw_text(L.esq + 450, L.topo + 66, rt);
    draw_set_halign(fa_left);
}

// ==========================================================
// MONTAGEM (esquerda)
// ==========================================================
painel(L.esq + 30, L.topo + 262, L.esq + 524, L.topo + 470, usa_loop ? "MONTE A REGRA" : "MONTE A SEQUENCIA", cor_verde);

// ---------- acoes disponiveis ----------
if (!montando) draw_set_alpha(0.35);
for (var i = 0; i < array_length(acoes_atuais); i++)
{
    var rp = rect_paleta(L, i);
    var hover = montando && !exec_ativo && mouse_em(rp, mx, my);
    var ca = cor_acao(acoes_atuais[i]);

    draw_set_color(merge_color(cor_normal, ca, hover ? 0.5 : 0.2));
    draw_roundrect_ext(rp[0], rp[1], rp[2], rp[3], 8, 8, false);
    draw_set_color(ca);
    draw_roundrect_ext(rp[0], rp[1], rp[2], rp[3], 8, 8, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text((rp[0] + rp[2]) / 2, (rp[1] + rp[3]) / 2, nome_acao(acoes_atuais[i]));
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// ---------- REPETIR [-] n [+] VEZES ----------
if (usa_loop)
{
    var rm  = rect_menos(L);
    var rpl = rect_mais(L);

    draw_set_color(cor_amarelo);
    draw_text(L.esq + 44, L.topo + 353, "REPETIR");
    desenhar_botao(rm,  "-", montando && !exec_ativo, mx, my, cor_normal, cor_hover);
    desenhar_botao(rpl, "+", montando && !exec_ativo, mx, my, cor_normal, cor_hover);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text((rm[2] + rpl[0]) / 2, (rm[1] + rm[3]) / 2, string(repeticoes));
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_color(cor_amarelo);
    draw_text(L.esq + 256, L.topo + 353, "VEZES");

    // colchete lateral: o que esta "dentro" do REPETIR
    draw_line_width(L.esq + 36, L.topo + 346, L.esq + 36, L.topo + 442, 2);
    draw_line_width(L.esq + 36, L.topo + 346, L.esq + 41, L.topo + 346, 2);
    draw_line_width(L.esq + 36, L.topo + 442, L.esq + 41, L.topo + 442, 2);
}

// ---------- espacos da sequencia ----------
for (var i = 0; i < tam_seq; i++)
{
    var rs = rect_slot(L, i);
    var cheio = (i < array_length(sequencia));
    var cs = cheio ? cor_acao(sequencia[i]) : cor_linha;
    var hv = montando && !exec_ativo && cheio && mouse_em(rs, mx, my);

    draw_set_color(cheio ? merge_color(cor_normal, cs, hv ? 0.55 : 0.3) : cor_fundo);
    draw_roundrect_ext(rs[0], rs[1], rs[2], rs[3], 8, 8, false);
    draw_set_color(cs);
    draw_roundrect_ext(rs[0], rs[1], rs[2], rs[3], 8, 8, true);

    if (exec_ativo && exec_modo == "run" && exec_passo == i)
    {
        draw_set_color(cor_amarelo);
        draw_roundrect_ext(rs[0] - 2, rs[1] - 2, rs[2] + 2, rs[3] + 2, 8, 8, true);
    }

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(cheio ? c_white : cor_linha);
    draw_text((rs[0] + rs[2]) / 2, (rs[1] + rs[3]) / 2, cheio ? nome_acao(sequencia[i]) : "?");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
draw_set_alpha(1);

// ==========================================================
// CODIGO (direita)
// ==========================================================
painel(L.esq + 540, L.topo + 262, L.dir - 30, L.topo + 470, "CODIGO", cor_ciano);
var linhas = montar_codigo();
desenhar_codigo(L.esq + 556, L.topo + 300, linhas, codigo_destaque, 300);

// ==========================================================
// MENSAGEM + BOTOES
// ==========================================================
var texto_msg = (msg != "") ? msg : instrucao;
draw_set_color((msg != "") ? msg_cor : cor_cinza);
draw_text_ext(L.esq + 30, L.topo + 484, texto_msg, 18, 460);

if (montando)
{
    var pronto = (array_length(sequencia) >= tam_seq) && !exec_ativo;
    desenhar_botao(rect_limpar(L), "LIMPAR", (array_length(sequencia) > 0) && !exec_ativo, mx, my, cor_normal, cor_hover);
    desenhar_botao(rect_executar(L), exec_ativo ? "EXECUTANDO..." : "EXECUTAR", pronto, mx, my, cor_botao, cor_botao_hover);
}

// ==========================================================
// VITORIA
// ==========================================================
if (etapa == 5)
{
    draw_set_alpha(0.93);
    draw_set_color(c_black);
    draw_rectangle(L.esq + 2, L.topo + 46, L.dir - 2, L.baixo - 80, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(cor_verde);
    draw_text_transformed(L.cx, L.topo + 95, "NULLERROR DERROTADO", 2, 2, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    painel(L.cx - 230, L.topo + 140, L.cx + 230, L.topo + 290, "O LOOP QUE VOCE ESCREVEU", cor_verde);
    desenhar_codigo(L.cx - 210, L.topo + 178, montar_codigo(), -1, 420);

    draw_set_halign(fa_center);
    draw_set_color(cor_amarelo);
    draw_text(L.cx, L.topo + 316, "Uma estrutura REPETIR no lugar de escrever tudo varias vezes.");
    draw_set_color(cor_ciano);
    draw_text_ext(L.cx, L.topo + 350, "NullError repetia a corrupcao. Lyra aprendeu a repetir tambem... mas repetindo a reconstrucao.", 20, 700);
    draw_set_halign(fa_left);

    desenhar_botao(rect_executar(L), "FECHAR", true, mx, my, cor_botao, cor_botao_hover);
}

// ==========================================================
// DIALOGO (por cima de tudo)
// ==========================================================
if (em_dialogo)
{
    draw_set_alpha(0.55);
    draw_set_color(c_black);
    draw_rectangle(L.esq, L.topo, L.dir, L.baixo, false);
    draw_set_alpha(1);

    var dx1 = L.esq + 60;
    var dx2 = L.dir - 60;
    var dy1 = L.baixo - 210;
    var dy2 = L.baixo - 70;

    painel(dx1, dy1, dx2, dy2, "", cor_ciano);
    draw_set_color(cor_ciano);
    draw_rectangle(dx1, dy1, dx2, dy1 + 3, false);

    var fala = dialogo[dialogo_idx];
    var cor_nome = cor_cinza;
    if (fala[0] == "LYRA")      cor_nome = cor_ciano;
    if (fala[0] == "NULLERROR") cor_nome = cor_null;

    draw_set_color(cor_nome);
    draw_text(dx1 + 24, dy1 + 16, fala[0]);
    draw_set_color(c_white);
    draw_text_ext(dx1 + 24, dy1 + 44, fala[1], 20, dx2 - dx1 - 48);

    draw_set_halign(fa_right);
    draw_set_color(cor_cinza);
    draw_set_alpha(0.5 + 0.5 * abs(sin(anim * 0.06)));
    draw_text(dx2 - 20, dy2 - 28, "ENTER / clique para continuar");
    draw_set_alpha(1);
    draw_set_halign(fa_left);
}

// ---------- Reset ----------
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
