from erlang:latest

WORKDIR /
RUN git clone https://github.com/erlang/rebar3.git rebar_bad
RUN git clone https://github.com/erlang/rebar3.git rebar_good
WORKDIR /rebar_bad
RUN git checkout 3.6.2;
COPY rebar_bad.config rebar.config
RUN rebar3 unlock
RUN ./bootstrap
WORKDIR /rebar_good
RUN git checkout 3.6.2
COPY rebar_good.config rebar.config
RUN rebar3 unlock
RUN ./bootstrap
COPY . /relx_test
WORKDIR /relx_test
RUN ../rebar_good/rebar3 release -n relx_good
RUN ../rebar_bad/rebar3 release -n relx_bad
WORKDIR /relx_test/_build/default/rel/relx_bad
RUN bin/relx_bad start_boot start_clean; sleep 1
WORKDIR /relx_test/_build/default/rel/relx_good
RUN bin/relx_good start_boot start_clean; sleep 1
WORKDIR /relx_test
RUN cp /relx_test/_build/default/rel/relx_bad/log/erlang.log.1 erlang_bad.log
RUN cp /relx_test/_build/default/rel/relx_good/log/erlang.log.1 erlang_good.log

