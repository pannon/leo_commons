%%====================================================================
%%
%% Leo Commons
%%
%% Copyright (c) 2012
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------
%% Mnesia Test
%% @doc
%% @end
%%====================================================================
-module(leo_date_tests).
-author('Yosuke Hara').

-include_lib("eunit/include/eunit.hrl").

%%--------------------------------------------------------------------
%% TEST
%%--------------------------------------------------------------------
-ifdef(EUNIT).
date_test_() ->
    [
     fun now_/0,
     fun clock_/0,
     fun zone_/0,
     fun date_format_/0
    ].

now_() ->
    Ret = leo_date:now(),
    ?assertEqual(true, 63515000000 < Ret),
    ok.

clock_() ->
    Ret = leo_date:clock(),
    ?assertEqual(true, 1347900000000000 < Ret),
    ok.

zone_() ->
    Ret = leo_date:zone(),
    ?assertEqual(true, undefined =/= Ret),
    ?assertEqual(true, [] =/= Ret),
    ok.

date_format_() ->
    Ret1 = leo_date:date_format(leo_date:now()),
    ?assertEqual(true, undefined =/= Ret1),
    ?assertEqual(true, [] =/= Ret1),

    Ret2 = leo_date:date_format(type_of_now, now()),
    ?assertEqual(true, undefined =/= Ret2),
    ?assertEqual(true, [] =/= Ret2),
    ok.


-endif.