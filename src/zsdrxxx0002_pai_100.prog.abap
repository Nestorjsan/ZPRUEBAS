*----------------------------------------------------------------------*
***INCLUDE ZSDRXXX0002_PAI_100.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
CASE OK_CODE.
  WHEN 'BACK'.
    LEAVE TO SCREEN 0.
  WHEN 'EXIT'.
    LEAVE PROGRAM.
  WHEN 'CANCEL'.
    LEAVE TO SCREEN 0.
  WHEN '&MODIFICAR'.
    PERFORM modificar_registro.

  WHEN OTHERS.
ENDCASE.



ENDMODULE.
