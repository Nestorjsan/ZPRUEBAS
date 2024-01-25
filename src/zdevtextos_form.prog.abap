*&---------------------------------------------------------------------*
*& Include          ZDEVTEXTOS_FORM
*&---------------------------------------------------------------------*

FORM f_consulta_texto.

  g_es_texto = pa_tex.
  CONDENSE g_es_texto.

  SELECT tdname
     FROM stxh INTO TABLE gti_stxh
      WHERE tdname = g_es_texto.
  IF sy-subrc EQ 0.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = 'ST'             "ID del texto
        language                = 'S'              "Idioma
        name                    = g_es_texto       "Texto
        object                  = 'TEXT'           "Esto es constante
      IMPORTING
        header                  = ls_header
      TABLES
        lines                   = gti_lineas
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.

    ld_fila = 1.
    LOOP AT gti_lineas INTO gwa_lineas.

      CASE ld_fila.

        WHEN 1.
          gv_texto1 = gwa_lineas-tdline.
        WHEN 2.
          gv_texto2 = gwa_lineas-tdline.
        WHEN 3.
          gv_texto3 = gwa_lineas-tdline.
        WHEN 4.
          gv_texto4 = gwa_lineas-tdline.
        WHEN 5.
          gv_texto5 = gwa_lineas-tdline.
        WHEN 6.
          gv_texto6 = gwa_lineas-tdline.
        WHEN 7.
          gv_texto7 = gwa_lineas-tdline.
        WHEN 8.
          gv_texto8 = gwa_lineas-tdline.
        WHEN 9.
          gv_texto9 = gwa_lineas-tdline.
        WHEN 10.
          gv_texto10 = gwa_lineas-tdline.
      ENDCASE.

      ld_fila = ld_fila + 1.

    ENDLOOP.

    CONCATENATE gv_texto1 ' ' gv_texto2 ' ' gv_texto3 ' ' gv_texto4 ' ' gv_texto5 ' '
                gv_texto6 ' ' gv_texto7 ' ' gv_texto8 ' ' gv_texto9 ' ' gv_texto10 INTO gv_texto.
    REPLACE '<N>' WITH space INTO gv_texto.
    REPLACE '</>' WITH space INTO gv_texto.
    CONDENSE gv_texto.

    SELECT name low
           FROM tvarvc
      INTO TABLE gti_parametros
      WHERE name = text-003.

    READ TABLE gti_parametros INTO ges_parametros INDEX 1.

    CONCATENATE '1.-' gv_texto INTO ges_pos_01.
    CONDENSE ges_pos_01.
    g_es_contador = strlen( ges_pos_01 ).
    g_es_texnum = g_es_contador.
    IF g_es_contador > ges_parametros-low.
      CONCATENATE 'El texto ' g_es_texto ' sobrepasa la cantidad de' ges_parametros-low  ' caracteres permitidos, tiene ' g_es_texnum INTO lv_message SEPARATED BY space.
    ELSE.
      CONCATENATE 'El texto ' g_es_texto ' no excede la cantidad de ' ges_parametros-low   ' caracteres permitidos' INTO lv_message SEPARATED BY space.
    ENDIF.
    MESSAGE lv_message TYPE 'I'.
  ELSE.
    CONCATENATE 'El texto ' g_es_texto ' No Está Creado' INTO lv_message SEPARATED BY space.
     MESSAGE lv_message TYPE 'I'.
  ENDIF.
ENDFORM.
