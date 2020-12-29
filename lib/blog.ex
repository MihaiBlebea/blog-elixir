defmodule Blog do
    use Application

    require Logger

    @spec start(any, any) :: {:error, any} | {:ok, pid}
    def start(_type, _args) do
        port = Application.get_env(:blog, :port)

        IO.puts "Application starting on port #{ to_string(port) }..."

        children = [
            {Plug.Cowboy, scheme: :http, plug: Blog.Web.Router, options: [port: port]},
            # {
            #     MyXQL,
            #     username: Application.get_env(:blog, :mysql_user),
            #     password: Application.get_env(:blog, :mysql_password),
            #     hostname: Application.get_env(:blog, :mysql_host),
            #     port: Application.get_env(:blog, :mysql_port),
            #     database: Application.get_env(:blog, :mysql_database),
            #     name: :blog_db
            # },
            {
                Blog.ContentMetaRepo, [
                    %{content_meta_url: Application.get_env(:blog, :content_meta_url)}
                ]
            }
        ]

        supervisor = Supervisor.start_link(children, strategy: :one_for_one)

        # migrate_database()

        supervisor
    end

    defp migrate_database() do
        Blog.Repo.Article.create_table()
    end
end
