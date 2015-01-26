-module(distributed_honeymaker_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1 ]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    dbg:tracer(),
    dbg:p(all,[c]),
    dbg:tpl(distributed_honeymaker_app,x),
    hive:start_hive("myfile").

stop(_State) ->
    ok.
