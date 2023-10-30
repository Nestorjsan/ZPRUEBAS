*&---------------------------------------------------------------------*
*& Include ZSDRXXX0003_PBO
*&---------------------------------------------------------------------*

*&SPWIZARD: OUTPUT MODULE FOR TC 'TC_DETPRO'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: UPDATE LINES FOR EQUIVALENT SCROLLBAR
MODULE TC_DETPRO_CHANGE_TC_ATTR OUTPUT.
  DESCRIBE TABLE G_TI_DETALLE LINES TC_DETPRO-lines.
ENDMODULE.

*&SPWIZARD: OUTPUT MODULE FOR TC 'TC_DETPRO'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: GET LINES OF TABLECONTROL
MODULE TC_DETPRO_GET_LINES OUTPUT.
  G_TC_DETPRO_LINES = SY-LOOPC.
ENDMODULE.

*&SPWIZARD: INPUT MODULE FOR TC 'TC_DETPRO'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: MODIFY TABLE
MODULE TC_DETPRO_MODIFY INPUT.
  MODIFY G_TI_DETALLE
    FROM G_ES_DETALLE
    INDEX TC_DETPRO-CURRENT_LINE.
ENDMODULE.

*&SPWIZARD: INPUT MODUL FOR TC 'TC_DETPRO'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: MARK TABLE
MODULE TC_DETPRO_MARK INPUT.
  DATA: g_TC_DETPRO_wa2 like line of G_TI_DETALLE.
    if TC_DETPRO-line_sel_mode = 1
    and G_ES_DETALLE-MARK = 'X'.
     loop at G_TI_DETALLE into g_TC_DETPRO_wa2
       where MARK = 'X'.
       g_TC_DETPRO_wa2-MARK = ''.
       modify G_TI_DETALLE
         from g_TC_DETPRO_wa2
         transporting MARK.
     endloop.
  endif.
  MODIFY G_TI_DETALLE
    FROM G_ES_DETALLE
    INDEX TC_DETPRO-CURRENT_LINE
    TRANSPORTING MARK.
ENDMODULE.

*&SPWIZARD: INPUT MODULE FOR TC 'TC_DETPRO'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: PROCESS USER COMMAND
MODULE TC_DETPRO_USER_COMMAND INPUT.
  OK_CODE = SY-UCOMM.
  PERFORM USER_OK_TC USING    'TC_DETPRO'
                              'G_TI_DETALLE'
                              'MARK'
                     CHANGING OK_CODE.
  SY-UCOMM = OK_CODE.
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
