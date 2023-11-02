*&---------------------------------------------------------------------*
*& Include          ZSDRXXX0003_TOP
*&---------------------------------------------------------------------*

TYPES:
  BEGIN OF g_tp_ti_ztsd0001,
    zcedula    TYPE   zdecedula,     "Cedula
    znombre    TYPE   zdenombre,     "Nombre
    zdireccion TYPE   zdedireccion,  "Dirección
    ztelefono  TYPE   zdetelefono,   "Telefono
    zdepto     TYPE   zdedepto ,     "Departamento
    zciudad    TYPE   zdeciudad,     "Ciudad
    zfactura   TYPE   zdefactura,    "Factura
  END OF g_tp_ti_ztsd0001,

  BEGIN OF g_tp_ti_detalle,
    zcodpro   TYPE   zdecodpro,     "Codigo del producto
    zdescri   TYPE   zdedescri,     "Descripción del producto
    zcantidad TYPE   zdecantidad,   "Cantidad
    zvalor    TYPE   zdevalor,      "Valor
    ztotal    TYPE   zdevalor,      "Total
    mark      TYPE   char1,
  END OF g_tp_ti_detalle,

  BEGIN OF g_tp_ti_ztsd0003,
    zdepto  TYPE   zdedepto,     "Departamento
    zciudad TYPE   zdeciudad,    "Ciudad
    zdescri TYPE   zdedescri,    "Descripcion,
  END OF g_tp_ti_ztsd0003,

  BEGIN OF g_tp_ti_ztsdciudad,
    zdepto  TYPE   zdedepto,     "Departamento
    zciudad TYPE   zdeciudad,    "Ciudad
    zdescri TYPE   zdedescri,    "Descripcion,
  END OF g_tp_ti_ztsdciudad,

  BEGIN OF g_tp_ti_ztsd0004,
    zcodpro TYPE   zdecodpro,     "Producto
    zdescri TYPE   zdedescri,     "Descripcion,
  END OF g_tp_ti_ztsd0004,

  BEGIN OF g_tp_ti_ztsd0005,
    zcedula TYPE   zdecedula,     "cedula
    zfecha  TYPE   zdefecha,      "Fecha
    zsaldo  TYPE   zdesaldo ,     "saldo,
  END OF g_tp_ti_ztsd0005,

  g_tp_tt_ztsd0001   TYPE STANDARD TABLE OF g_tp_ti_ztsd0001,
  g_tp_tt_ztsd0003   TYPE STANDARD TABLE OF g_tp_ti_ztsd0003,
  g_tp_tt_ztsd0004   TYPE STANDARD TABLE OF g_tp_ti_ztsd0004,
  g_tp_tt_ztsd0005   TYPE STANDARD TABLE OF g_tp_ti_ztsd0005,
  g_tp_tt_ztsdciudad TYPE STANDARD TABLE OF g_tp_ti_ztsdciudad,
  g_tp_tt_detalle    TYPE STANDARD TABLE OF g_tp_ti_detalle.

DATA:
  g_es_ztsd0001       TYPE  g_tp_ti_ztsd0001,
  g_es_ztsd0003       TYPE  g_tp_ti_ztsd0003,
  g_es_ztsd0004       TYPE  g_tp_ti_ztsd0004,
  g_es_ztsd0005       TYPE  g_tp_ti_ztsd0005,
  g_es_detalle        TYPE  g_tp_ti_detalle,
  g_es_detalle_cop    TYPE  g_tp_ti_detalle,
  g_es_ztsdciudad     TYPE  g_tp_ti_ztsdciudad,
  g_es_ztsd0002       TYPE  ztsd0002,
  g_es_ztsd0005_act   TYPE  ztsd0005,
  g_ti_ztsd0001       TYPE  g_tp_tt_ztsd0001,
  g_ti_ztsd0003       TYPE  g_tp_tt_ztsd0003,
  g_ti_ztsd0004       TYPE  g_tp_tt_ztsd0004,
  g_ti_ztsd0005       TYPE  g_tp_tt_ztsd0005,
  g_ti_ztsdciudad     TYPE  g_tp_tt_ztsdciudad,
  g_ti_detalle        TYPE  g_tp_tt_detalle,
  g_ti_detalle_cop    TYPE  g_tp_tt_detalle,
  g_ti_lvc_s_fcat     TYPE STANDARD TABLE OF  lvc_s_fcat,
  go_custom_container TYPE REF TO cl_gui_custom_container,  "Contenedor
  obj_alv_grid        TYPE REF TO cl_gui_alv_grid.

DATA: znfactura TYPE zdefactura,
      zdesdepto TYPE zdedescri,
      zdciudad  TYPE zdedescri,
      g_e_saldo TYPE zdevalor,
      g_e_total TYPE zdevalor,
      g_f_factu TYPE zdefecha.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC_DETPRO' ITSELF
CONTROLS: tc_detpro TYPE TABLEVIEW USING SCREEN 0110.

*&SPWIZARD: LINES OF TABLECONTROL 'TC_DETPRO'
DATA:     g_tc_detpro_lines  LIKE sy-loopc.

DATA:     ok_code LIKE sy-ucomm.

"Clase interna
CLASS zcl_sd_actualizar DEFINITION DEFERRED.
DATA: g_o_actualizar TYPE REF TO zcl_sd_actualizar.
