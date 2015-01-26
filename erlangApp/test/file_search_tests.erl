-module(file_search_tests).
-include_lib("eunit/include/eunit.hrl").

top_dir_test() ->
    Dir =  "/home/neg/",
    ?assertEqual("/home", file_search:return_top_dirs(Dir)).

top_dir_test_on_topest_dir() ->
    Dir =  "/home",
    ?assertEqual(" ", file_search:return_top_dirs(Dir)).


return_node_when_dir_doesnt_exist_test() ->
    Dir = "hello",
    ?assertEqual([], file_search:return_node_name_and_topdir(Dir)).

return_node_name_test() ->
    Dir = "/home/neg/erltest",
    ?assertEqual([{"m", "/home/neg"}],
		 file_search:return_node_name_and_topdir(Dir)).

return_dirs_files_test() ->
    Dir = "/home/neg/exampleas/test",
    Files =["/home/neg/exampleas/test/file_search_tests.erl~",
	    "/home/neg/exampleas/test/file_search_tests.erl",
	    "/home/neg/exampleas/test"],
    ?assertEqual({ok, Files}, file_search:recursively_list_dir(Dir)).

recursively_list_dir_doesnt_exist_test() ->
    Dir = "/hom",
    ?assertEqual({error, enoent}, file_search:recursively_list_dir(Dir)).


find_md5_files_search_test() ->
    File = "/home/neg/exampleas/neg.md5",
    ?assertEqual(true, file_search:find_md5_files(File)).

find_md5_files_search_when_file_doesnt_exixt_test() ->
    File = "",
    ?assertEqual(false, file_search:find_md5_files(File)).


