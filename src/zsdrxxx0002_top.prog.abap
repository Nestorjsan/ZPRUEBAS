*&---------------------------------------------------------------------*
*& Include          ZSDRXXX0002_TOP
*&---------------------------------------------------------------------*

TYPES:
  BEGIN OF g_tp_ti_ztsd0005,
    zcedula        TYPE   zdecedula,     "Cedula
    znombre        TYPE   zdenombre,     "Nombre
    zfecha         TYPE   zdefecha,      "Fecha
    zsaldo         TYPE   zdesaldo,      "Saldo
    g_c_estado(10) TYPE   c,       "Estado
  END OF g_tp_ti_ztsd0005,

  BEGIN OF g_tp_ti_ztsdmodi,
    zcedula TYPE   zdecedula,     "Cedula
    zfecha  TYPE   zdefecha,      "Fecha
    zsaldo  TYPE   zdesaldo,      "Saldo
  END OF g_tp_ti_ztsdmodi,

  BEGIN OF g_tp_ti_ztsd0003,
    zcedula TYPE   zdecedula,     "Cedula
    zdepto  TYPE   zdedepto,      "Departamento
    zciudad TYPE   zdeciudad,     "Ciudad
    zdescri TYPE   zdedescri,     "Nombre
  END OF g_tp_ti_ztsd0003,

  g_tp_tt_ztsd0005 TYPE STANDARD TABLE OF g_tp_ti_ztsd0005,
  g_tp_tt_ztsd0003 TYPE STANDARD TABLE OF g_tp_ti_ztsd0003,
  g_tp_tt_ztsdmodi TYPE STANDARD TABLE OF g_tp_ti_ztsdmodi.

*Pantalla de selección
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001 ##TEXT_POOL.
PARAMETERS :
              pa_ced  TYPE g_tp_ti_ztsd0005-zcedula. "OBLIGATORY.  "Cedula.
SELECTION-SCREEN END OF BLOCK b1.

DATA ok_code TYPE sy-ucomm.


DATA:
  g_es_ztsd0005   TYPE  g_tp_ti_ztsd0005,
  g_es_ztsd0003   TYPE  g_tp_ti_ztsd0003,
  g_es_ztsdcop    TYPE  g_tp_ti_ztsd0005,
  g_es_ztsdmodi   TYPE  g_tp_ti_ztsdmodi,
  g_ti_ztsd0005   TYPE  g_tp_tt_ztsd0005,
  g_ti_ztsd0003   TYPE  g_tp_tt_ztsd0003,
  g_ti_ztsdcop    TYPE  g_tp_tt_ztsd0005,
  g_ti_ztsdmodi   TYPE  g_tp_tt_ztsdmodi,
  g_es_ztsdtmp    TYPE  ztsd0005,
  g_ti_lvc_s_fcat TYPE STANDARD TABLE OF  lvc_s_fcat,
  vg_container    TYPE REF TO cl_gui_custom_container,  "Contenedor
  obj_alv_grid    TYPE REF TO cl_gui_alv_grid.

"Clase interna
CLASS cls_alv_oo DEFINITION DEFERRED.
DATA: obj_alv_oo TYPE REF TO cls_alv_oo.

"Clase Eventos
CLASS cls_alv_events DEFINITION DEFERRED.
DATA: obj_alv_events TYPE REF TO cls_alv_events.
