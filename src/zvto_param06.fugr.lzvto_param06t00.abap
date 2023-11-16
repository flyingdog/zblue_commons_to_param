*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVTO_PARAM06....................................*
TABLES: ZVTO_PARAM06, *ZVTO_PARAM06. "view work areas
CONTROLS: TCTRL_ZVTO_PARAM06
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVTO_PARAM06. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVTO_PARAM06.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVTO_PARAM06_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVTO_PARAM06.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVTO_PARAM06_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVTO_PARAM06_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVTO_PARAM06.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVTO_PARAM06_TOTAL.

*.........table declarations:.................................*
TABLES: ZTO_PARAM03                    .
