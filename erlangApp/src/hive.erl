-module(hive).
-compile(export_all).

-record(state, {queen_id,
                hive_id,
		node_name,
		comm_pid}).

-define(TOPDIR, "/home/neg/erlApp").


start_hive(File) ->
    register(?MODULE, Pid=spawn(?MODULE, init, [File])),
    {ok, Pid}.

start_link() ->
    register(?MODULE, Pid=spawn_link(?MODULE, init, [])),
    {ok, Pid}.

terminate() ->
    ?MODULE ! {shutdown}.

init(File) ->
    spawn(?MODULE, honey_maker_bee, [File]),
    Pid = spawn(?MODULE, communicator_bee_search_other_hives, [?TOPDIR]),
    loop(#state{queen_id= get_queen_id(),
		hive_id = return_hive_ref(),
		node_name = node(),
		comm_pid = Pid}).

loop(S = #state{}) ->
    receive
	{From, hi} ->
	    From ! {{?MODULE, node()}, hello},
	    loop(S);
        {From, {identify_your_self, OtherNodeInfo}} ->
	    kill_communicator_if_alive(S#state.comm_pid),
	    From ! {{?MODULE, node()},{here_is_my_info, S}},
	    io:format("i am in identify msg: ~p~n",[OtherNodeInfo]),
	    loop(S);
	{From, {here_is_my_info, OtherNodeState}} ->
	    exit(S#state.comm_pid, kill),
	    io:format("here is my info msg: ~p~n",[OtherNodeState]),
	   shut_down_remote_node(OtherNodeState#state.node_name),
	    loop(S);
	{shutdown}->
	    exit(?MODULE, kill);
	Unknown ->            
	    io:format("Unknown message: ~p~n",[Unknown]),
	    loop(S)
    end.

honey_maker_bee(File) ->
    honey_maker:generate_md5(File, node()).

communicator_bee_search_other_hives(Dir) ->
    [OtherNode] = communicator_bee:get_list_of_other_nodes(Dir),
    identify_your_self({{?MODULE,OtherNode}, {get_queen_id(), node()}}).

identify_your_self(Message) ->
    {From, Msg} = Message,
    {?MODULE, node()} ! {From, {identify_your_self, Msg}}.

get_hives_node() ->
    node().

return_hive_ref() ->
    erlang:monitor(process, whereis(?MODULE)).

get_queen_id() ->    
    make_ref().

shut_down_remote_node(RemoteNode) ->
    rpc:call(RemoteNode, init, stop, []).

kill_communicator_if_alive(Pid) ->
    case erlang:is_process_alive(Pid) of
	true ->
	    exit(Pid, kill);
	false ->
	    ok
    end.
