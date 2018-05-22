-module(cheche_pool_worker).
-behaviour(poolboy_worker).
-behaviour(gen_server).

-export([start_link/1,init/1]).
-export([get_conn/0, return_conn/1]).

-export([handle_call/3, handle_cast/2, handle_info/2, terminate/2,
         code_change/3]).

-record(state, {conn}).

start_link(Args) ->
	io:format("worker started with Args: ~p~n~n",[Args]),
	gen_server:start_link(?MODULE, Args, []).
init(_Args) ->
	
    {ok, Conn} = epgsql:connect("localhost","che","S",[{database,"che"}]),
    io:format("~n res of connect to psql: ~p ~n",[Conn]),
    {ok, #state{conn=Conn}}.

-spec get_conn() -> pid().
get_conn() ->
    poolboy:checkout(?MODULE).


-spec return_conn(pid()) -> ok.
return_conn(C) ->
    poolboy:checkin(?MODULE, C).

%%%%%%%   %%%%%%%%    %%%%%%%%%    %%%%%% %%%%%%    %%%%%%%%%%%%  %%%%%%%

handle_call({squery, Sql}, _From, #state{conn=Conn}=State) ->
    {reply, epgsql:squery(Conn, Sql), State};
handle_call({equery, Stmt, Params}, _From, #state{conn=Conn}=State) ->
    {reply, epgsql:equery(Conn, Stmt, Params), State};
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, #state{conn=Conn}) ->
    ok = epgsql:close(Conn),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
