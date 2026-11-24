if (!dialogo_ativo) exit;

// Ignora a entrada nos primeiros frames
if (entrada_bloqueada > 0) entrada_bloqueada--;

// Texto atual
var texto_atual = falas[indice_fala][1];

// Efeito de digitação
if (caracteres_visiveis < string_length(texto_atual))
{
    tempo_texto += (delta_time / 1000000) * velocidade_texto;

    caracteres_visiveis = min(
        floor(tempo_texto),
        string_length(texto_atual)
    );
}

// Tecla E
if (entrada_bloqueada <= 0 && keyboard_check_pressed(ord("E")))
{
    // Se ainda estiver digitando, completa a frase
    if (caracteres_visiveis < string_length(texto_atual))
    {
        caracteres_visiveis = string_length(texto_atual);
        tempo_texto = caracteres_visiveis;
    }
    else
    {
        // Avança para a próxima fala
        if (indice_fala < array_length(falas) - 1)
        {
            indice_fala++;

            caracteres_visiveis = 0;
            tempo_texto = 0;
        }
        else
        {
            // Finaliza o diálogo
            dialogo_ativo = false;
            global.dialogo_ativo = false;

            if (modo == 0)
            {
                // Antes: abre o desafio da sequência
                global.jardim_dialogo_inicial = true;

                var desafio = instance_find(Obj_desafio_plantar, 0);
                if (desafio != noone)
                {
                    with (desafio) abrir();
                }
            }
            else
            {
                // Depois: entrega a foice e libera o jogador
                global.jardim_dialogo_final = true;
                global.tem_foice = true;

                if (instance_exists(Obj_player)) Obj_player.pode_mover = true;
            }

            instance_destroy();
        }
    }
}