*&---------------------------------------------------------------------*
*& Include          ZSDRXXX0002_CLS_001
*&---------------------------------------------------------------------*
CLASS cls_alv_oo DEFINITION.

  PUBLIC SECTION.

    METHODS: get_data,
      show_alv,
      set_fieldcat.

ENDCLASS.


CLASS cls_alv_oo IMPLEMENTATION.
  METHOD: get_data.
    IF pa_ced IS NOT INITIAL.
      SELECT  a~zcedula       "Cedula del cliente
              b~znombre       "Nombre
              a~zfecha        "Fecha
              a~zsaldo        "Saldo
              b~zestado       "Estado
        FROM ztsd0005 AS a
        INNER JOIN ztsd0001 AS b
          ON a~zcedula = b~zcedula
        INTO TABLE g_ti_ztsd0005
         WHERE a~zcedula EQ pa_ced.


      "Departamento y ciudad del cliente
      SELECT a~zcedula       "Cedula del cliente
             b~zdepto          "Departamento
             b~zciudad         "Ciudad
             b~zdescri          "Nombre ciudad
      FROM ztsd0001 AS a
      INNER JOIN ztsd0003 AS b
        ON a~zdepto = b~zdepto
           AND a~zciudad = b~zciudad
      INTO TABLE g_ti_ztsd0003
       WHERE a~zcedula EQ pa_ced.
    ELSE.
*      SELECT  zcedula       "Cedula del cliente
*              zfecha        "Fecha
*              zsaldo        "Saldo
*          INTO TABLE g_ti_ztsd0005
*        FROM ztsd0005.
      SELECT a~zcedula       "Cedula del cliente
             b~znombre       "Nombre
             a~zfecha        "Fecha
             a~zsaldo        "Saldo
             b~zestado       "Estado
       FROM ztsd0005 AS a
       INNER JOIN ztsd0001 AS b
         ON a~zcedula = b~zcedula
       INTO TABLE g_ti_ztsd0005.

      "Departamento y ciudad del cliente
      SELECT a~zcedula       "Cedula del cliente
             b~zdepto          "Departamento
             b~zciudad         "Ciudad
             b~zdescri          "Nombre ciudad
      FROM ztsd0001 AS a
      INNER JOIN ztsd0003 AS b
        ON a~zdepto = b~zdepto
           AND a~zciudad = b~zciudad
      INTO TABLE g_ti_ztsd0003.
    ENDIF.


      FIELD-SYMBOLS: <l_fs_datos_tabla> TYPE g_tp_ti_ztsd0005.

      LOOP AT g_ti_ztsd0005 ASSIGNING <l_fs_datos_tabla>.
        "g_es_ztsd0005-zestado = <l_fs_datos_tabla>-zestado.
        IF <l_fs_datos_tabla>-g_c_estado  EQ 'A'.
          <l_fs_datos_tabla>-g_c_estado = '@08@'.
        ELSE.
          <l_fs_datos_tabla>-g_c_estado = '@0A@'.
        ENDIF.

      ENDLOOP.



      g_ti_ztsdcop[] = g_ti_ztsd0005[].
    ENDMETHOD.

    METHOD: set_fieldcat.

      DATA wa_fcat TYPE lvc_s_fcat.

      CLEAR: wa_fcat.
      wa_fcat-fieldname = 'SEL'. "Nombre del campo en IT.
      wa_fcat-outputlen = 5.
      wa_fcat-coltext = 'Sel'.
      wa_fcat-checkbox = 'X'.
      wa_fcat-edit = 'X'.
      APPEND wa_fcat TO g_ti_lvc_s_fcat.

      CLEAR: wa_fcat.
      wa_fcat-fieldname = 'ZCEDULA'. "Nombre del campo en IT.
      wa_fcat-outputlen = 15.
      wa_fcat-emphasize = 'X'.
      wa_fcat-coltext = TEXT-002.
      APPEND wa_fcat TO g_ti_lvc_s_fcat .

      CLEAR: wa_fcat.
      wa_fcat-fieldname = 'ZNOMBRE'. "Nombre del campo en IT.
      wa_fcat-outputlen = 30.
      wa_fcat-coltext = TEXT-005.
      "wa_fcat-no_out = 'X'.
      APPEND wa_fcat TO g_ti_lvc_s_fcat .

      CLEAR: wa_fcat.
      wa_fcat-fieldname = 'ZFECHA'.
      "wa_fcat-ref_table = ''.
      "wa_fcat-ref_field = ''.
      wa_fcat-outputlen = 10.
      wa_fcat-coltext = TEXT-003.
      APPEND wa_fcat TO g_ti_lvc_s_fcat .

      CLEAR: wa_fcat.
      wa_fcat-fieldname = 'ZSALDO'.
      "wa_fcat-ref_table = 'MARA'.
      "wa_fcat-ref_field = 'MEINS'.
      wa_fcat-outputlen = 18.
      wa_fcat-roundfield = 'X'.
      wa_fcat-coltext = TEXT-004.
      "wa_fcat-do_sum = 'X'.
      wa_fcat-edit = 'X'.
      APPEND wa_fcat TO g_ti_lvc_s_fcat .

      CLEAR: wa_fcat.
      wa_fcat-fieldname = 'G_C_ESTADO'.
      "wa_fcat-ref_table = ''.
      "wa_fcat-ref_field = ''.
      wa_fcat-outputlen = 10.
      wa_fcat-coltext = TEXT-006.
      APPEND wa_fcat TO g_ti_lvc_s_fcat .



*CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
* EXPORTING
**   I_BUFFER_ACTIVE              =
*   I_STRUCTURE_NAME             = 'MARA'
**   I_CLIENT_NEVER_DISPLAY       = 'X'
**   I_BYPASSING_BUFFER           =
**   I_INTERNAL_TABNAME           =
*  CHANGING
*    ct_fieldcat                  = it_fcat
* EXCEPTIONS
*   INCONSISTENT_INTERFACE       = 1
*   PROGRAM_ERROR                = 2
*   OTHERS                       = 3.
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.


    ENDMETHOD.

    METHOD: show_alv.

      DATA: vl_layout TYPE lvc_s_layo.
      vl_layout-zebra = 'X'.

      IF vg_container IS NOT BOUND.

        CREATE OBJECT vg_container
          EXPORTING
            container_name = 'CC_REPSAL'.

        CREATE OBJECT obj_alv_grid
          EXPORTING
            i_parent = vg_container.

        CALL METHOD set_fieldcat.

        CREATE OBJECT obj_alv_events.
        SET HANDLER obj_alv_events->handle_double_click FOR obj_alv_grid.

        CALL METHOD obj_alv_grid->set_table_for_first_display
          EXPORTING
            is_layout       = vl_layout
          CHANGING
            it_fieldcatalog = g_ti_lvc_s_fcat
            it_outtab       = g_ti_ztsd0005.
      ELSE.
        CALL METHOD obj_alv_grid->refresh_table_display.
      ENDIF.

    ENDMETHOD.

ENDCLASS.
