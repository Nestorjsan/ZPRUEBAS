FUNCTION zfi_fm_facele.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(TIP_DOCU) TYPE  C
*"  EXPORTING
*"     REFERENCE(NUM_FAC) TYPE  C
*"----------------------------------------------------------------------

  ges_segmento_enc-nom_seg = 'ENC'.
  ges_segmento_enc-tip_fac = tip_docu. "pa_doc.
  ges_segmento_enc-ind_top = '30'.
  APPEND ges_segmento_enc TO gti_segmento_enc.

  ges_segmento_cdn-nom_seg     = 'CDN'.
  ges_segmento_cdn-cod_tipcon  ='1'.
  ges_segmento_cdn-des_natucor = 'Nota Debito'.
  APPEND ges_segmento_cdn TO gti_segmento_cdn.

  ges_segmento_ref-nom_seg = 'REF'.
  ges_segmento_ref-num_docref = '1354021'.
  APPEND ges_segmento_ref TO gti_segmento_ref.

  PERFORM f_ajuste_segmento_cdn_3 CHANGING gti_segmento_enc
                                           gti_segmento_cdn
                                           gti_segmento_ref.
  num_fac = ges_segmento_ref-num_docref.

  CLEAR:  ges_segmento_ref-num_docref ,
          gti_segmento_enc,
          gti_segmento_cdn,
          gti_segmento_ref.

ENDFUNCTION.
