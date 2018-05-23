-module(poolboyExample_worker).
-behaviour(poolboy_worker).
-behaviour(gen_server).
%% API.
-export([start_link/1]).

%% gen_server.
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).

-record(state, {
}).

%% API.

-spec start_link(_) -> {ok, pid()}.
start_link(WrkArgs) ->
	gen_server:start_link(?MODULE, WrkArgs, []).

%% gen_server.

init(WrkArgs) ->

	Host = proplists:get_value(hostname, WrkArgs),
	User = proplists:get_value(username, WrkArgs),
	Pass = proplists:get_value(password, WrkArgs),
	DtBase = proplists:get_value(database, WrkArgs),

	ResConn = epgsql:connect(Host, User, Pass, [{database, DtBase}]),
	io:format("result from connect: ~p~n", [ResConn]),

	{ok, #state{}}.

handle_call(_Request, _From, State) ->
	{reply, ignored, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.
