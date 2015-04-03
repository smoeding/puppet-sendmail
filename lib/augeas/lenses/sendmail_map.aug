(*
Module: Sendmail
  Parses map files used by the Sendmail MTA

Author: Stefan Moeding <stm@kill-9.net>

About: Reference

About: License

About: Lens Usage

About: Configuration files
  This lens applies to /etc/mail/access, /etc/mail/authinfo,
  /etc/mail/bitdomain, /etc/mail/domaintable, /etc/mail/genericstable,
  /etc/mail/mailertable, /etc/mail/msp-authinfo, /etc/mail/userdb,
  /etc/mail/uudomain and /etc/mail/virtusertable.

About: Examples
   The <Test_Sendmail_Map> file contains various examples and tests.
*)

module Sendmail_Map =
autoload xfm

(************************************************************************
 * Group:                     USEFUL PRIMITIVES
 ************************************************************************)

let eol        = Util.eol
let empty      = Util.empty
let comment    = Util.comment
let del_ws_tab = Util.del_ws_tab

(************************************************************************
 * Group:                           VIEWS
 ************************************************************************)

(* View: key_re *)
let key_re = /[a-zA-Z0-9@.:_=\/+-]+/

(* View: val_re *)
let val_re = /[^ \t\n](.*[^ \t\n])?/

(* View: keyval *)
let keyval = [ label "key" . store key_re . del_ws_tab .
               [ label "value" . store val_re ] . eol ]

(************************************************************************
 * Group:                       LENS & FILTER
 ************************************************************************)

let lns    = ( comment | empty | keyval )*

let filter = incl "/etc/mail/access"
           . incl "/etc/mail/authinfo"
           . incl "/etc/mail/bitdomain"
           . incl "/etc/mail/domaintable"
           . incl "/etc/mail/genericstable"
           . incl "/etc/mail/mailertable"
           . incl "/etc/mail/msp-authinfo"
           . incl "/etc/mail/userdb"
           . incl "/etc/mail/uudomain"
           . incl "/etc/mail/virtusertable"
           . Util.stdexcl

let xfm    = transform lns filter
