-module(big_hive).
-export([create_slave_hive/1, 
	 start_app_on_slave_hive/1, gen_ran_name/0]).

-define(HOST, 'elx13412sg-zw').
-define(APPDIR, " -pa ebin/ ").
-define(Bytes, 4).

create_slave_hive(HiveName) ->
    case slave:start_link(?HOST, HiveName, ?APPDIR) of
	{ok, Node} ->
	    Node
    end.

start_app_on_slave_hive(SlaveName) ->
    rpc:call(SlaveName, application, start, [distributed_honeymaker]).

gen_rand_crypto_bytes() ->
    binary:bin_to_list(crypto:strong_rand_bytes(?Bytes)).
    
map_rand_bytes_to_ascci(RanBytes) ->
    lists:map(fun(X) -> (X rem -25)  + 97 end, RanBytes).
    
gen_ran_name() ->
    RanBytes = gen_rand_crypto_bytes(),
    Chars = map_rand_bytes_to_ascci(RanBytes),
    list_to_atom(Chars).

