*&---------------------------------------------------------------------*
*& Include          ZSDRXXX0003_CLS
*&---------------------------------------------------------------------*

CLASS zcl_sd_actualizar DEFINITION.

  PUBLIC SECTION.

    METHODS: adi_data,
      del_data.

ENDCLASS.


CLASS zcl_sd_actualizar IMPLEMENTATION.
  METHOD: adi_data.

    CLEAR: g_es_detalle.
    DATA:
      l_c_dia(2)     TYPE c,
      l_c_mes(2)     TYPE c,
      l_c_year(4)    TYPE c,
      l_c_fecha      TYPE sy-datum,
      l_c_fecini(10) TYPE c.

    g_e_total = 0.
    LOOP AT g_ti_detalle INTO g_es_detalle.

      g_es_ztsd0002-zfactura  = g_es_ztsd0001-zfactura.
      g_es_ztsd0002-zcedula   = g_es_ztsd0001-zcedula.
      g_es_ztsd0002-zcodpro   = g_es_detalle-zcodpro.
      g_es_ztsd0002-zdescri   = g_es_detalle-zdescri.
      g_es_ztsd0002-zcantidad = g_es_detalle-zcantidad.
      g_es_ztsd0002-zvalor    = g_es_detalle-zvalor.
      g_es_ztsd0002-ztotal    = g_es_detalle-ztotal.

      IF  g_es_detalle-zcodpro IS INITIAL OR g_es_ztsd0002-zvalor EQ 0.
      ELSE.
        MODIFY ztsd0002 FROM g_es_ztsd0002.
        COMMIT WORK.
        g_e_total              = g_e_total +  g_es_detalle-ztotal.

        "Actualiza el saldo
        READ TABLE g_ti_detalle_cop INTO g_es_detalle_cop
        WITH KEY zcodpro = g_es_detalle-zcodpro.
        IF sy-subrc EQ 0.
          IF ( g_es_detalle-zcantidad <> g_es_detalle_cop-zcantidad )
             OR ( g_es_detalle-zvalor    <> g_es_detalle_cop-zvalor )
             OR ( g_es_detalle-ztotal    <> g_es_detalle_cop-ztotal ).
            IF g_es_detalle-ztotal  > g_es_detalle_cop-ztotal.
              g_e_saldo              = g_e_saldo -  g_es_detalle-ztotal.
            ELSE.
              g_e_saldo              = g_e_saldo +  g_es_detalle-ztotal.
            ENDIF.

            "Actualizamos el saldo
            g_es_ztsd0005_act-zfecha =  sy-datum.
            l_c_fecha = sy-datum.
            CONCATENATE l_c_fecha+0(4) ' ' INTO l_c_year."Año
            CONCATENATE l_c_fecha+4(2) ' ' INTO l_c_mes. "Mes
            CONCATENATE l_c_fecha+6(2) ' ' INTO l_c_dia. "Dia
            CONCATENATE   l_c_year l_c_mes l_c_dia INTO l_c_fecini.

            g_es_ztsd0005_act-zcedula =  g_es_ztsd0001-zcedula.
            g_es_ztsd0005_act-zfecha  =  l_c_fecini.
            g_es_ztsd0005_act-zsaldo  =  g_e_saldo.
            MODIFY ztsd0005 FROM g_es_ztsd0005_act.

          ENDIF.
        ELSE.
          g_e_saldo              = g_e_saldo -  g_es_detalle-ztotal.

          "Actualizamos el saldo
          g_es_ztsd0005_act-zfecha =  sy-datum.
          l_c_fecha = sy-datum.
          CONCATENATE l_c_fecha+0(4) ' ' INTO l_c_year."Año
          CONCATENATE l_c_fecha+4(2) ' ' INTO l_c_mes. "Mes
          CONCATENATE l_c_fecha+6(2) ' ' INTO l_c_dia. "Dia
          CONCATENATE   l_c_year l_c_mes l_c_dia INTO l_c_fecini.

          g_es_ztsd0005_act-zcedula =  g_es_ztsd0001-zcedula.
          g_es_ztsd0005_act-zfecha  =  l_c_fecini.
          g_es_ztsd0005_act-zsaldo  =  g_e_saldo.
          MODIFY ztsd0005 FROM g_es_ztsd0005_act.


        ENDIF.
      ENDIF.
    ENDLOOP.

    "Actuliza tabla Copia detalle
    CLEAR g_ti_detalle_cop.
    g_ti_detalle_cop[] = g_ti_detalle[].

  ENDMETHOD.

  METHOD: del_data.
    DATA: l_e_total      TYPE zdevalor,
          l_c_dia(2)     TYPE c,
          l_c_mes(2)     TYPE c,
          l_c_year(4)    TYPE c,
          l_c_fecha      TYPE zdefecha,
          l_c_fecini(10) TYPE c.

    l_e_total = g_e_total.
    g_e_total = 0.
    LOOP AT g_ti_detalle INTO g_es_detalle.

      g_es_ztsd0002-zfactura  = g_es_ztsd0001-zfactura.
      g_es_ztsd0002-zcedula   = g_es_ztsd0001-zcedula.
      g_es_ztsd0002-zcodpro   = g_es_detalle-zcodpro.
      g_es_ztsd0002-zdescri   = g_es_detalle-zdescri.
      g_es_ztsd0002-zcantidad = g_es_detalle-zcantidad.
      g_es_ztsd0002-zvalor    = g_es_detalle-zvalor.
      g_es_ztsd0002-ztotal    = g_es_detalle-ztotal.


      IF  g_es_detalle-zcodpro IS INITIAL OR g_es_ztsd0002-zvalor EQ 0.
      ELSE.
        IF g_es_detalle-mark EQ 'X'.
          DELETE FROM ztsd0002 WHERE zfactura EQ g_es_ztsd0001-zfactura
                                AND  zcedula  EQ g_es_ztsd0001-zcedula
                                AND  zcodpro  EQ g_es_detalle-zcodpro.
          COMMIT WORK.

          g_e_total               = g_e_total -  g_es_detalle-ztotal.
          READ TABLE g_ti_detalle_cop INTO g_es_detalle_cop
           WITH KEY zcodpro = g_es_detalle-zcodpro.
          IF sy-subrc EQ 0.
            g_e_saldo               = g_e_saldo +  g_es_detalle-ztotal.
            DELETE g_ti_detalle_cop WHERE zcodpro  EQ g_es_detalle-zcodpro.

            "Actualizamos el saldo
            g_es_ztsd0005_act-zfecha =  sy-datum.
            l_c_fecha = sy-datum.
            CONCATENATE l_c_fecha+0(4) ' ' INTO l_c_year."Año
            CONCATENATE l_c_fecha+4(2) ' ' INTO l_c_mes. "Mes
            CONCATENATE l_c_fecha+6(2) ' ' INTO l_c_dia. "Dia
            CONCATENATE   l_c_year l_c_mes l_c_dia INTO l_c_fecini.

            g_es_ztsd0005_act-zcedula =  g_es_ztsd0001-zcedula.
            g_es_ztsd0005_act-zfecha  =  l_c_fecini.
            g_es_ztsd0005_act-zsaldo  =  g_e_saldo.
            MODIFY ztsd0005 FROM g_es_ztsd0005_act.

          ENDIF.
        ELSE.
          g_e_total               = g_e_total +  g_es_detalle-ztotal.
        ENDIF.
      ENDIF.
    ENDLOOP.
    IF g_e_total <> 0.
      "l_e_total = l_e_total - g_e_total.
      "g_e_saldo = g_e_saldo +  l_e_total.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
