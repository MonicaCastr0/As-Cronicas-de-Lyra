distancia_interacao = 80;
perto = false;
cooldown = 0;   // impede o mesmo E de reabrir algo logo depois do dialogo

// ---------- Flags da interacao com o Jardineiro ----------
if (!variable_global_exists("jardim_dialogo_inicial")) global.jardim_dialogo_inicial = false;
if (!variable_global_exists("jardim_dialogo_final"))   global.jardim_dialogo_final = false;
if (!variable_global_exists("tem_foice"))              global.tem_foice = false;
if (!variable_global_exists("dialogo_ativo"))          global.dialogo_ativo = false;
if (!variable_global_exists("desafio_plantar_aberto")) global.desafio_plantar_aberto = false;