-module(honey_maker_tests).
-include_lib("eunit/include/eunit.hrl").

create_md5_test() ->
    File = "/home/enegfaz/myfile",
    ?assertEqual(ok, honey_maker:generate_md5(File, node())).
