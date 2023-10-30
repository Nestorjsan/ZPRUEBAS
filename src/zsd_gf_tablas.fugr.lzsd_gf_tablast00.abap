*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTSD0001........................................*
DATA:  BEGIN OF STATUS_ZTSD0001                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSD0001                      .
CONTROLS: TCTRL_ZTSD0001
            TYPE TABLEVIEW USING SCREEN '0004'.
*...processing: ZTSD0003........................................*
DATA:  BEGIN OF STATUS_ZTSD0003                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSD0003                      .
CONTROLS: TCTRL_ZTSD0003
            TYPE TABLEVIEW USING SCREEN '0002'.
*...processing: ZTSD0004........................................*
DATA:  BEGIN OF STATUS_ZTSD0004                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSD0004                      .
CONTROLS: TCTRL_ZTSD0004
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZTSD0005........................................*
DATA:  BEGIN OF STATUS_ZTSD0005                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSD0005                      .
CONTROLS: TCTRL_ZTSD0005
            TYPE TABLEVIEW USING SCREEN '0006'.
*.........table declarations:.................................*
TABLES: *ZTSD0001                      .
TABLES: *ZTSD0003                      .
TABLES: *ZTSD0004                      .
TABLES: *ZTSD0005                      .
TABLES: ZTSD0001                       .
TABLES: ZTSD0003                       .
TABLES: ZTSD0004                       .
TABLES: ZTSD0005                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
