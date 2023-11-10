*&---------------------------------------------------------------------*
*& Include          ZSDRXXX0004_FORM
*&---------------------------------------------------------------------*


FORM f_generar_smartform  USING p_ti_smartform TYPE g_tp_tt_smartform
                                p_c_print_ok   TYPE char1.

  DATA p_c_pdf TYPE char1.

  DATA: it_otf                  TYPE STANDARD TABLE OF itcoo,
        it_docs                 TYPE STANDARD TABLE OF docs,
        it_lines                TYPE STANDARD TABLE OF tline,
        st_job_output_info      TYPE ssfcrescl,
        st_document_output_info TYPE ssfcrespd,
        st_job_output_options   TYPE ssfcresop,
        "st_output_options       TYPE ssfcompop,
        "st_control_parameters   TYPE ssfctrlop,
        obj_len                 TYPE so_obj_len,
        idioma                  TYPE sflangu VALUE 'S',
        devtype                 TYPE rspoptype,
        bin_filesize            TYPE i,
        nombre_archivo          TYPE string,
        ruta                    TYPE string,
        ruta_completa           TYPE string,
        filtro                  TYPE string,
        uact                    TYPE i,
        guiobj                  TYPE REF TO cl_gui_frontend_services,
        filename                TYPE string,
        nombre_formulario       TYPE rs38l_fnam,
        p_form                  TYPE char12.

  "No visualizar el dialogo de impresion.
  DATA(st_control_parameters) = VALUE ssfctrlop( no_dialog = abap_true
                                                       preview   = ' '
                                                       getotf    = abap_true ).

  "Deshabiltar la vista previa del smartform
  DATA(st_output_options) = VALUE ssfcompop( tdnoprev  =  abap_true
                                             tdprinter = devtype ).
  p_c_pdf = '0'.

  IF p_c_pdf = '1'.


*.Declaración de variables locales.
    DATA: gv_devtype TYPE rspoptype,
          g_settings TYPE tdbool.

    CLEAR:gf_fm_name, ges_control_param,ges_composer_param,
          ges_docinfo,ges_jobinfo,g_settings,p_c_print_ok.


*.obtener el nombre del formato.
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZSDFAPV001'
      IMPORTING
        fm_name            = gf_fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.


*.ajustar los parametros de impresión.
    IF sy-subrc EQ 0.
*.....Obtener el tipo de dispositivo
      CALL FUNCTION 'SSF_GET_DEVICE_TYPE'
        EXPORTING
          i_language             = sy-langu
        IMPORTING
          e_devtype              = gv_devtype
        EXCEPTIONS
          no_language            = 1
          language_not_installed = 2
          no_devtype_found       = 3
          system_error           = 4
          OTHERS                 = 5.

*...Parámetros de impresión
      ges_composer_param-tdprinter = gv_devtype.
      ges_composer_param-tdnoprev  = abap_on  .  " Sin visualiz. previa
      ges_composer_param-tdnoprint = abap_off.   " No imprimir
      ges_composer_param-tdnoarch  = abap_on.    " No archivar
      ges_composer_param-tddest    = 'LP01'.     " Dispositivo de salida
      ges_composer_param-tdimmed   = abap_off.   " Sin salida inmediata
      ges_composer_param-tddelete  = abap_on.    " No borrar tras salida
      ges_composer_param-tdnewid   = abap_on.    " Nueva orden spool
      ges_composer_param-tdfinal   = abap_on.    " Cerrar orden de spool
      ges_composer_param-tdarmod   = '1'.        " Solo imprimir
      ges_composer_param-tdcopies  = '001'.      " Cantidad de copias
      ges_control_param-no_dialog  = abap_on.    " Sin ventana dialogo
      ges_control_param-device     = 'PRINTER'.  " Dispositivo
*    ges_control_param-preview    = abap_on.    " Vista Preeliminar

*...Llamada al smartforms

      CALL FUNCTION gf_fm_name
*      EXPORTING
*        "control_parameters   = ges_control_param
*        "output_options       = ges_composer_param
*        "user_settings        = abap_off
*      IMPORTING
*        "document_output_info = ges_docinfo
*        "job_output_info      = ges_jobinfo
        TABLES
          g_ti_smartform   = p_ti_smartform
        EXCEPTIONS
          formatting_error = 1
          internal_error   = 2
          send_error       = 3
          user_canceled    = 4
          OTHERS           = 5.
      IF sy-subrc EQ 0.
        p_c_print_ok = abap_on.
      ENDIF.
    ENDIF.
  ELSE.
    IF p_c_pdf = '2'.

      CALL FUNCTION 'SSF_GET_DEVICE_TYPE'
        EXPORTING
          i_language             = sy-langu
        IMPORTING
          e_devtype              = gv_devtype
        EXCEPTIONS
          no_language            = 1
          language_not_installed = 2
          no_devtype_found       = 3
          system_error           = 4
          OTHERS                 = 5.


      "st_output_options-tdprinter = devtype.
      "st_control_parameters-no_dialog = 'X'. "Ocultar dialogo
      "st_control_parameters-getotf = 'X'.

      "Obtener el nombre del formulario
      CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
        EXPORTING
          formname           = 'ZSDFAPV001'
        IMPORTING
          fm_name            = gf_fm_name
        EXCEPTIONS
          no_form            = 1
          no_function_module = 2
          OTHERS             = 3.

      "Llamar al formulario
      " ************************************************************
      " No olvidar agregar los parametros que use tu formulario
      " ************************************************************

      CALL FUNCTION gf_fm_name
        EXPORTING
          control_parameters   = st_control_parameters
          output_options       = st_output_options
        IMPORTING
          document_output_info = st_document_output_info
          job_output_info      = st_job_output_info
          job_output_options   = st_job_output_options
        TABLES
          g_ti_smartform       = p_ti_smartform
        EXCEPTIONS
          formatting_error     = 1
          internal_error       = 2
          send_error           = 3
          user_canceled        = 4
          OTHERS               = 5.

      "Convertir a PDF
      CALL FUNCTION 'CONVERT_OTF_2_PDF'
        IMPORTING
          bin_filesize           = bin_filesize
        TABLES
          otf                    = st_job_output_info-otfdata
          doctab_archive         = it_docs
          lines                  = it_lines
        EXCEPTIONS
          err_conv_not_possible  = 1
          err_otf_mc_noendmarker = 2
          OTHERS                 = 3.

      "Conseguir el nombre del archivo pdf
      p_form = 'Factura'.
      CONCATENATE p_form pa_fac '.pdf' INTO nombre_archivo.

      CREATE OBJECT guiobj.
      CALL METHOD guiobj->file_save_dialog
        EXPORTING
          default_extension = 'pdf'
          default_file_name = nombre_archivo
          file_filter       = filtro
        CHANGING
          filename          = nombre_archivo
          path              = ruta
          fullpath          = ruta_completa
          user_action       = uact.
      IF uact = guiobj->action_cancel.
        EXIT.
      ENDIF.

      "Descargar a la computadora
      MOVE ruta_completa TO filename.
      CALL FUNCTION 'GUI_DOWNLOAD'
        EXPORTING
          bin_filesize            = bin_filesize
          filename                = filename
          filetype                = 'BIN'
        TABLES
          data_tab                = it_lines
        EXCEPTIONS
          file_write_error        = 1
          no_batch                = 2
          gui_refuse_filetransfer = 3
          invalid_type            = 4
          no_authority            = 5
          unknown_error           = 6
          header_not_allowed      = 7
          separator_not_allowed   = 8
          filesize_not_allowed    = 9
          header_too_long         = 10
          dp_error_create         = 11
          dp_error_send           = 12
          dp_error_write          = 13
          unknown_dp_error        = 14
          access_denied           = 15
          dp_out_of_memory        = 16
          disk_full               = 17
          dp_timeout              = 18
          file_not_found          = 19
          dataprovider_exception  = 20
          control_flush_error     = 21
          OTHERS                  = 22.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ELSE.
      CALL FUNCTION 'SSF_GET_DEVICE_TYPE'
        EXPORTING
          i_language             = sy-langu
        IMPORTING
          e_devtype              = gv_devtype
        EXCEPTIONS
          no_language            = 1
          language_not_installed = 2
          no_devtype_found       = 3
          system_error           = 4
          OTHERS                 = 5.


      "st_output_options-tdprinter = devtype.
      "st_control_parameters-no_dialog = 'X'. "Ocultar dialogo
      "st_control_parameters-getotf = 'X'.

      "Obtener el nombre del formulario
      CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
        EXPORTING
          formname           = 'ZSDFAPV001'
        IMPORTING
          fm_name            = gf_fm_name
        EXCEPTIONS
          no_form            = 1
          no_function_module = 2
          OTHERS             = 3.

      "Llamar al formulario
      " ************************************************************
      " No olvidar agregar los parametros que use tu formulario
      " ************************************************************

      CALL FUNCTION gf_fm_name
        EXPORTING
          control_parameters   = st_control_parameters
          output_options       = st_output_options
        IMPORTING
          document_output_info = st_document_output_info
          job_output_info      = st_job_output_info
          job_output_options   = st_job_output_options
        TABLES
          g_ti_smartform       = p_ti_smartform
        EXCEPTIONS
          formatting_error     = 1
          internal_error       = 2
          send_error           = 3
          user_canceled        = 4
          OTHERS               = 5.

*      Convertir OTF a PDF xtring
      CALL FUNCTION 'CONVERT_OTF'
        EXPORTING
          format                = gc_format
        IMPORTING
          bin_filesize          = bin_filesize
        TABLES
          otf                   = st_job_output_info-otfdata
          lines                 = it_lines
        EXCEPTIONS
          err_max_linewidth     = 1
          err_format            = 2
          err_conv_not_possible = 3
          err_bad_otf           = 4
          OTHERS                = 5.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      DATA: mv_pdf_content TYPE solix_tab,
            mv_pdf_zize    TYPE so_obj_len.

*      Customer data
      DATA: mv_mail  TYPE adr6-smtp_addr,
            mv_name1 TYPE name1_gp.

*      PDF
      FIELD-SYMBOLS <l_xline> TYPE x.

*      DATA pdf_xstring TYPE xstring.

      LOOP AT it_lines INTO DATA(ls_lines).
        ASSIGN ls_lines TO <l_xline> CASTING.
        CONCATENATE pdf_xstring <l_xline> INTO DATA(pdf_xstring) IN BYTE MODE.
      ENDLOOP.

*     PDF Xtring to solix
*     Se utiliza un Wrapper Classe for office documents BCS Business comunicantion services.
*     Se utiliza la clase cl_document_bcs

      mv_pdf_zize    = xstrlen( pdf_xstring ).
      mv_pdf_content = cl_document_bcs=>xstring_to_solix( ip_xstring = pdf_xstring ).

*      Contrucción del Email

    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_CONSULTA_DATOS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_consulta_datos .
  SELECT  zfactura      "Número de la factura
          zcedula       "Cedula del cliente
          zcodpro       "Codigo del producto
          zdescri       "Descripción del producto
          zcantidad     "Cantidad
          zvalor        "Valor
          ztotal        "Total
          zfecfac       "Fecha Factura
           FROM ztsd0002
            INTO TABLE g_ti_smartform
           WHERE zfactura EQ pa_fac.


  PERFORM f_generar_smartform USING g_ti_smartform
                                    lc_print_ok.

ENDFORM.
