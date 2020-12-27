defmodule Blog.Web.Util do

    alias Blog.Web.Page

    @spec renderArticles(list, Plug.Conn.t()) :: Plug.Conn.t()
    def renderArticles(articles, conn) when is_list(articles) do
        articles
        |> Enum.map(fn (article)-> Blog.Model.Article.fetch_content(article) end)
        |> Page.template_home_page
        |> renderPage(conn)
    end

    @spec renderArticle(nil | Blog.Model.Article.t(), Plug.Conn.t()) :: Plug.Conn.t()
    def renderArticle(nil, conn), do: render404(conn)

    def renderArticle(%Blog.Model.Article{} = article, conn) do
        # Fetch published related articles to render in the "read more" section
        articles = Blog.Repo.Article.findPublished

        article
        |> Blog.Model.Article.fetch_content
        |> Page.template_article_page(articles)
        |> renderPage(conn)
    end

    @spec render404(Plug.Conn.t()) :: Plug.Conn.t()
    def render404(conn), do: Page.template_404_page() |> renderPage(conn)

    @spec to_html(nil | binary) :: nil | binary
    def to_html(nil), do: nil

    def to_html(content) do
        case Earmark.as_html(content, code_class_prefix: "code_") do
            {:ok, html_doc, []} -> html_doc
            {:error, _html_doc, _error_messages} -> nil
        end
    end

    @spec to_format_date(%{day: any, month: any, year: any}) :: binary
    def to_format_date(date) do
        Enum.join [date.year, date.month, date.day], "/"
    end

    @spec renderPage(binary, Plug.Conn.t()) :: Plug.Conn.t()
    def renderPage(page_contents, conn) do
        conn
        |> Plug.Conn.put_resp_content_type("text/html")
        |> Plug.Conn.send_resp(200, page_contents)
    end
end
