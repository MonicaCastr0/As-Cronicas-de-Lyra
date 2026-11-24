if (!dialogo_ativo) exit;

var gw = display_get_gui_width();
var gh = display_get_gui_height();

// Quem está falando
var fala = falas[indice_fala];
var quem = fala[0];

var nome_exibido = quem;
var cor_nome = cor_jardineiro;
var sprite_personagem = -1;

if (quem == "LYRA")
{
    nome_exibido = "Lyra";
    cor_nome = cor_lyra;
    sprite_personagem = retrato_lyra;
}
else if (quem == "JARDINEIRO")
{
    nome_exibido = "Jardineiro";
    cor_nome = cor_jardineiro;
    sprite_personagem = retrato_jardineiro;
}
else if (quem == "SISTEMA")
{
    nome_exibido = "";
    cor_nome = cor_sistema;
}

// Dimensões da caixa
var margem = 30;

var caixa_x1 = margem;
var caixa_y1 = gh - 155;

var caixa_x2 = gw - margem;
var caixa_y2 = gh - 25;

// Fundo da caixa
draw_set_alpha(0.94);
draw_set_color(make_color_rgb(20, 29, 34));

draw_rectangle(caixa_x1, caixa_y1, caixa_x2, caixa_y2, false);

// Borda dourada
draw_set_alpha(1);
draw_set_color(make_color_rgb(190, 157, 91));

draw_rectangle(caixa_x1, caixa_y1, caixa_x2, caixa_y2, true);

// Nome do personagem
draw_set_color(cor_nome);

draw_text(
    caixa_x1 + 20,
    caixa_y1 + 12,
    nome_exibido
);

// Texto da fala
var texto_atual = fala[1];

var texto_exibido = string_copy(
    texto_atual,
    1,
    caracteres_visiveis
);

draw_set_color(quem == "SISTEMA" ? cor_sistema : c_white);

draw_text_ext(
    caixa_x1 + 20,
    caixa_y1 + 43,
    texto_exibido,
    string_height("A") + 6,   // espaçamento entre linhas = altura da fonte + folga
    gw - 270
);

// Retrato de quem fala
if (sprite_personagem != -1 && sprite_exists(sprite_personagem))
{
    var largura_sprite = sprite_get_width(sprite_personagem);
    var altura_sprite = sprite_get_height(sprite_personagem);

    var escala = min(
        150 / largura_sprite,
        180 / altura_sprite
    );

    draw_sprite_ext(
        sprite_personagem,
        0,
        gw - 125,
        gh - 165,
        escala,
        escala,
        0,
        c_white,
        1
    );
}

// Indicador de avanço
if (caracteres_visiveis >= string_length(texto_atual))
{
    draw_set_color(make_color_rgb(225, 190, 112));

    draw_text(
        gw - 200,
        gh - 52,
        "[ E ]"
    );
}

// Restaura configurações
draw_set_alpha(1);
draw_set_color(c_white);