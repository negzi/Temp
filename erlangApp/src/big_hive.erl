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
    BList = binary:bin_to_list(crypto:strong_rand_bytes(4)),
    CharList = lists:map(fun(X) -> (X rem -25)  + 97 end, BList),
    list_to_atom(CharList).

