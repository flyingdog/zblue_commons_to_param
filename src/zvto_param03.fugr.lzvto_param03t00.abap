*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVTO_PARAM03....................................*
TABLES: ZVTO_PARAM03, *ZVTO_PARAM03. "view work areas
CONTROLS: TCTRL_ZVTO_PARAM03
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVTO_PARAM03. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVTO_PARAM03.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVTO_PARAM03_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVTO_PARAM03.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVTO_PARAM03_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVTO_PARAM03_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVTO_PARAM03.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVTO_PARAM03_TOTAL.

*.........table declarations:.................................*
TABLES: ZTO_PARAM03                    .
