# @summary Add the `QUEUE_GROUP` macro to the sendmail.mc file.
#
# @example Create a queue group named `gmailcom` for single recipient delivery
#   sendmail::mc::queue_group { 'gmailcom':
#     flags      => 'f',
#     interval   => '60m',
#     path       => '/var/spool/mqueues/gmail',
#     recipients => 1,
#   }
#
# @param queue_group The name of the queue group.
#
# @param flags Flags for the queue group.  Currently only the `f` flag is
#   supported and causes Sendmail to create one queue process for each queue
#   directory in the group.
#
# @param interval The interval specifies the time interval between queue runs
#   for the queue group.  The parameter value should be an integer and
#   a letter (e.g. `10m`).  The letters `w` (week), `d` (day), `h` (hour),
#   `m` (minute) and `s` (second) are allowed.
#
# @param jobs This parameter limits the number of queue entries that will be
#   processed in a single queue run.
#
# @param nice Set the nice-level for the queue group processor.  Using
#   a positive number will increase the nice-level by the given number.  This
#   results in the process to run with a reduced priority.
#
# @param recipients The number of recipients that are processed in a single
#   delivery before splitting.
#
# @param runners The number of queue runners to lauch for this queue group.
#
# @param path The location of the queue directory for this queue group.  The
#   parameter must be an absolute path and must be a subdirectory of the
#   default queue directory configured by the `QueueDirectory` option.
#
#
define sendmail::mc::queue_group (
  String                         $queue_group = $name,
  Optional[String]               $flags       = undef,
  Optional[String]               $interval    = undef,
  Optional[Integer]              $jobs        = undef,
  Optional[Integer]              $nice        = undef,
  Optional[Integer]              $recipients  = undef,
  Optional[Integer]              $runners     = undef,
  Optional[Stdlib::Absolutepath] $path        = undef,
) {
  # Include section
  include sendmail::mc::queue_group_section

  $sparse_opts = {
    'F' => $flags,
    'I' => $interval,
    'J' => $jobs,
    'N' => $nice,
    'r' => $recipients,
    'R' => $runners,
    'P' => $path,
  }

  # Remove unset options
  $real_opts = $sparse_opts.filter |$key,$val| { !empty($val) }

  $opts = join(join_keys_to_values($real_opts, '='), ', ')

  concat::fragment { "sendmail_mc-queue_group-${title}":
    target  => 'sendmail.mc',
    order   => '34',
    content => "QUEUE_GROUP(`${queue_group}', `${opts}')dnl\n",
  }
}
