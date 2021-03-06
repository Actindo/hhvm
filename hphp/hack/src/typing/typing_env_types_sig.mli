(**
 * Copyright (c) 2015, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the "hack" directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 *)

 open Typing_defs
 module TySet = Typing_set
 module type S = sig

 type fake_members = {
   last_call : Pos.t option;
   invalid   : SSet.t;
   valid     : SSet.t;
 }
 (* Along with a type, each local variable has a expression id associated with
  * it. This is used when generating expression dependent types for the 'this'
  * type. The idea is that if two local variables have the same expression_id
  * then they refer to the same late bound type, and thus have compatible
  * 'this' types.
  *)
 type expression_id = Ident.t
 type local = locl ty * expression_id
 type local_history = locl ty list
 type old_local = locl ty list * locl ty * expression_id
 type tparam_bounds = locl ty list
 type tparam_info = {
   lower_bounds : TySet.t;
   upper_bounds : TySet.t;
 }
 type tpenv = tparam_info SMap.t
 type local_types = (local Local_id.Map.t) Typing_continuations.Map.t

 (* Local environment includes types of locals and bounds on type parameters. *)
 type local_env = {
   fake_members       : fake_members;
   local_types        : local_types;
   local_mutability   : Typing_mutability_env.mutability_env;
   local_type_history : local_history Local_id.Map.t;
   (* Local variables that were assigned in a `using` clause *)
   local_using_vars   : Local_id.Set.t;
   (* Type parameter environment
    * Lower and upper bounds on generic type parameters and abstract types
    * For constraints of the form Tu <: Tv where both Tu and Tv are type
    * parameters, we store an upper bound for Tu and a lower bound for Tv.
    * Contrasting with tenv and subst, bounds are *assumptions* for type
    * inference, not conclusions.
    *)
   tpenv              : tpenv;
 }

 type env = {
   pos     : Pos.t      ;
   (* Position and reason information on entry to a subtype or unification check *)
   outer_pos : Pos.t;
   outer_reason : Typing_reason.ureason;
   tenv    : locl ty IMap.t ;
   subst   : int IMap.t ;
   lenv    : local_env  ;
   genv    : genv       ;
   decl_env: Decl_env.env;
   todo    : tfun list  ;
   in_loop : bool       ;
   inside_constructor: bool;
   (* A set of constraints that are global to a given method *)
   global_tpenv : tpenv ;
 }
and reactivity = Normal | Local | Reactive
and return_info = {
  return_type : locl ty;
  return_disposable : bool;
  return_explicit : bool;
}
and genv = {
  tcopt   : TypecheckerOptions.t;
  return  : return_info;
  (* For each function parameter, its type and calling convention. *)
  params  : (locl ty * param_mode) Local_id.Map.t;
  parent_id : string;
  parent  : decl ty;
  (* Identifier of the enclosing class *)
  self_id : string;
  (* Type of the enclosing class, instantiated at its generic parameters *)
  self    : locl ty;
  static  : bool;
  fun_kind : Ast.fun_kind;
  fun_reactive : reactivity;
  fun_mutable : bool;
  anons   : anon IMap.t;
  file    : Relative_path.t;
}

(* A type-checker for an anonymous function
 * Parameters are
 * - the environment
 * - types of the parameters under which the body should be checked
 * - the expected return type of the body (optional)
 *)
and anon =
  Nast.is_reactive *
  Nast.is_coroutine *
  (?el:Nast.expr list ->
  ?ret_ty: locl ty ->
  env ->
  locl fun_params ->
  env * Tast.expr * locl ty)

(* A deferred check; return true if the check should now be removed from the list *)
 and tfun = env -> env * bool
end
