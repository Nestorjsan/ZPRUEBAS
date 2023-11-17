*&---------------------------------------------------------------------*
*& Include          ZSDRXXX0001_TOP
*&---------------------------------------------------------------------*


TYPES:

  BEGIN OF g_tp_ti_ztsd0001,
    zcedula    TYPE zdecedula,    "Cedula del cliente
    znombre    TYPE zdenombre,    "Nombre del cliente
    zdireccion TYPE zdedireccion, "Direccion
    ztelefono  TYPE zdetelefono,  "Telefono
    zdepto     TYPE zdedepto,     "Departamento
    zciudad    TYPE zdeciudad,    "Ciudad
    zestado    TYPE zdeestado,    "Estado
  END OF g_tp_ti_ztsd0001,

  BEGIN OF g_tp_ti_ztsd0003,
    zdepto  TYPE   zdedepto,     "Departamento
    zciudad TYPE   zdeciudad,   "Ciudad
    zdescri TYPE   zdedescri,   "Descripcion,
  END OF g_tp_ti_ztsd0003,

  BEGIN OF g_tp_ti_ztsdciudad,
    zdepto  TYPE   zdedepto,     "Departamento
    zciudad TYPE   zdeciudad,    "Ciudad
    zdescri TYPE   zdedescri,    "Descripcion,
  END OF g_tp_ti_ztsdciudad,

  BEGIN OF g_tp_ti_data,          "Obtención de datos
    zcedula    TYPE zdecedula,    "Cedula del cliente
    znombre    TYPE zdenombre,    "Nombre del cliente
    zdireccion TYPE zdedireccion, "Direccion
    ztelefono  TYPE zdetelefono,  "Telefono
    zdepto     TYPE zdedepto,     "Departamento
    zciudad    TYPE zdeciudad,    "Ciudad
    zestado    TYPE zdeestado,    "Estado
  END OF g_tp_ti_data,

  BEGIN OF g_tp_ti_datos_alv,     "Datos del reporte
    zcedula    TYPE zdecedula,    "Cedula del cliente
    znombre    TYPE zdenombre,    "Nombre del cliente
    zdireccion TYPE zdedireccion, "Direccion
    ztelefono  TYPE zdetelefono,  "Telefono
    zdepto     TYPE zdedepto,     "Departamento
    zdesdto    TYPE zdedescri,    "Descripción del departamento
    zciudad    TYPE zdeciudad,    "Ciudad
    zdesciu    TYPE zdedescri,    "Descripción ciudad
    zestado    TYPE zdeestado,    "Estado
  END OF g_tp_ti_datos_alv,

  g_tp_tt_ztsd0001   TYPE STANDARD TABLE OF g_tp_ti_ztsd0001,
  g_tp_tt_ztsd0003   TYPE STANDARD TABLE OF g_tp_ti_ztsd0003,
  g_tp_tt_ztsdciudad TYPE STANDARD TABLE OF g_tp_ti_ztsdciudad,
  g_tp_tt_data       TYPE STANDARD TABLE OF g_tp_ti_data,
  g_tp_tt_datos_alv  TYPE STANDARD TABLE OF g_tp_ti_datos_alv.

DATA:
  g_es_ztsd0001      TYPE  g_tp_ti_ztsd0001 ##NEEDED,
  g_es_ztsd0003      TYPE  g_tp_ti_ztsd0003 ##NEEDED,
  g_es_ztsdciudad    TYPE  g_tp_ti_ztsdciudad ##NEEDED,
  g_es_datos_alv     TYPE  g_tp_ti_datos_alv ##NEEDED,
  g_es_data          TYPE  g_tp_ti_data,
  g_es_datos_alv_aux TYPE  g_tp_ti_datos_alv ##NEEDED,

  g_ti_ztsd0001      TYPE  g_tp_tt_ztsd0001,
  g_ti_ztsd0003      TYPE  g_tp_tt_ztsd0003,
  g_ti_ztsdciudad    TYPE  g_tp_tt_ztsdciudad,
  g_ti_data          TYPE  g_tp_tt_data,
  g_ti_datos_alv     TYPE  g_tp_tt_datos_alv ##NEEDED,
  g_ti_datos_alv_cp  TYPE  g_tp_tt_datos_alv ##NEEDED.



*ALV data declarations
DATA: "g_ti_fieldcatalog       TYPE slis_t_fieldcat_alv WITH HEADER LINE,
  g_ti_fieldcat      TYPE slis_t_fieldcat_alv ##NEEDED,
  g_es_fieldcat      TYPE slis_fieldcat_alv ##NEEDED,
  g_o_tab_group      TYPE slis_t_sp_group_alv ##NEEDED,
  g_o_layout         TYPE lvc_s_layo   ##NEEDED,
  g_o_repid          TYPE sy-repid    ##NEEDED,
  "form_callback           TYPE slis_formname VALUE 'USER_COMMAND',
  g_ti_layout        TYPE slis_layout_alv ##NEEDED,
  g_es_grid_settings TYPE lvc_s_glay ##NEEDED,
  g_ti_header        TYPE slis_t_listheader ##NEEDED,    " Tabla con el Título y el Logo
  g_c_lin(6)         TYPE c ##NEEDED,
  g_c_code           TYPE cdhdr-tcode ##NEEDED,
  g_e_minut          TYPE i ##NEEDED,
  g_e_timestamp_ini  TYPE timestampl  ##NEEDED,
  g_e_timestamp_fin  TYPE timestampl  ##NEEDED,
  g_e_timestamp_tra  TYPE timestampl  ##NEEDED,
  g_e_timezone       TYPE timezone    ##NEEDED,
  g_c_tiempo_tra(30) TYPE c          ##NEEDED,
  g_o_alv_report     TYPE REF TO cl_salv_table  ##NEEDED,
  g_o_salv_funct     TYPE REF TO cl_salv_functions_list ##NEEDED,
  g_o_columns        TYPE REF TO cl_salv_columns_table ##NEEDED,
  g_o_column_s       TYPE REF TO cl_salv_column ##NEEDED,
  g_o_salv_display   TYPE REF TO cl_salv_display_settings ##NEEDED.

CONSTANTS:  g_cte_cero TYPE molga VALUE '00'.
