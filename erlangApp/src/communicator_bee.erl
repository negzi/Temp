-module(communicator_bee).
-compile(export_all).

find_other_nodes_with_top_dir(TopDir) ->
    Nodes =  file_search:return_node_name_and_topdir(TopDir),
    NodeList = [{list_to_atom(Node), Dir} || {Node, Dir} <- Nodes],
    lists:keydelete(node(), 1, NodeList).


get_list_of_other_nodes(TopDir) ->
    Nodes = file_search:return_node_name(TopDir),
    NodeList = [list_to_atom(N) || N <- Nodes],
    Res = lists:filter(fun(Node) -> 
			       (Node =/= node())  and (Node =/= nonode@nohost)
		       end,
		       NodeList),
    case Res of
	[] ->
	    get_list_of_other_nodes(TopDir);
	Res ->
	    Res
    end.

