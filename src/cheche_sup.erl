-module(cheche_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([])->

	{ok,Pool} = application:get_env(cheche, pools),
	P = proplists:lookup(pool1,Pool),
	{pool1, SizeArgs, _WorkerArgs} = P,

	PoolArgs =[{name,{local, pool1}},{worker_module, cheche_pool_worker}
		  ] ++ SizeArgs,

	Res = poolboy:child_spec(pool1, PoolArgs, []),
	io:format("pool result: ~p~n",[Res]),
	io:format("~nPoolArgs: ~p~n",[PoolArgs]),

	{ok, {{one_for_one, 1, 5}, [Res]}}.
