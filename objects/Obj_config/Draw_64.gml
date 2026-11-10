   if (!mostrar_debug) exit;

   var d = diagnostico();
   draw_set_alpha(0.75);
   draw_set_color(c_black);
   draw_rectangle(8, 8, 560, 100, false);
   draw_set_alpha(1);
   draw_set_color(c_white);
   draw_text(16, 14, "ROOM " + room_get_name(room));
   draw_text(16, 34, "JANELA " + string(window_get_width()) + "x" + string(window_get_height()));
   draw_text(16, 54, "GUI " + string(d.gui_w) + "x" + string(d.gui_h) + "   SUPERFICIE " + string(d.sup_w) + "x" + string(d.sup_h));
   draw_text(16, 74, "CAMERA " + string(round(d.cam_w)) + "x" + string(round(d.cam_h)) + "   ZOOM " + string(zoom_da_sala()));