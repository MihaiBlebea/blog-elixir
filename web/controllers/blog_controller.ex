defmodule Blog.Web.BlogController do

    alias Blog.Web.Util

    alias Blog.Web.Page

    @article_repo Blog.ContentMetaRepo

    @articles_per_page Application.get_env(:blog, :articles_per_page)

    @spec render_blog([Blog.Model.Article.t()], Plug.Conn.t()) :: Plug.Conn.t()
    def render_blog(articles, conn) when is_list(articles) do
        current_page = conn |> Blog.Web.Pagination.get_current_page
        meta = articles |> Blog.Web.Pagination.paginate(@articles_per_page, current_page)

        case current_page < 1 or current_page > Blog.Web.Pagination.get_total_pages(articles, @articles_per_page) do
            true -> Util.render_404 conn
            false ->
                articles
                |> Enum.chunk_every(@articles_per_page)
                |> Enum.at(current_page - 1)
                |> Page.template_home_page(meta)
                |> Util.render_page(conn)
        end
    end

    @spec render_article(nil | Blog.Model.Article.t(), Plug.Conn.t()) :: Plug.Conn.t()
    def render_article(nil, conn), do: Util.render_404(conn)

    def render_article(%Blog.Model.Article{} = article, conn) do
        # Fetch published related articles to render in the "read more" section
        articles = @article_repo.find_published 3

        article
        |> Blog.Model.Article.fetch_content
        |> Page.template_article_page(articles)
        |> Util.render_page(conn)
    end
end
