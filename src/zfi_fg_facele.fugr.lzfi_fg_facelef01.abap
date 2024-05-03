*&---------------------------------------------------------------------*
*& Include          LZFI_FG_FACELEF01
*&---------------------------------------------------------------------*
FORM f_ajuste_segmento_cdn_3 CHANGING p_ti_segmento_enc  TYPE  gtt_segmento_enc
                                      p_ti_segmento_cdn  TYPE  gtt_segmento_cdn
                                      p_ti_segmento_ref  TYPE  gtt_segmento_ref.

  ges_segmento_ref-num_docref =' '.

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
             WITH KEY nom_seg = 'ENC'.
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
            WITH KEY nom_seg = 'CDN'.
            IF  sy-subrc EQ 0.

              READ TABLE p_ti_segmento_ref INTO ges_segmento_ref
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

  CLEAR gti_parametros_not.

ENDFORM.
