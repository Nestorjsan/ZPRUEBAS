*&---------------------------------------------------------------------*
*& Include ZSDRXXX0003_PBO
*&---------------------------------------------------------------------*

*&SPWIZARD: OUTPUT MODULE FOR TC 'TC_DETPRO'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: UPDATE LINES FOR EQUIVALENT SCROLLBAR
MODULE tc_detpro_change_tc_attr OUTPUT.
  DESCRIBE TABLE g_ti_detalle LINES tc_detpro-lines.
ENDMODULE.

*&SPWIZARD: OUTPUT MODULE FOR TC 'TC_DETPRO'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: GET LINES OF TABLECONTROL
MODULE tc_detpro_get_lines OUTPUT.
  g_tc_detpro_lines = sy-loopc.
ENDMODULE.

*&SPWIZARD: INPUT MODULE FOR TC 'TC_DETPRO'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: MODIFY TABLE
MODULE tc_detpro_modify INPUT.
  MODIFY g_ti_detalle
    FROM g_es_detalle
    INDEX tc_detpro-current_line.
ENDMODULE.

*&SPWIZARD: INPUT MODUL FOR TC 'TC_DETPRO'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: MARK TABLE
MODULE tc_detpro_mark INPUT.
  DATA: g_tc_detpro_wa2 LIKE LINE OF g_ti_detalle.
  IF tc_detpro-line_sel_mode = 1
  AND g_es_detalle-mark = 'X'.
    LOOP AT g_ti_detalle INTO g_tc_detpro_wa2
      WHERE mark = 'X'.
      g_tc_detpro_wa2-mark = ''.
      MODIFY g_ti_detalle
        FROM g_tc_detpro_wa2
        TRANSPORTING mark.
    ENDLOOP.
  ENDIF.
  MODIFY g_ti_detalle
    FROM g_es_detalle
    INDEX tc_detpro-current_line
    TRANSPORTING mark.
  CALL METHOD g_o_actualizar->del_data. "Borra registros de la tabla ZTSD0002
ENDMODULE.

*&SPWIZARD: INPUT MODULE FOR TC 'TC_DETPRO'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: PROCESS USER COMMAND
MODULE tc_detpro_user_command INPUT.
  ok_code = sy-ucomm.
  PERFORM user_ok_tc USING    'TC_DETPRO'
                              'G_TI_DETALLE'
                              'MARK'
                     CHANGING ok_code.
  sy-ucomm = ok_code.
  CALL METHOD g_o_actualizar->adi_data. "Actualiza la tabla ZTSD0002
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0110 OUTPUT.
  SET PF-STATUS 'GS_STATUS110'.
  SET TITLEBAR 'Factura Clientes'.
ENDMODULE.
