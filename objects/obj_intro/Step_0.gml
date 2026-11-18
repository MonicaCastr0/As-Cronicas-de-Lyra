var _tecla = keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_left);

// ESC pula a introdução inteira
if (keyboard_check_pressed(vk_escape) && estado < 5) estado = 5;

switch (estado) {

    case 0: // fade in inicial
        fade -= 0.02;
        if (fade <= 0) { fade = 0; estado = 1; pausa_t = 30; }
        break;

    case 1: // digitando o parágrafo atual
        var _s = segs[seg];
        if (pausa_t > 0) { pausa_t--; break; }

        if (_tecla) {
            chars = _s.total;                 // completa o parágrafo na hora
        } else {
            var _antes = floor(chars);
            chars += _s.vel;
            var _novo = floor(chars);
            if (_novo > _antes) {
                var _c = string_char_at(_s.linhas[0], 1); // só para evitar erro se vazio
                // pausa extra na pontuação (procura a letra na linha certa)
                var _pos = _novo, _ch = "";
                for (var i = 0; i < array_length(_s.linhas); i++) {
                    var _len = string_length(_s.linhas[i]);
                    if (_pos <= _len) { _ch = string_char_at(_s.linhas[i], _pos); break; }
                    _pos -= _len + 1;
                }
                if (_ch == "." || _ch == "," || _ch == ":") pausa_t = 8;
            }
        }

        if (chars >= _s.total) {
            chars = _s.total;
            estado = 2;
            pausa_t = _s.pausa;
        }
        break;

    case 2: // parágrafo completo parado na tela
        pausa_t--;
        if (pausa_t <= 0 || _tecla) {
            if (seg >= array_length(segs) - 1) estado = 5; // era o último
            else estado = 3;
        }
        break;

    case 3: // some o parágrafo atual
        txt_alpha -= 0.04;
        if (txt_alpha <= 0) {
            seg++;
            chars = 0;
            txt_alpha = 1;
            pausa_t = 20;
            estado = 1;
        }
        break;

    case 5: // fade final e vai para o jogo
        fade += 0.02;
        if (fade >= 1) room_goto(Room2);
        break;
}