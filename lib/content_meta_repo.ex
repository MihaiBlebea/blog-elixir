defmodule Blog.ContentMetaRepo do
    use Agent

    @spec start_link(any) :: {:error, any} | {:ok, pid}
    def start_link(_args) do
        articles = Blog.ContentMeta.fetch_meta_json
        Agent.start_link(fn -> articles end, name: __MODULE__)
    end

    @spec findBySlug(binary) :: nil | Blog.Model.Article.t()
    def findBySlug(slug) do
        Agent.get(__MODULE__, fn (state)-> state end)
        |> Enum.filter(fn (article)-> article.slug == slug end)
        |> cast_one
    end

    @spec findPublished :: [Blog.Model.Article.t()]
    def findPublished() do
        Agent.get(__MODULE__, fn (state)-> state end)
        |> Enum.filter(fn (article)-> article.published == true end)
    end

    @spec findPublished(number) :: [Blog.Model.Article.t()]
    def findPublished(count), do: findPublished() |> Enum.take(-count)

    @spec findByTag(binary) :: [Blog.Model.Article.t()]
    def findByTag(tag) do
        Agent.get(__MODULE__, fn (state)-> state end)
        |> Enum.filter(fn (article)-> Enum.member?(article.tags, tag) end)
    end

    defp cast_one(articles) do
        case articles do
            [] -> nil
            _ -> Enum.at(articles, 0)
        end
    end
end
