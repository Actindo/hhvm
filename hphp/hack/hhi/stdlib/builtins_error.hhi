<?hh     /* -*- php -*- */
/**
 * Copyright (c) 2014, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the "hack" directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 */
function debug_backtrace(int $options = DEBUG_BACKTRACE_PROVIDE_OBJECT, int $limit = 0) { }
<<__PHPStdLib>>
function debug_print_backtrace(int $options = 0, int $limit = 0): void { }
<<__PHPStdLib>>
function error_get_last() { }
function error_log($message, $message_type = 0, $destination = null, $extra_headers = null) { }
function error_reporting($level = null) { }
function restore_error_handler() { }
<<__PHPStdLib>>
function restore_exception_handler() { }
function set_error_handler($error_handler, $error_types = E_ALL) { }
function set_exception_handler($exception_handler) { }
function hphp_set_error_page($page) { }
function hphp_throw_fatal_error($error_msg) { }
<<__PHPStdLib>>
function hphp_clear_unflushed() { }
<<__PHPStdLib>>
function hphp_debug_caller_info() { }
<<__PHPStdLib>>
function hphp_debug_backtrace_hash() { }
<<__PHPStdLib>>
function trigger_error($error_msg, $error_type = E_USER_NOTICE) { }
<<__PHPStdLib>>
function user_error($error_msg, $error_type = E_USER_NOTICE) { }
