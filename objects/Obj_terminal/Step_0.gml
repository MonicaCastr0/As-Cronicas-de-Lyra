var perto = distance_to_object(Obj_player) <= 48;

if (!global.desafio_aberto)
{
    if (perto)
    {
        if (keyboard_check_pressed(ord("E")))
        {
            global.desafio_aberto = true;
            Obj_player.pode_mover = false;
        }
    }
}