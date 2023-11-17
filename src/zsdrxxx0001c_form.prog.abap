*&---------------------------------------------------------------------*
*& Include          ZSDRXXX0001_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form F_CONSULTA_DATOS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_consulta_datos .

  DATA:
    l_ti_data TYPE g_tp_tt_data.

  IF pa_ced IS NOT INITIAL.

    SELECT  zcedula       "Cedula del cliente
            znombre       "Nombre del cliente
            zdireccion    "Direccion
            ztelefono     "Telefono
            zdepto        "Departamento
            zciudad       "Ciudad
            zestado       "Estado
           INTO TABLE g_ti_data
         FROM ztsd0001
         WHERE zcedula EQ pa_ced.
  ELSE.
    SELECT  zcedula       "Cedula del cliente
            znombre       "Nombre del cliente
            zdireccion    "Direccion
            ztelefono     "Telefono
            zdepto        "Departamento
            zciudad       "Ciudad
            zestado       "Estado
           INTO TABLE g_ti_data
         FROM ztsd0001.
  ENDIF.

  l_ti_data = g_ti_data.

  IF l_ti_data IS NOT INITIAL.
    "Buscamos el departamento
    SELECT zdepto zciudad zdescri
       FROM ztsd0003
       INTO TABLE g_ti_ztsd0003
       FOR ALL ENTRIES IN l_ti_data
       WHERE zdepto  EQ l_ti_data-zdepto
           AND zciudad EQ g_cte_cero.


    "Buscamos la ciudad
    SELECT zdepto zciudad zdescri
       FROM ztsd0003
       INTO TABLE g_ti_ztsdciudad
       FOR ALL ENTRIES IN l_ti_data
       WHERE zdepto EQ l_ti_data-zdepto
        AND zciudad EQ l_ti_data-zciudad.


    "Ingresamos los datos al reporte
    FIELD-SYMBOLS: <l_fs_datos_tabla> TYPE g_tp_ti_data.

    LOOP AT g_ti_data ASSIGNING <l_fs_datos_tabla>.

      g_es_datos_alv-zcedula     = <l_fs_datos_tabla>-zcedula.
      g_es_datos_alv-znombre     = <l_fs_datos_tabla>-znombre.
      g_es_datos_alv-zdireccion  = <l_fs_datos_tabla>-zdireccion.
      g_es_datos_alv-ztelefono   = <l_fs_datos_tabla>-ztelefono.
      g_es_datos_alv-zdepto      = <l_fs_datos_tabla>-zdepto.
      g_es_datos_alv-zciudad     = <l_fs_datos_tabla>-zciudad.
      g_es_datos_alv-zestado     = <l_fs_datos_tabla>-zestado.

      READ TABLE g_ti_ztsd0003 INTO g_es_ztsd0003        "#EC CI_STDSEQ
           WITH KEY zdepto = g_es_datos_alv-zdepto.
      IF sy-subrc = 0.
        g_es_datos_alv-zdesdto = g_es_ztsd0003-zdescri.
      ENDIF.

      READ TABLE g_ti_ztsdciudad INTO g_es_ztsdciudad    "#EC CI_STDSEQ
                 WITH KEY zdepto  = g_es_datos_alv-zdepto
                          zciudad = g_es_datos_alv-zciudad.
      IF sy-subrc = 0.
        g_es_datos_alv-zdesciu = g_es_ztsdciudad-zdescri.
      ENDIF.

      APPEND g_es_datos_alv TO g_ti_datos_alv.

    ENDLOOP.

    SORT g_ti_datos_alv BY zcedula.
    "WRITE: / 'pare'.



  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_build_fieldcatalog .
  g_es_fieldcat-fieldname   = 'ZCEDULA'.
  g_es_fieldcat-seltext_m   = TEXT-002.
  g_es_fieldcat-col_pos     = 0.
  g_es_fieldcat-outputlen   = 15.
  "g_es_fieldcat-edit        = ''.
  "g_es_fieldcat-emphasize   = ''.
  "g_es_fieldcat-key         = 'X'.
  APPEND g_es_fieldcat TO g_ti_fieldcat.

  g_es_fieldcat-fieldname   = 'ZNOMBRE'.
  g_es_fieldcat-seltext_m   = TEXT-003.
  g_es_fieldcat-col_pos     = 1.
  g_es_fieldcat-outputlen   = 30.
  "g_es_fieldcat-edit        = ''.
  "g_es_fieldcat-emphasize   = ''.
  "g_es_fieldcat-key         = 'X'.
  APPEND g_es_fieldcat TO g_ti_fieldcat.

  g_es_fieldcat-fieldname   = 'ZDIRECCION'.
  g_es_fieldcat-seltext_m   = TEXT-004.
  g_es_fieldcat-col_pos     = 2.
  g_es_fieldcat-outputlen   = 40.
  "g_es_fieldcat-edit        = ''.
  "g_es_fieldcat-emphasize   = ''.
  "g_es_fieldcat-key         = 'X'.
  APPEND g_es_fieldcat TO g_ti_fieldcat.


  g_es_fieldcat-fieldname   = 'ZTELEFONO'.
  g_es_fieldcat-seltext_m   = TEXT-005.
  g_es_fieldcat-col_pos     = 3.
  g_es_fieldcat-outputlen   = 15.
  "g_es_fieldcat-edit        = ''.
  "g_es_fieldcat-emphasize   = ''.
  "g_es_fieldcat-key         = 'X'.
  APPEND g_es_fieldcat TO g_ti_fieldcat.


  g_es_fieldcat-fieldname   = 'ZDEPTO'.
  g_es_fieldcat-seltext_m   = TEXT-006.
  g_es_fieldcat-col_pos     = 4.
  g_es_fieldcat-outputlen   = 3.
  "g_es_fieldcat-edit        = ''.
  "g_es_fieldcat-emphasize   = ''.
  "g_es_fieldcat-key         = 'X'.
  APPEND g_es_fieldcat TO g_ti_fieldcat.

  g_es_fieldcat-fieldname   = 'ZDESDTO'.
  g_es_fieldcat-seltext_m   = TEXT-007.
  g_es_fieldcat-col_pos     = 5.
  g_es_fieldcat-outputlen   = 40.
  "g_es_fieldcat-edit        = ''.
  "g_es_fieldcat-emphasize   = ''.
  "g_es_fieldcat-key         = 'X'.
  APPEND g_es_fieldcat TO g_ti_fieldcat.

  g_es_fieldcat-fieldname   = 'ZCIUDAD'.
  g_es_fieldcat-seltext_m   = TEXT-008.
  g_es_fieldcat-col_pos     = 6.
  g_es_fieldcat-outputlen   = 3.
  "g_es_fieldcat-edit        = ''.
  "g_es_fieldcat-emphasize   = ''.
  "g_es_fieldcat-key         = 'X'.
  APPEND g_es_fieldcat TO g_ti_fieldcat.

  g_es_fieldcat-fieldname   = 'ZDESCIU'.
  g_es_fieldcat-seltext_m   = TEXT-009.
  g_es_fieldcat-col_pos     = 7.
  g_es_fieldcat-outputlen   = 40.
  "g_es_fieldcat-edit        = ''.
  "g_es_fieldcat-emphasize   = ''.
  "g_es_fieldcat-key         = 'X'.
  APPEND g_es_fieldcat TO g_ti_fieldcat.

  g_es_fieldcat-fieldname   = 'ZESTADO'.
  g_es_fieldcat-seltext_m   = TEXT-010.
  g_es_fieldcat-col_pos     = 8.
  g_es_fieldcat-outputlen   = 1.
  "g_es_fieldcat-edit        = ''.
  "g_es_fieldcat-emphasize   = ''.
  "g_es_fieldcat-key         = 'X'.
  APPEND g_es_fieldcat TO g_ti_fieldcat.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_ALV_REPORT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_alv_report .
  DATA l_i_lin     TYPE i.

  g_c_code =  sy-tcode.

  DESCRIBE TABLE g_ti_datos_alv LINES  l_i_lin.
  g_c_lin = l_i_lin.

  g_o_repid = sy-repid.
  g_ti_datos_alv_cp[] = g_ti_datos_alv[].
  g_es_grid_settings-edt_cll_cb = 'X'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK        = ' '
*     I_BYPASSING_BUFFER       = ' '
*     I_BUFFER_ACTIVE          = ' '
      i_callback_program       = g_o_repid
      i_callback_pf_status_set = 'ALV_PF_STATUS'
      i_callback_user_command  = 'USER_COMMAND'
      i_callback_top_of_page   = 'TOP_OF_PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME         =
      i_background_id          = 'ALV_BACKGROUND'
*     I_GRID_TITLE             =
      i_grid_settings          = g_es_grid_settings
      is_layout                = g_ti_layout
      it_fieldcat              = g_ti_fieldcat
*     IT_EXCLUDING             =
*     IT_SPECIAL_GROUPS        =
*     IT_SORT                  =
*     IT_FILTER                =
*     IS_SEL_HIDE              =
*     I_DEFAULT                = 'X'
      i_save                   = 'X'
*     IS_VARIANT               =
*     IT_EVENTS                =
*     IT_EVENT_EXIT            =
*     IS_PRINT                 =
*     IS_REPREP_ID             =
*     I_SCREEN_START_COLUMN    = 0
*     I_SCREEN_START_LINE      = 0
*     I_SCREEN_END_COLUMN      = 0
*     I_SCREEN_END_LINE        = 0
*     I_HTML_HEIGHT_TOP        = 0
*     I_HTML_HEIGHT_END        = 0
*     IT_ALV_GRAPHICS          =
*     IT_HYPERLINK             =
*     IT_ADD_FIELDCAT          =
*     IT_EXCEPT_QINFO          =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab                 = g_ti_datos_alv
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.


FORM top_of_page  ##CALLED.

  DATA: l_es_header   TYPE slis_listheader,
        l_c_texto(12) TYPE c.

  REFRESH g_ti_header.
* Cargo el Título
  l_es_header-typ = 'H'.
  l_es_header-info = TEXT-001.
  APPEND  l_es_header TO g_ti_header.

  CONCATENATE sy-datum+6(2) sy-datum+4(2) sy-datum+0(4) INTO l_c_texto SEPARATED BY '/'.
  CONCATENATE TEXT-t01 '        '
                                      l_c_texto INTO g_c_tiempo_tra.
  l_es_header-typ = 'S'.
  l_es_header-info = g_c_tiempo_tra.
  APPEND  l_es_header TO g_ti_header.

  CONCATENATE sy-uzeit(2) sy-uzeit+2(2) sy-uzeit+4(2) INTO l_c_texto SEPARATED BY ':'.
  CONCATENATE TEXT-t02 '          ' l_c_texto INTO g_c_tiempo_tra.
  l_es_header-typ = 'S'.
  l_es_header-info = g_c_tiempo_tra.
  APPEND  l_es_header TO g_ti_header.

  CONCATENATE TEXT-t03 '       ' sy-uname INTO g_c_tiempo_tra.
  l_es_header-typ = 'S'.
  l_es_header-info = g_c_tiempo_tra.
  APPEND  l_es_header TO g_ti_header.

  CONCATENATE TEXT-t04 '     ' g_c_lin INTO g_c_tiempo_tra.
  l_es_header-typ = 'S'.
  l_es_header-info = g_c_tiempo_tra.
  APPEND  l_es_header TO g_ti_header.

* Pasa a la cabecera el logo
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      i_logo             = 'LOGOE' "Pinguino-412'  "Logo
      it_list_commentary = g_ti_header.

ENDFORM.                    "TOP_OF


FORM user_command  USING p_ucomm    LIKE sy-ucomm
                         p_selfield TYPE slis_selfield    ##CALLED ##NEEDED.

  CASE p_ucomm.
    WHEN '&CARGAR'.
      "PERFORM modificar_registros.
    WHEN '&CARGUE'.
      "PERFORM f_cargar_archivo_eps.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      "LEAVE to TRANSACTION sy-tcode.
       LEAVE TO SCREEN 0.
      "LEAVE PROGRAM.
  ENDCASE.
ENDFORM.                    "user_command


*&---------------------------------------------------------------------*
*&      Form  alv_standard
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->RT_EXTAB   text
*----------------------------------------------------------------------*
FORM alv_pf_status  USING p_ti_extab TYPE slis_t_extab  ##CALLED ##NEEDED.
  SET PF-STATUS 'GS_STANDARD'. "Nombre del Status GUI
ENDFORM.                    "alv_standard
