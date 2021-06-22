@echo off

REM Remember to create "liberr" and "comperr" directories from the
REM current directory before using these batch files.  Either that
REM or get rid of the " > liberr\%1.err" bits.

REM Also, REMEMBER that this batch file calls the ccomp batch file - so
REM you do not need to use ccomp.bat to compile the c routines.

REM **************************************************************************
REM * Begin the Klipper "C" compilation
REM **************************************************************************

ECHO COMPILING .C SOURCE (KF95c.lib)
ECHO *************************************************************************

DEL KF95c.lib  > nul
DEL KF95.lib   > nul
DEL listfile.txt     > nul

echo Y|DEL comperr > nul
echo Y|DEL liberr  > nul

CALL ccomp arraylen   NOUPDATE
CALL ccomp crypto     NOUPDATE
CALL ccomp cryptohi   NOUPDATE
CALL ccomp int2b      NOUPDATE
CALL ccomp int2lb     NOUPDATE
CALL ccomp b2int      NOUPDATE
CALL ccomp fcrc       NOUPDATE
CALL ccomp exename

REM **************************************************************************
REM * Begin Regular KF95 Clipper Compilation
REM **************************************************************************

ECHO COMPILING .PRG SOURCE (KF95.lib)
ECHO *************************************************************************

CALL klipcomp  alen__    NOUPDATE
CALL klipcomp  encryp__  NOUPDATE
CALL klipcomp  fopen__   NOUPDATE
CALL klipcomp  log__     NOUPDATE
CALL klipcomp  gat__     NOUPDATE
CALL klipcomp  lprint__  NOUPDATE
CALL klipcomp  reidx__   NOUPDATE
CALL klipcomp  scat__    NOUPDATE
CALL klipcomp  select__  NOUPDATE
CALL klipcomp  setcol__  NOUPDATE
CALL klipcomp  setsta__  NOUPDATE
CALL klipcomp  setidx__  NOUPDATE
CALL klipcomp  2comp     NOUPDATE
CALL klipcomp  aaverage  NOUPDATE
CALL klipcomp  ack       NOUPDATE
CALL klipcomp  add       NOUPDATE
CALL klipcomp  ahighele  NOUPDATE
CALL klipcomp  ahighval  NOUPDATE
CALL klipcomp  all_alph  NOUPDATE
CALL klipcomp  allfield  NOUPDATE
CALL klipcomp  alowele   NOUPDATE
CALL klipcomp  alowval   NOUPDATE
CALL klipcomp  amaxslen  NOUPDATE
CALL klipcomp  amaxsele  NOUPDATE
CALL klipcomp  and       NOUPDATE
CALL klipcomp  antilog   NOUPDATE
CALL klipcomp  ap        NOUPDATE
CALL klipcomp  appkill   NOUPDATE
CALL klipcomp  appxequa  NOUPDATE
CALL klipcomp  arr2str   NOUPDATE
CALL klipcomp  arraytxt  NOUPDATE
CALL klipcomp  asum      NOUPDATE
CALL klipcomp  attn      NOUPDATE
CALL klipcomp  basx2dec  NOUPDATE
CALL klipcomp  bgraphh   NOUPDATE
CALL klipcomp  bgraphv   NOUPDATE
CALL klipcomp  bigstuff  NOUPDATE
CALL klipcomp  bold      NOUPDATE
CALL klipcomp  box       NOUPDATE
CALL klipcomp  btoi      NOUPDATE
CALL klipcomp  bx2by     NOUPDATE
CALL klipcomp  capfirst  NOUPDATE
CALL klipcomp  cascade   NOUPDATE
CALL klipcomp  cdbl2cln  NOUPDATE
CALL klipcomp  cdbl2cld  NOUPDATE
CALL klipcomp  ch_count  NOUPDATE
CALL klipcomp  charstr   NOUPDATE
CALL klipcomp  checkdrv  NOUPDATE
CALL klipcomp  checkntx  NOUPDATE
CALL klipcomp  checkset  NOUPDATE
CALL klipcomp  checksum  NOUPDATE
CALL klipcomp  chrlimit  NOUPDATE
CALL klipcomp  clr       NOUPDATE
CALL klipcomp  clrwin    NOUPDATE
CALL klipcomp  color2nu  NOUPDATE
CALL klipcomp  colorify  NOUPDATE
CALL klipcomp  colorof   NOUPDATE
CALL klipcomp  colorsay  NOUPDATE
CALL klipcomp  comprec   NOUPDATE
CALL klipcomp  convert   NOUPDATE
CALL klipcomp  ctr       NOUPDATE
CALL klipcomp  ctr_var   NOUPDATE
CALL klipcomp  curvol    NOUPDATE
CALL klipcomp  dayfirst  NOUPDATE
CALL klipcomp  daylast   NOUPDATE
CALL klipcomp  daysbtwn  NOUPDATE
CALL klipcomp  daysmon   NOUPDATE
CALL klipcomp  dbchoice  NOUPDATE
CALL klipcomp  dec2basx  NOUPDATE
CALL klipcomp  dial      NOUPDATE
CALL klipcomp  doy       NOUPDATE
CALL klipcomp  duprec    NOUPDATE
CALL klipcomp  extract   NOUPDATE
CALL klipcomp  f_lock    NOUPDATE
CALL klipcomp  false     NOUPDATE
CALL klipcomp  fcombine  NOUPDATE
CALL klipcomp  fcopybyt  NOUPDATE
CALL klipcomp  fdate     NOUPDATE
CALL klipcomp  fdelete   NOUPDATE
CALL klipcomp  feof      NOUPDATE
CALL klipcomp  fieldstr  NOUPDATE
CALL klipcomp  file2var  NOUPDATE
CALL klipcomp  filebox   NOUPDATE
CALL klipcomp  filebrow  NOUPDATE
CALL klipcomp  fileobro  NOUPDATE
CALL klipcomp  fin       NOUPDATE
CALL klipcomp  fioconv   NOUPDATE
CALL klipcomp  firstnon  NOUPDATE
CALL klipcomp  fout      NOUPDATE
CALL klipcomp  fpeekbyt  NOUPDATE
CALL klipcomp  fscreen   NOUPDATE
CALL klipcomp  fseek     NOUPDATE
CALL klipcomp  fselect   NOUPDATE
CALL klipcomp  fsize     NOUPDATE
CALL klipcomp  fwriteli  NOUPDATE
CALL klipcomp  fx286MS   NOUPDATE
CALL klipcomp  getkey    NOUPDATE
CALL klipcomp  getnum    NOUPDATE
CALL klipcomp  getstr    NOUPDATE
CALL klipcomp  hilight   NOUPDATE
CALL klipcomp  hprintf   NOUPDATE
CALL klipcomp  htoi      NOUPDATE
CALL klipcomp  importp   NOUPDATE
CALL klipcomp  inarray   NOUPDATE
CALL klipcomp  indxflds  NOUPDATE
CALL klipcomp  initwin   NOUPDATE
CALL klipcomp  inrange   NOUPDATE
CALL klipcomp  isaverag  NOUPDATE
CALL klipcomp  isdbf     NOUPDATE
CALL klipcomp  isdbfmem  NOUPDATE
CALL klipcomp  isenvvar  NOUPDATE
CALL klipcomp  isprcnt   NOUPDATE
CALL klipcomp  itob      NOUPDATE
CALL klipcomp  itobs     NOUPDATE
CALL klipcomp  itoh      NOUPDATE
CALL klipcomp  isopen    NOUPDATE
CALL klipcomp  k_arg     NOUPDATE
CALL klipcomp  keylist   NOUPDATE
CALL klipcomp  killwin   NOUPDATE
CALL klipcomp  kmenu     NOUPDATE
CALL klipcomp  lockkey   NOUPDATE
CALL klipcomp  longsecs  NOUPDATE
CALL klipcomp  l_space   NOUPDATE
CALL klipcomp  linedava  NOUPDATE
CALL klipcomp  linedget  NOUPDATE
CALL klipcomp  linedkil  NOUPDATE
CALL klipcomp  linedput  NOUPDATE
CALL klipcomp  linedsiz  NOUPDATE
CALL klipcomp  makedict  NOUPDATE
CALL klipcomp  memarray  NOUPDATE
CALL klipcomp  memo2fil  NOUPDATE
CALL klipcomp  menua     NOUPDATE
CALL klipcomp  menu      NOUPDATE
CALL klipcomp  metric    NOUPDATE
CALL klipcomp  msg       NOUPDATE
CALL klipcomp  mult      NOUPDATE
CALL klipcomp  nearest   NOUPDATE
CALL klipcomp  neon      NOUPDATE
CALL klipcomp  newrec    NOUPDATE
CALL klipcomp  nth_occ   NOUPDATE
CALL klipcomp  ntxkey    NOUPDATE
CALL klipcomp  nullify   NOUPDATE
CALL klipcomp  num2colo  NOUPDATE
CALL klipcomp  or        NOUPDATE
CALL klipcomp  parsef    NOUPDATE
CALL klipcomp  parsefe   NOUPDATE
CALL klipcomp  parsefn   NOUPDATE
CALL klipcomp  parseide  NOUPDATE
CALL klipcomp  password  NOUPDATE
CALL klipcomp  peekset   NOUPDATE
CALL klipcomp  popbox    NOUPDATE
CALL klipcomp  popscrsv  NOUPDATE
CALL klipcomp  popset    NOUPDATE
CALL klipcomp  prcntis   NOUPDATE
CALL klipcomp  prepare   NOUPDATE
CALL klipcomp  primaryk  NOUPDATE
CALL klipcomp  prntfile  NOUPDATE
CALL klipcomp  prnttext  NOUPDATE
CALL klipcomp  pullcap   NOUPDATE
CALL klipcomp  pulltext  NOUPDATE
CALL klipcomp  pushset   NOUPDATE
CALL klipcomp  q_close   NOUPDATE
CALL klipcomp  q_confir  NOUPDATE
CALL klipcomp  q_open    NOUPDATE
CALL klipcomp  qdecrypt  NOUPDATE
CALL klipcomp  qencrypt  NOUPDATE
CALL klipcomp  r_lock    NOUPDATE
CALL klipcomp  readf     NOUPDATE
CALL klipcomp  readline  NOUPDATE
CALL klipcomp  recolor   NOUPDATE
CALL klipcomp  reverse   NOUPDATE
CALL klipcomp  ruler     NOUPDATE
CALL klipcomp  s_use     NOUPDATE
CALL klipcomp  savescrn  NOUPDATE
CALL klipcomp  scrnscan  NOUPDATE
CALL klipcomp  setusrpr  NOUPDATE
CALL klipcomp  selusrpr  NOUPDATE
CALL klipcomp  skipnext  NOUPDATE
CALL klipcomp  slidebox  NOUPDATE
CALL klipcomp  snatch    NOUPDATE
CALL klipcomp  srchpath  NOUPDATE
CALL klipcomp  str2arr   NOUPDATE
CALL klipcomp  stradd    NOUPDATE
CALL klipcomp  strrem    NOUPDATE
CALL klipcomp  strtempl  NOUPDATE
CALL klipcomp  subuntil  NOUPDATE
CALL klipcomp  sys_help  NOUPDATE
CALL klipcomp  t_space   NOUPDATE
CALL klipcomp  termnate  NOUPDATE
CALL klipcomp  textbrow  NOUPDATE
CALL klipcomp  ticker    NOUPDATE
CALL klipcomp  timer     NOUPDATE
CALL klipcomp  to_char   NOUPDATE
CALL klipcomp  to_power  NOUPDATE
CALL klipcomp  to_prn    NOUPDATE
CALL klipcomp  to_scr    NOUPDATE
CALL klipcomp  true      NOUPDATE
CALL klipcomp  txtarray  NOUPDATE
CALL klipcomp  underln   NOUPDATE
CALL klipcomp  updtwin   NOUPDATE
CALL klipcomp  var2file  NOUPDATE
CALL klipcomp  wait      NOUPDATE
CALL klipcomp  waitfor   NOUPDATE
CALL klipcomp  which_e   NOUPDATE
CALL klipcomp  workarea  NOUPDATE
CALL klipcomp  wspopssv  NOUPDATE
CALL klipcomp  wssavscr  NOUPDATE
CALL klipcomp  wssvscr   NOUPDATE
CALL klipcomp  x_use     NOUPDATE
CALL klipcomp  xdup      NOUPDATE
CALL klipcomp  xlog      NOUPDATE
CALL klipcomp  xor       NOUPDATE
CALL klipcomp  xors

