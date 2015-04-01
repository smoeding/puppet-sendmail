(*
Module: Sendmail
  Parses simple key list files used by the Sendmail MTA

Author: Stefan Moeding <stm@kill-9.net>

About: Reference

About: License

About: Lens Usage

About: Configuration files
  This lens applies to /etc/mail/relay-domains, /etc/mail/trusted-users
  and /etc/mail/local-host-names.

About: Examples
   The <Test_Sendmail_List> file contains various examples and tests.
*)

module Sendmail_List =
autoload xfm

(************************************************************************
 * Group:                     USEFUL PRIMITIVES
 ************************************************************************)

let eol     = Util.eol
let empty   = Util.empty
let comment = Util.comment

(************************************************************************
 * Group:                           VIEWS
 ************************************************************************)

(* View: key_re *)
let key_re = /[a-zA-Z0-9.:@-]+/

(* View: keyval *)
let keyval = [ key key_re . eol ]

(************************************************************************
 * Group:                       LENS & FILTER
 ************************************************************************)

let lns    = ( comment | empty | keyval )*

let filter = incl "/etc/mail/relay-domains"
           . incl "/etc/mail/trusted-users"
           . incl "/etc/mail/local-host-names"
           . Util.stdexcl

let xfm    = transform lns filter
