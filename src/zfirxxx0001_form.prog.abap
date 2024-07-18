*&---------------------------------------------------------------------*
*& Include          ZFIRXXX0001_FORM
*&---------------------------------------------------------------------*
FORM f_mapear_info_segmentos  CHANGING p_ti_segmento_enc  TYPE  gtt_segmento_enc
                                       p_ti_segmento_cdn  TYPE  gtt_segmento_cdn
                                       p_ti_segmento_ref  TYPE  gtt_segmento_ref.

  "Tabla de parametros Notas debito y credito


  ges_segmento_enc-nom_seg = 'ENC'.
  ges_segmento_enc-tip_fac = pa_doc.
  ges_segmento_enc-ind_top = '30'.
  APPEND ges_segmento_enc TO p_ti_segmento_enc.

  ges_segmento_cdn-nom_seg     = 'CDN'.
  ges_segmento_cdn-cod_tipcon  ='1'.
  ges_segmento_cdn-des_natucor = 'Nota Debito'.
  APPEND ges_segmento_cdn TO p_ti_segmento_cdn.

  ges_segmento_ref-nom_seg = 'REF'.
  ges_segmento_ref-num_docref = '1354021'.
  APPEND ges_segmento_ref TO p_ti_segmento_ref.

  PERFORM f_ajuste_segmento_cdn USING    gti_segmento_enc
                                         gti_segmento_cdn
                                         gti_segmento_ref.


ENDFORM.

FORM f_ajuste_segmento_cdn CHANGING p_ti_segmento_enc  TYPE  gtt_segmento_enc
                                    p_ti_segmento_cdn  TYPE  gtt_segmento_cdn
                                    p_ti_segmento_ref  TYPE  gtt_segmento_ref.

  SELECT name low
         FROM tvarvc
    INTO TABLE gti_parametros_not
    WHERE name EQ text-031 " LIKE '%ZFELA14%'.
       OR name EQ text-032.

  READ TABLE gti_parametros_not  INTO gwa_parametros
              WITH KEY name = TEXT-031. "(zfela14_tipnota)  91-92

  SELECT sign opti low high
  INTO TABLE gvr_tipnota
  FROM tvarvc
  WHERE name = gwa_parametros-name.
  IF gvr_tipnota[] IS NOT INITIAL.

    READ TABLE p_ti_segmento_enc ASSIGNING <lfs_seg_enc>
             WITH KEY nom_seg = TEXT-enc.
    IF  sy-subrc EQ 0.
      IF <lfs_seg_enc>-tip_fac IN gvr_tipnota[].

        READ TABLE gti_parametros_not  INTO gwa_parametros
           WITH KEY name = TEXT-032. "(zfela14_tipope)  20-30


        SELECT sign opti low high
        INTO TABLE gvr_tipope
        FROM tvarvc
        WHERE name = gwa_parametros-name.
        IF gvr_tipope[] IS NOT INITIAL.
          IF <lfs_seg_enc>-ind_top IN gvr_tipope[].

            READ TABLE p_ti_segmento_cdn ASSIGNING <lfs_seg_cdn>
            WITH KEY nom_seg = TEXT-cdn.
            IF  sy-subrc EQ 0.

              READ TABLE p_ti_segmento_ref INTO ges_segmento_ref
               WITH KEY nom_seg = TEXT-ref.
              IF sy-subrc EQ 0.
                <lfs_seg_cdn>-sec_factor =  ges_segmento_ref-num_docref .
              ENDIF.

            ENDIF.
          ENDIF.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDIF.

  CLEAR gti_parametros_not.

  READ TABLE p_ti_segmento_cdn INTO ges_segmento_cdn
        WITH KEY nom_seg = 'CDN'.

  CONDENSE: ges_segmento_cdn-cod_tipcon, ges_segmento_cdn-des_natucor, ges_segmento_cdn-sec_factor.

  DATA lc_variable(200) TYPE c.


  CONCATENATE ' Segmento..: ' ges_segmento_cdn-nom_seg
  ' Tipo Operación..: ' ges_segmento_cdn-cod_tipcon
  ' Descripción..: ' ges_segmento_cdn-des_natucor
  ' Factura Número..: ' ges_segmento_cdn-sec_factor
  ' Tipo Docu.......: '  ges_segmento_enc-tip_fac ' ' <lfs_seg_enc>-tip_fac INTO lc_variable SEPARATED BY ' '.
  CONDENSE lc_variable.

  WRITE: / lc_variable.

ENDFORM.
