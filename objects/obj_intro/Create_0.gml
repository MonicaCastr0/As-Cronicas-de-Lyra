// --- função que quebra o texto em linhas, medindo com a fonte ---
quebrar = function(_txt, _larg) {
    var _linhas = [], _linha = "", _palavra = "";
    var _n = string_length(_txt);
    for (var i = 1; i <= _n + 1; i++) {
        var _c = (i <= _n) ? string_char_at(_txt, i) : " ";
        if (_c == " " || _c == "\n") {
            var _teste = (_linha == "") ? _palavra : _linha + " " + _palavra;
            if (_linha != "" && string_width(_teste) > _larg) {
                array_push(_linhas, _linha);
                _linha = _palavra;
            } else {
                _linha = _teste;
            }
            _palavra = "";
            if (_c == "\n") { array_push(_linhas, _linha); _linha = ""; }
        } else {
            _palavra += _c;
        }
    }
    if (_linha != "") array_push(_linhas, _linha);
    return _linhas;
}

var _branco = make_color_rgb(207, 227, 255);
var _ciano  = make_color_rgb(89, 210, 255);

// vel = letras por frame | pausa = frames que o parágrafo fica na tela depois de digitado
segs = [
    { txt: "Lyra é uma jovem apaixonada por tecnologia e curiosa para saber como as coisas funcionam. Apesar disso, as dificuldades em aprender sobre esse vasto mundo, as comparações com outras pessoas e as cobranças fizeram com que ela começasse a se perguntar sobre sua própria capacidade. Mesmo assim, a jovem permanece firme no que acredita e sempre buscando respostas.", cor: _branco, vel: 0.5, pausa: 120 },
    { txt: "Após um dia cansativo, Lyra retorna para casa e encontra o seu computador ligado, com um jogo em sua tela, chamado CodeLore. Não encontrou informações sobre quem colocou aquele jogo em seu computador ou sequer de quem pertencia aquilo.", cor: _branco, vel: 0.5, pausa: 120 },
    { txt: "Curiosa, ela decide executá-lo, imaginando que se trata de um jogo independente. Entretanto, antes mesmo de o menu principal aparecer, a tela apresenta mensagens incomuns, como se o programa estivesse tentando recuperar informações perdidas.", cor: _branco, vel: 0.5, pausa: 120 },
    { txt: "INICIALIZANDO...\nRECUPERANDO FRAGMENTO...\nCONEXÃO ESTABELECIDA.", cor: _ciano, vel: 0.3, pausa: 100 },
    { txt: "Em seguida, uma mensagem surge na tela:", cor: _branco, vel: 0.5, pausa: 70 },
    { txt: "“Você ainda faz perguntas?”", cor: c_white, vel: 0.25, pausa: 150 },
    { txt: "Confusa, Lyra tenta fechar o programa, mas não consegue. A interface começa a apresentar falhas, símbolos desconhecidos aparecem e a tela é tomada por uma luz intensa. Em poucos instantes, tudo ao seu redor desaparece.", cor: _branco, vel: 0.5, pausa: 120 }
];

// quebra as linhas de cada parágrafo (usa a fonte da história para medir)
draw_set_font(fnt_historia);
var _larg = min(700, display_get_gui_width() * 0.8);
for (var i = 0; i < array_length(segs); i++) {
    var _l = quebrar(segs[i].txt, _larg);
    var _t = -1;
    for (var j = 0; j < array_length(_l); j++) _t += string_length(_l[j]) + 1;
    segs[i].linhas = _l;
    segs[i].total  = _t;   // total de letras a revelar
}

seg       = 0;
chars     = 0;
pausa_t   = 0;
estado    = 0;   // 0 fade in | 1 digitando | 2 parágrafo na tela | 3 some | 5 fade final
fade      = 1;   // preto por cima
txt_alpha = 1;   // opacidade do texto