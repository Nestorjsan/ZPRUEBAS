*&---------------------------------------------------------------------*
*& Include          ZSDRXXX0002_CLS_EVENTS
*&---------------------------------------------------------------------*
CLASS cls_alv_events DEFINITION.

  PUBLIC SECTION.

    METHODS:
      handle_double_click FOR EVENT double_click  OF cl_gui_alv_grid
        IMPORTING e_row
                  e_column
                  es_row_no.
ENDCLASS.

CLASS cls_alv_events IMPLEMENTATION.
  METHOD: handle_double_click.

    DATA l_i_row TYPE i.
    l_i_row = e_row.


    IF e_column = 'ZCEDULA'.
      READ TABLE g_ti_ztsd0005 INTO g_es_ztsd0005 INDEX l_i_row.

      READ TABLE g_ti_ztsd0003 INTO g_es_ztsd0003
       WITH KEY zcedula  = g_es_ztsd0005-zcedula.

      DATA lv_message TYPE string.
      CONCATENATE 'Ciudad..: ' g_es_ztsd0003-zdescri INTO lv_message SEPARATED BY space.
      MESSAGE lv_message TYPE 'I' .

    ENDIF.
  ENDMETHOD.
ENDCLASS.
