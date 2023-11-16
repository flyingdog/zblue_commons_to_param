*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVTO_PARAM02....................................*
TABLES: ZVTO_PARAM02, *ZVTO_PARAM02. "view work areas
CONTROLS: TCTRL_ZVTO_PARAM02
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVTO_PARAM02. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVTO_PARAM02.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVTO_PARAM02_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVTO_PARAM02.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVTO_PARAM02_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVTO_PARAM02_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVTO_PARAM02.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVTO_PARAM02_TOTAL.

*.........table declarations:.................................*
TABLES: ZTO_PARAM02                    .
