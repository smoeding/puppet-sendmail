# canonify_array.pp --- Canonify an array
#
# The function expects an array of strings as input.
# It rewrites the input array the following way:
# - strip spaces from the beginning and end of each string
# - remove duplicate entries
# - sort the result
#
function sendmail::canonify_array(Array[String] $arg) >> Array[String] {
  # strip items and set to undef if empty
  $sparse_array = Array($arg).map |$item| {
    $stripped_item = strip($item)

    empty($stripped_item) ? {
      true    => undef,
      default => $stripped_item,
    }
  }

  # remove empty items from array
  $filtered_array =  $sparse_array.filter |$item| { !empty($item) }

  # sort result and filter duplicates
  unique(sort($filtered_array))
}
