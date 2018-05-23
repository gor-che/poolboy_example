-module(poolboyExample_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	{ok, R} = application:get_env(poolboyExample, pools),
	{Name, SizeArgs, WrkArgs} = proplists:lookup(pool1, R),

	PoolArgs = [{name, {local, Name}}, {worker_module, poolboyExample_worker}
		   ] ++ SizeArgs,

	PbRes = poolboy:child_spec(Name, PoolArgs, WrkArgs),

	{ok, {{one_for_one, 1, 5}, [PbRes]}}.
