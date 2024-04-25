*&---------------------------------------------------------------------*
*& Include          ZFIRXXX0001_FORM
*&---------------------------------------------------------------------*
FORM f_consulta_datos.

  "Tabla de parametros
  SELECT name low
         FROM tvarvc
    INTO TABLE gti_parametros
    WHERE name LIKE '%ZFELA14%'.

  ges_segmento_enc-nom_seg = 'ENC'.
  ges_segmento_enc-tip_fac = pa_doc.
  ges_segmento_enc-ind_top = '30'.
  APPEND ges_segmento_enc TO gti_segmento_enc.

  ges_segmento_cdn-nom_seg     = 'CDN'.
  ges_segmento_cdn-cod_tipcon  ='1'.
  ges_segmento_cdn-des_natucor = 'Nota Debito'.
  APPEND ges_segmento_cdn TO gti_segmento_cdn.

  ges_segmento_ref-nom_seg = 'REF'.
  ges_segmento_ref-num_docref = '1354021'.
  APPEND ges_segmento_ref TO gti_segmento_ref.


  READ TABLE gti_parametros  INTO gwa_parametros
              WITH KEY name = TEXT-031. "(zfela14_tipnota)  91-92

  SELECT sign opti low high
  INTO TABLE gvr_tipnota
  FROM tvarvc
  WHERE name = gwa_parametros-name.
  IF gvr_tipnota[] IS INITIAL.
  ELSE.

    READ TABLE gti_segmento_enc ASSIGNING <lfs_seg_enc>
             WITH KEY nom_seg = 'ENC'.
    IF  sy-subrc EQ 0.
      IF <lfs_seg_enc>-tip_fac IN gvr_tipnota[].

        READ TABLE gti_parametros  INTO gwa_parametros
           WITH KEY name = TEXT-032. "(zfela14_tipope)  20-30


        SELECT sign opti low high
        INTO TABLE gvr_tipope
        FROM tvarvc
        WHERE name = gwa_parametros-name.
        IF gvr_tipope[] IS INITIAL.
        ELSE.
          IF <lfs_seg_enc>-ind_top IN gvr_tipope[].

            READ TABLE gti_segmento_cdn ASSIGNING <lfs_seg_cdn>
            WITH KEY nom_seg = 'CDN'.
            IF  sy-subrc EQ 0.

              READ TABLE gti_segmento_ref INTO ges_segmento_ref
               WITH KEY nom_seg = 'REF'.
              IF sy-subrc EQ 0.
                <lfs_seg_cdn>-sec_factor =  ges_segmento_ref-num_docref .
              ENDIF.

            ENDIF.
          ENDIF.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDIF.

  READ TABLE gti_segmento_cdn INTO ges_segmento_cdn
        WITH KEY nom_seg = 'CDN'.

  CONDENSE: ges_segmento_cdn-cod_tipcon, ges_segmento_cdn-des_natucor, ges_segmento_cdn-sec_factor.

  DATA lc_variable(100) TYPE c.


  CONCATENATE ' Segmento..: ' ges_segmento_cdn-nom_seg
  ' Tipo Operación..: ' ges_segmento_cdn-cod_tipcon
  ' Descripción..: ' ges_segmento_cdn-des_natucor
  ' Factura Número..: ' ges_segmento_cdn-sec_factor INTO lc_variable SEPARATED BY ' '.
  CONDENSE lc_variable.

  WRITE: / lc_variable.
ENDFORM.
