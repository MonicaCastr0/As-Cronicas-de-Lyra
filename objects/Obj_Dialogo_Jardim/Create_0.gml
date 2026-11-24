// Modo: 0 = antes do desafio | 1 = depois do desafio
// (pode vir de fora: instance_create_depth(0, 0, -10000, Obj_Dialogo_Jardim, { modo: 1 });)
if (!variable_instance_exists(id, "modo")) modo = 0;

// Estado do diálogo
dialogo_ativo = true;
indice_fala = 0;
caracteres_visiveis = 0;
velocidade_texto = 45;
tempo_texto = 0;
entrada_bloqueada = 5;   // ignora o E dos primeiros frames (o mesmo E que abriu o dialogo)

global.dialogo_ativo = true;
if (instance_exists(Obj_player)) Obj_player.pode_mover = false;

// Retratos (troque pelos nomes dos seus sprites)
retrato_lyra = spr_player_frente;
retrato_jardineiro = spr_robo_jardim_frente;

// Cor do nome de cada personagem
cor_lyra = make_color_rgb(0, 200, 240);
cor_jardineiro = make_color_rgb(225, 190, 112);
cor_sistema = make_color_rgb(240, 210, 80);

// ==========================================================
// FALAS: [quem fala, texto]
// ==========================================================

// ---------- MODO 0: antes do desafio ----------
falas_antes = [
    ["JARDINEIRO", "Cavar... regar... Nao. A ordem esta errada."],
    ["LYRA", "Ei... voce esta bem?"],
    ["JARDINEIRO", "Visitante? Faz tempo que ninguem vem aqui. Sou o Jardineiro. Eu cuidava deste lugar... eu acho."],
    ["LYRA", "Voce acha?"],
    ["JARDINEIRO", "Sei o que fazer, mas esqueci a ordem das tarefas."],
    ["JARDINEIRO", "Quando tento comecar, tudo se embaralha e as flores morrem."],
    ["LYRA", "Foi a Grande Queda?"],
    ["JARDINEIRO", "Nao lembro. So do silencio e das flores que pararam de crescer."],
    ["JARDINEIRO", "Voce entende de logica? Pode me ajudar a organizar as tarefas?"],
    ["LYRA", "Nao entendo de jardinagem..."],
    ["JARDINEIRO", "So preciso de alguem que saiba o que vem antes e depois."],
    ["LYRA", "Isso eu sei fazer."]
];

// ---------- MODO 1: depois do desafio ----------
falas_depois = [
    ["JARDINEIRO", "Eu sabia as tarefas, mas esqueci que a ordem muda tudo."],
    ["LYRA", "Se a ordem muda, o resultado tambem."],
    ["JARDINEIRO", "Exatamente! Voce me devolveu uma parte de mim, Lyra."],
    ["LYRA", "Eu so organizei alguns passos."],
    ["JARDINEIRO", "Espere... Estou lembrando de algo. Alguem interferia nos Automatos antes da Queda."],
    ["JARDINEIRO", "Essa pessoa repetia o mesmo erro varias vezes."],
    ["LYRA", "Quem?"],
    ["JARDINEIRO", "Os registros estao danificados. So consigo ler um nome: NullError."],
    ["LYRA", "NullError..."],
    ["LYRA", "E aquele caminho bloqueado pelo mato? Para onde leva?"],
    ["JARDINEIRO", "Ao Altar das Arquitetas. Nunca estive la, fui designado apenas a este jardim."],
    ["LYRA", "Preciso chegar la. Como posso passar?"],
    ["JARDINEIRO", "Leve esta foice. Ela pode cortar o mato mais denso."],
    ["LYRA", "Mas essa e sua ferramenta..."],
    ["JARDINEIRO", "Voce restaurou meu jardim. Agora abra seu proprio caminho."],
    ["SISTEMA", "Voce obteve a Foice! Ela corta o mato que bloqueia passagens."],
    ["LYRA", "Obrigada, Jardineiro!"],
    ["JARDINEIRO", "Volte quando quiser. As flores estarao aqui. E eu tambem... em ordem."]
];

falas = (modo == 0) ? falas_antes : falas_depois;