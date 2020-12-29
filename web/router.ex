defmodule Blog.Web.Router do
    use Plug.Router

    require Logger

    alias Blog.Web.Page
    alias Blog.Web.Util

    @article_repo Blog.ContentMetaRepo

    plug Plug.Logger
    plug Plug.Static,
        at: "/",
        from: "./doc"
    plug Plug.Static,
        at: "/",
        from: "./assets"
    plug :match
    plug Plug.Parsers, parsers: [:urlencoded]
    plug :dispatch

    get "test" do
        send_resp(conn, 200, "All working fine")
    end

    get "/" do
        # Blog.Repo.Article.findPublished
        @article_repo.findPublished
        |> Blog.Web.Util.renderArticles(conn)
    end

    get "/docs" do
        conn
        |> put_resp_header("content-type", "text/html; charset=utf-8")
        |> send_file(200, "./doc/index.html")
    end

    get "/tag/:tag" do
        # Blog.Repo.Article.findPublished
        @article_repo.findPublished
        |> Util.renderArticles(conn)
    end

    get "/article/:slug" do
        IO.inspect @article_repo.findBySlug slug
        slug
        # |> Blog.Repo.Article.findBySlug
        |> @article_repo.findBySlug
        |> Util.renderArticle(conn)
    end

    post "/lead" do
        %{"email" => email} = conn.params
        email |> Blog.EmailList.add_subscriber

        Page.template_lead_page() |> Util.renderPage(conn)
    end

    match _ do
        Page.template_404_page |> Util.renderPage(conn)
    end
end
