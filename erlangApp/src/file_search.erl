-module(file_search).
-export([return_node_name_and_topdir/1, return_node_name/1]).


return_node_name_and_topdir(Dir) ->
    case recursively_list_dir(Dir) of
	{ok, Files} ->
	    Md5Files = [F || F <- Files, find_md5_files(F) =:= true],
	    [{filename:basename(Node, ".md5"), return_top_dirs(filename:dirname(Node))} ||
		Node <- Md5Files];
	_ ->
	    []
    end.

return_node_name(Dir) ->
    case recursively_list_dir(Dir) of
	{ok, Files} ->
	    Md5Files = [F || F <- Files, find_md5_files(F) =:= true],
	    [filename:basename(Node, ".md5") || Node <- Md5Files];
	_ ->
	    []
    end.

return_top_dirs(Dir1) ->
    SplitDir = filename:split(Dir1),
    TopDir = lists:delete(lists:last(SplitDir), SplitDir),
    filename:join(TopDir).

recursively_list_dir(Dir) ->    
    recursively_list_dir(Dir, false).

recursively_list_dir(Dir, FilesOnly) ->    
    case filelib:is_file(Dir) of
        true ->	    
            case filelib:is_dir(Dir) of
                true ->
		    {ok, recursively_list_dir([Dir], FilesOnly, [])};
		false -> {error, enotdir}
            end;
        false -> {error, enoent}
    end. 

recursively_list_dir([], _, Acc) -> Acc;
recursively_list_dir([Path|Paths], FilesOnly, Acc) ->
    recursively_list_dir(Paths, FilesOnly,
        case filelib:is_dir(Path) of
            false -> [Path | Acc];
            true ->
                {ok, Listing} = file:list_dir(Path),
                SubPaths = [filename:join(Path, Name) || Name <- Listing],
                recursively_list_dir(SubPaths, FilesOnly,
                    case FilesOnly of
                        true -> Acc;
                        false -> [Path | Acc]
                    end)
        end).

find_md5_files(File) ->
    filename:extension(File) == ".md5".
