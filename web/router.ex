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
    plug Plug.Parsers, parsers: [:urlencoded, :json],
        json_decoder: JSON
    plug :dispatch

    get "/" do
        @article_repo.findPublished
        |> Blog.Web.BlogController.renderBlog(conn)
    end

    get "/docs" do
        conn
        |> put_resp_header("content-type", "text/html; charset=utf-8")
        |> send_file(200, "./doc/index.html")
    end

    post "/webhook/github" do
        case Blog.ContentMetaUpdater.trigger_update(conn.params) do
            :ok -> send_resp(conn, 200, "")
            :error -> send_resp(conn, 500, "")
        end
    end

    get "/tag/:tag" do
        @article_repo.findByTag(tag) |> Blog.Web.BlogController.renderBlog(conn)
    end

    get "/article/:slug" do
        slug
        |> @article_repo.findBySlug
        |> Blog.Web.BlogController.renderArticle(conn)
    end

    post "/lead" do
        %{"email" => email} = conn.params
        email |> Blog.EmailList.add_subscriber
        title = "All done!"
        subtitle = "Thank you for registering to the email list"
        cta = "Back to website"
        cta_url = "/"

        Page.template_lead_page(title, subtitle, cta, cta_url) |> Util.renderPage(conn)
    end

    post "/contact" do
        %{
            "email" => email,
            "message" => message,
            "name" => name,
            "phone" => phone
        } = conn.params

        Blog.Email.contact_email(name, phone, email, message)
        |> Blog.EmailSender.deliver_now()

        title = "Message sent!"
        subtitle = "Thank you for the message, I'll get back to you shortly"
        cta = "Back to website"
        cta_url = "/"

        Page.template_lead_page(title, subtitle, cta, cta_url) |> Util.renderPage(conn)
    end

    match _ do
        Page.template_404_page |> Util.renderPage(conn)
    end
end
