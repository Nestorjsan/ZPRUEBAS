*&---------------------------------------------------------------------*
*& Report ZSDRXXX0002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSDRXXX0002.


INCLUDE zsdrxxx0002_TOP.
INCLUDE zsdrxxx0002_pbo_001.
INCLUDE zsdrxxx0002_pai_100.
INCLUDE zsdrxxx0002_cls_events.
INCLUDE zsdrxxx0002_cls_001.
INCLUDE zsdrxxx0002_form_001.

START-OF-SELECTION.

  CREATE OBJECT obj_alv_oo.

*obj_alv_oo = NEW cls_alv_oo( ).
*obj_alv_oo = NEW #( ).

  CALL METHOD obj_alv_oo->get_data.
  CALL METHOD obj_alv_oo->show_alv.

  CALL SCREEN 0100.
