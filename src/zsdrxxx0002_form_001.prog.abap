*----------------------------------------------------------------------*
***INCLUDE ZSDRXXX0002_FORM_001.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form MODIFICAR_REGISTRO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM modificar_registro .
  DATA: l_e_monto      TYPE  bapicurr-bapicurr.

  IF  obj_alv_grid IS INITIAL.
    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
      IMPORTING
        e_grid = obj_alv_grid.
  ENDIF.

  IF NOT obj_alv_grid IS INITIAL.
    CALL METHOD obj_alv_grid->check_changed_data.
  ENDIF.

  FIELD-SYMBOLS: <l_fs_datos_tabla> TYPE g_tp_ti_ztsd0005.
  CLEAR g_ti_ztsdmodi.

  LOOP AT g_ti_ztsd0005 ASSIGNING <l_fs_datos_tabla>.

    "g_es_ztsd0005-zsaldo = <l_fs_datos_tabla>-zsaldo.

    READ TABLE g_ti_ztsdcop INTO  g_es_ztsdcop INDEX sy-tabix.
    IF g_es_ztsdcop NE <l_fs_datos_tabla>.

      CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_EXTERNAL'
        EXPORTING
          currency        = 'COP'
          amount_internal = <l_fs_datos_tabla>-zsaldo
        IMPORTING
          amount_external = l_e_monto.

      <l_fs_datos_tabla>-zsaldo  = l_e_monto.          "Saldo


      g_es_ztsdmodi-zcedula = <l_fs_datos_tabla>-zcedula.
      g_es_ztsdmodi-zfecha  = <l_fs_datos_tabla>-zfecha.
      g_es_ztsdmodi-zsaldo  = <l_fs_datos_tabla>-zsaldo.

      "APPEND g_es_ztsdmodi TO g_ti_ztsdmodi.
      MOVE-CORRESPONDING g_es_ztsdmodi TO g_es_ztsdtmp.
      MODIFY ztsd0005 FROM g_es_ztsdtmp ."g_ti_ztsdmodi

    ENDIF.

  ENDLOOP.

  CALL METHOD obj_alv_oo->get_data.
  CLEAR g_ti_ztsdcop.
  g_ti_ztsdcop[] = g_ti_ztsd0005[].

  "MODIFY ztsd0005 FROM g_ti_ztsdmodi.
*  LOOP AT g_ti_ztsd0005 INTO g_es_ztsd0005 .
*
*
*    CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_EXTERNAL'
*      EXPORTING
*        currency        = 'COP'
*        amount_internal = g_es_ztsd0005-zsaldo
*      IMPORTING
*        amount_external = l_e_monto.
*
*    g_es_ztsd0005-zsaldo  = l_e_monto.          "Saldo
*
*    MODIFY ztsd0005 FROM TABLE g_es_ztsd0005.
*
*  ENDLOOP.
  CALL METHOD obj_alv_grid->refresh_table_display.

ENDFORM.
