defmodule Blog.ContentMetaRepo do

    @moduledoc """
    This module acts as a repository for the article meta data, like slugs, title, descriptions, image urls and more.
    Use the public functions to fetch the article models from the github repo.
    """

    use Agent

    @spec start_link(any) :: {:error, any} | {:ok, pid}
    def start_link([%{content_meta_url: url}]) do
        articles = Blog.ContentMeta.fetch_meta_json(url)
        Agent.start_link(fn -> articles end, name: __MODULE__)
    end

    @spec find_by_slug(binary) :: nil | Blog.Model.Article.t()
    def find_by_slug(slug) do
        Agent.get(__MODULE__, fn (state) -> state end)
        |> Enum.filter(fn (article) -> article.slug == slug end)
        |> cast_one
    end

    @spec find_published :: [Blog.Model.Article.t()]
    def find_published() do
        Agent.get(__MODULE__, fn (state) -> state end)
        |> Enum.filter(fn (article) -> article.published == true end)
    end

    @spec find_published(number) :: [Blog.Model.Article.t()]
    def find_published(count), do: find_published() |> Enum.take(-count)

    @spec find_by_tag(binary) :: [Blog.Model.Article.t()]
    def find_by_tag(tag) do
        Agent.get(__MODULE__, fn (state) -> state end)
        |> Enum.filter(fn (article) -> Enum.member?(article.tags, tag) end)
    end

    @spec update_state([Blog.Model.Article.t()]) :: :ok
    def update_state(articles) do
        Agent.update(__MODULE__, fn (_state) -> articles end)
    end

    defp cast_one(articles) do
        case articles do
            [] -> nil
            _ -> Enum.at(articles, 0)
        end
    end
end
