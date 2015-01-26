-module(honey_maker).
-export([generate_md5/2]).

-define(BLOCKSIZE, 8).

generate_md5(File, Node) ->
    case file:open(File, [binary,raw,read]) of
	{ok, IoDevice} ->
	    case read_bytes(IoDevice, erlang:md5_init()) of
		{ok, Result} ->
		    file:write_file(node_name_to_str(Node)++".md5",
				    Result)
	    end;
	Error -> {error, file_open_failed}
    end.

node_name_to_str(Node) ->
    erlang:atom_to_list(Node).

read_bytes(Device, Context) ->
    case file:read(Device, ?BLOCKSIZE) of
	{ok, Bin} ->
	    timer:sleep(1000),
	    read_bytes(Device, erlang:md5_update(Context, Bin));
	eof ->
	    file:close(Device),
	    {ok, erlang:md5_final(Context)}
    end.

	    
		
