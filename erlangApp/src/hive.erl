-module(hive).
-export([start_hive/1]).

-export([init/1, loop/1, honey_maker_bee/1,
	 communicator_bee_search_other_hives/1, identify_your_self/1]).

-record(state, {queen_id,
		node_name,
		comm_pid}).

-define(TOPDIR, "/home/enegfaz/distributedApp/Temp/erlangApp").

start_hive(File) ->
    register(?MODULE, Pid=spawn(?MODULE, init, [File])),
    {ok, Pid}.

init(File) ->
    spawn(?MODULE, honey_maker_bee, [File]),
    Pid = spawn(?MODULE, communicator_bee_search_other_hives, [?TOPDIR]),
    loop(#state{queen_id= get_queen_id(),
		node_name = node(),
		comm_pid = Pid}).

loop(S = #state{}) ->
    receive
        {From, {identify_your_self, _}} ->
	    kill_communicator_if_alive(S#state.comm_pid),
	    From ! {{?MODULE, node()},{here_is_my_info, S}},
	    loop(S);
	{_, {here_is_my_info, OtherNodeState}} ->
	    exit(S#state.comm_pid, kill),
	    remove_md5(S#state.node_name),
	    Slave = create_slave(),
	    shut_down_remote_node(OtherNodeState#state.node_name),
	    start_app_on(Slave),
	    loop(S);
	upgrade ->         
	    code:purge(?MODULE),
            compile:file(?MODULE),
            code:load_file(?MODULE),
            ?MODULE:loop(S);
	Unknown ->
	    io:format("Unknown message: ~p~n",[Unknown]),
	    loop(S)
    end.

remove_md5(Node) ->
    os:cmd("rm ./"++ atom_to_list(Node)++".md5").
 
start_app_on(Slave) ->
    big_hive:start_app_on_slave_hive(Slave).
    
create_slave() ->
    big_hive:create_slave_hive(rand_name()).
    
rand_name() ->
    big_hive:gen_ran_name().

honey_maker_bee(File) ->
    honey_maker:generate_md5(File, node()).

communicator_bee_search_other_hives(Dir) ->
    [OtherNodes]= communicator_bee:get_list_of_other_nodes(Dir),
    identify_your_self({{?MODULE,OtherNodes}, {get_queen_id(), node()}}).

identify_your_self(Message) ->
    {From, Msg} = Message,
    {?MODULE, node()} ! {From, {identify_your_self, Msg}}.

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
