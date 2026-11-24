// ---------- Movimento ----------
image_speed = 0.15;
velocidade  = 1;
direcao     = choose(-1, 1);        // -1 = esquerda | 1 = direita
x_inicial   = x;                    // ponto central da ronda
alcance     = 96;                   // quantos pixels anda para cada lado
tempo_direcao = irandom_range(90, 240);

sprite_index = spr_robo_jardim_down;

// ---------- Interacao ----------
distancia_interacao = 80;
perto    = false;
cooldown = 0;   // impede o mesmo E de reabrir algo logo depois do dialogo

// ---------- Flags ----------
if (!variable_global_exists("jardim_dialogo_inicial")) global.jardim_dialogo_inicial = false;
if (!variable_global_exists("jardim_dialogo_final"))   global.jardim_dialogo_final   = false;
if (!variable_global_exists("jardim_florido"))         global.jardim_florido         = false;
if (!variable_global_exists("tem_foice"))              global.tem_foice              = false;
if (!variable_global_exists("dialogo_ativo"))          global.dialogo_ativo          = false;
if (!variable_global_exists("desafio_plantar_aberto")) global.desafio_plantar_aberto = false;
if (!variable_global_exists("pausado"))                global.pausado                = false;