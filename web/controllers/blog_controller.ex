defmodule Blog.Web.BlogController do

    alias Blog.Web.Util

    alias Blog.Web.Page

    @article_repo Blog.ContentMetaRepo

    @articles_per_page 2

    @spec renderBlog([Blog.Model.Article.t()], Plug.Conn.t()) :: Plug.Conn.t()
    def renderBlog(articles, conn) when is_list(articles) do
        current_page = conn |> Blog.Web.Pagination.get_current_page
        meta = articles |> Blog.Web.Pagination.paginate(@articles_per_page, current_page)

        case current_page < 1 or current_page > Blog.Web.Pagination.get_total_pages(articles, @articles_per_page) do
            true -> Util.render404 conn
            false ->
                articles
                |> Enum.chunk_every(@articles_per_page)
                |> Enum.at(current_page - 1)
                |> Page.template_home_page(meta)
                |> Util.renderPage(conn)
        end
    end

    @spec renderArticle(nil | Blog.Model.Article.t(), Plug.Conn.t()) :: Plug.Conn.t()
    def renderArticle(nil, conn), do: Util.render404(conn)

    def renderArticle(%Blog.Model.Article{} = article, conn) do
        # Fetch published related articles to render in the "read more" section
        articles = @article_repo.findPublished 3

        article
        |> Blog.Model.Article.fetch_content
        |> Page.template_article_page(articles)
        |> Util.renderPage(conn)
    end
end
