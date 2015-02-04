-module(communicator_bee).
-export([get_list_of_other_nodes/1]).

get_list_of_other_nodes(TopDir) ->
    Node = file_search:return_node_name(TopDir),
    Nodes = [list_to_atom(N) || N <- Node],
    Res = lists:filter(fun(Node) -> 
			       (Node =/= node())  and (Node =/= nonode@nohost)
		       end,
		       Nodes),
    case Res of
	[] ->
	    get_list_of_other_nodes(TopDir);
	Res ->
	    Res
    end.

