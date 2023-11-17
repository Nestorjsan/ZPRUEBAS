*&---------------------------------------------------------------------*
*& Include          ZSDRXXX0005_TOP
*&---------------------------------------------------------------------*
TYPES:

  BEGIN OF g_tp_ti_smartform,
    zfactura  TYPE   zdefactura,    "Número de la factura
    zcedula   TYPE   zdecedula,     "Cedula del cliente
    zcodpro   TYPE   zdecodpro,     "Codigo del producto
    zdescri   TYPE   zdedescri,     "Descripción del producto
    zcantidad TYPE   zdecantidad,   "Cantidad
    zvalor    TYPE   zdevalor,      "Valor
    ztotal    TYPE   zdevalor,      "Total
    zfecfac   TYPE   zdefecha,      "Fecha Factura
  END OF g_tp_ti_smartform.

TYPES:
  "g_tp_tt_ztsd0002  TYPE STANDARD TABLE OF g_tp_ti_ztsd0002,
  g_tp_tt_smartform TYPE STANDARD TABLE OF g_tp_ti_smartform.


DATA:

  g_ti_smartform      TYPE STANDARD TABLE OF g_tp_ti_smartform,
  gf_fm_name          TYPE rs38l_fnam,
  ges_control_param   TYPE ssfctrlop,
  ges_composer_param  TYPE ssfcompop,
  ges_docinfo         TYPE ssfcrespd,
  ges_jobinfo         TYPE ssfcrescl,
  ges__output_options TYPE ssfcompop,
  lc_print_ok         TYPE char1.

  CLASS zftf_factura DEFINITION DEFERRED.
  DATA: obj_factura_oo TYPE REF TO zftf_factura.
