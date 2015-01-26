-module(big_hive).
-compile(export_all).

-define(HOST, 'elx13412sg-zw').
-define(APPDIR, " -pa ebin/ ").

create_slave_hive(HiveName) ->
    case slave:start_link(?HOST, HiveName, ?APPDIR) of
	{ok, Node} ->
	    Node
    end.

start_app_on_slave_hive(SlaveName) ->
    rpc:call(SlaveName, application, start, [distributed_honeymaker]).

destroy_none_parent_hive() ->
    1 + 1.

gen_ran_name() ->
    Name = lists:map(fun(_) ->random:uniform(26) + 64 end,
		     lists:seq(1,7)),
    list_to_atom(Name).
