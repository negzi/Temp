-module(communicator_bee_tests).
-include_lib("eunit/include/eunit.hrl").

find_other_nodes_test() ->
    Dir = "/home/neg/erltest",
    Other_Node = communicator_bee:find_other_nodes_with_top_dir(Dir),
    ?assertEqual([{m,"/home/neg"}], Other_Node).

list_of_ther_noeds_test() ->
    Dir = "/home/neg/erltest",
    Nodes = communicator_bee:get_list_of_other_nodes(Dir),
    ?assertEqual([m], Nodes).
    
