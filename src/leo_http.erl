%%======================================================================
%%
%% Leo Commons
%%
%% Copyright (c) 2012 Rakuten, Inc.
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
%% ---------------------------------------------------------------------
%% leo_http  - Utils for Gateway's HTTP logic
%% @doc
%% @end
%%======================================================================
-module(leo_http).

-author('Yoshiyuki Kanno').
-author('Yosuke Hara').

-export([key/2, key/3,
         get_headers/2, get_headers/3, get_amz_headers/1]).

-include("leo_commons.hrl").

%% @doc generate the global uniq key used by internal
%%
-spec(key(string(), string()) ->
             string()).
key(Host, Path) ->
    key(?S3_DEFAULT_ENDPOINT, Host, Path).
-spec(key(string(), string(), string()) ->
             string()).
key(EndPoint, Host, Path) ->
    case string:str(Host, EndPoint) of
        %% Bucket equals Host
        0 ->
            [Top|_] = string:tokens(Path, "/"),
            case string:equal(Host, Top) of
                true ->
                    "/" ++ Key = Path,
                    Key;
                false ->
                    Key = Host ++ Path,
                    Key
            end;
        %% Bucket is included in Path
        1 ->
            "/" ++ Key = Path,
            Key;
        %% Bucket is included in Host
        %% strip .s3.amazonaws.com
        Index ->
            Bucket = string:substr(Host, 1, Index - 2),
            Key = Bucket ++ Path,
            Key
    end.

is_amz_header(Key, _Val) ->
    LowerKey = string:to_lower(Key),
    case string:str(LowerKey, "x-amz-") of
        0 -> false;
        1 -> true;
        _ -> false
    end.

get_headers(TreeHeaders, FilterFun) when is_function(FilterFun) ->
    Iter = gb_trees:iterator(TreeHeaders),
    get_headers(Iter, FilterFun, []).
get_headers(Iter, FilterFun, Acc) ->
    case gb_trees:next(Iter) of
        none ->
            Acc;
        {Key, Val, Iter2} ->
            case FilterFun(Key, Val) of
                true ->  get_headers(Iter2, FilterFun, [{Key,Val}|Acc]);
                false -> get_headers(Iter2, FilterFun, Acc)
            end
    end.

get_amz_headers(TreeHeaders) ->
    get_headers(TreeHeaders, fun is_amz_header/2).
