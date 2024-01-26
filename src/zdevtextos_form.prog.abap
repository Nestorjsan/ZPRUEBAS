*&---------------------------------------------------------------------*
*& Include          ZDEVTEXTOS_FORM
*&---------------------------------------------------------------------*

FORM f_consulta_texto.

  g_c_nomtex = pa_tex.
  CONDENSE g_c_nomtex.

  SELECT SINGLE tdname INTO g_c_tdname
     FROM stxh
      WHERE tdname = pa_tex.
  IF sy-subrc EQ 0.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = 'ST'             "ID del texto
        language                = 'S'              "Idioma
        name                    = g_c_nomtex       "Texto
        object                  = 'TEXT'           "Esto es constante
      IMPORTING
        header                  = g_es_header
      TABLES
        lines                   = g_ti_lineas
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.

    g_d_fila = 1.
    LOOP AT g_ti_lineas INTO g_c_lineas.

      CASE g_d_fila.

        WHEN 1.
          g_c_texto1 = g_c_lineas-tdline.
        WHEN 2.
          g_c_texto2 = g_c_lineas-tdline.
        WHEN 3.
          g_c_texto3 = g_c_lineas-tdline.
        WHEN 4.
          g_c_texto4 = g_c_lineas-tdline.
        WHEN 5.
          g_c_texto5 = g_c_lineas-tdline.
        WHEN 6.
          g_c_texto6 = g_c_lineas-tdline.
        WHEN 7.
          g_c_texto7 = g_c_lineas-tdline.
        WHEN 8.
          g_c_texto8 = g_c_lineas-tdline.
        WHEN 9.
          g_c_texto9 = g_c_lineas-tdline.
        WHEN 10.
          g_c_texto10 = g_c_lineas-tdline.
      ENDCASE.

      g_d_fila = g_d_fila + 1.

    ENDLOOP.

    CONCATENATE g_c_texto1 ' ' g_c_texto2 ' ' g_c_texto3 ' ' g_c_texto4 ' ' g_c_texto5 ' '
                g_c_texto6 ' ' g_c_texto7 ' ' g_c_texto8 ' ' g_c_texto9 ' ' g_c_texto10 INTO g_c_texto.
    REPLACE '<N>' WITH space INTO g_c_texto.
    REPLACE '</>' WITH space INTO g_c_texto.
    CONDENSE g_c_texto.

    SELECT SINGLE low INTO g_c_low
           FROM tvarvc
      WHERE name = text-003.
    IF sy-subrc EQ 0.
      CONCATENATE 'N.-' g_c_texto INTO g_c_pos_01.
      CONDENSE g_c_pos_01.
      g_d_contador = strlen( g_c_pos_01 ).
      g_c_texnum = g_d_contador.
      CONDENSE g_c_texnum .
      IF g_d_contador > g_c_low.
        CONCATENATE 'El texto ' g_c_nomtex ' Sobrepasa la cantidad de ' g_c_low ' caracteres permitidos, tiene ' g_c_texnum ' => '  g_c_pos_01 INTO g_c_message SEPARATED BY space.
      ELSE.
        CONCATENATE 'El texto ' g_c_nomtex ' No excede la cantidad de ' g_c_low ' caracteres permitidos => '  g_c_pos_01 INTO  g_c_message SEPARATED BY space.
      ENDIF.
      MESSAGE g_c_message TYPE 'I'.
    ELSE.
      CONCATENATE 'La variable ' TEXT-003 ' No está creada en la tabla de parametros TVARVC' INTO  g_c_message SEPARATED BY space.
      MESSAGE g_c_message TYPE 'I'.
    ENDIF.
  ELSE.
    CONCATENATE 'El texto ' g_c_nomtex ' No Está Creado' INTO g_c_message SEPARATED BY space.
    MESSAGE g_c_message TYPE 'I'.
  ENDIF.
  CLEAR: g_c_message, g_c_texto1,  g_c_texto2,  g_c_texto3,  g_c_texto4,  g_c_texto5,
         g_c_texto6,  g_c_texto7 , g_c_texto8 , g_c_texto9 , g_c_texto10, g_c_texto,
         g_c_pos_01.
ENDFORM.
