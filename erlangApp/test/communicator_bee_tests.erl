-module(communicator_bee_tests).
-include_lib("eunit/include/eunit.hrl").

list_of_ther_noeds_test() ->
    Dir = "/home/enegfaz/erltest",
    Nodes = communicator_bee:get_list_of_other_nodes(Dir),
    ?assertEqual([m], Nodes).
    
