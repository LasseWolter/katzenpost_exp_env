FROM golang:1.12.7-stretch

WORKDIR /mix_net

COPY . /mix_net

CMD ["/mix_net/start.sh", "/mix_net/bin/", "/cliConf/alice.toml", "/mix_net/auth/docker_authority.toml", "/mix_net/provider/docker_provider.toml", "/mix_net/service_provider/docker_service_provider.toml", "/mix_net/mix1/docker_mix1.toml", "/mix_net/mix2/docker_mix2.toml"]
