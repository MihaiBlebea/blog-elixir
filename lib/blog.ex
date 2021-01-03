defmodule Blog do

    @moduledoc """
    This module handles the application supervisor and registering dependencies to it.
    """

    use Application

    require Logger

    @spec start(any, any) :: {:error, any} | {:ok, pid}
    def start(_type, _args) do
        port = Application.get_env(:blog, :port)

        IO.puts "Application starting on port #{ to_string(port) }..."

        children = [
            {Plug.Cowboy, scheme: :http, plug: Blog.Web.Router, options: [port: port]},
            {
                Blog.ContentMetaRepo, [
                    %{content_meta_url: Application.get_env(:blog, :content_meta_url)}
                ]
            }
        ]

        Supervisor.start_link(children, strategy: :one_for_one)
    end
end
