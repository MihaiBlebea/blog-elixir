defmodule Blog.Model.Article do

    @moduledoc """
        Article module represents a model that holds the data for the article entity.
        Has methods to build the sharing urls for each specific social platform.
    """

    defstruct [:slug, :title, :description, :content_url, :content, :image_url, :video_url, :published, :tags, :created]

    @type t() :: %__MODULE__{}

    @spec fetch_content(nil | Blog.Model.Article.t()) :: nil | Blog.Model.Article.t()
    def fetch_content(%__MODULE__{} = article) do
        {:ok, %{body: body, status_code: code}} = article.content_url |> HTTPoison.get
        case code do
            200 -> Map.put(article, :content, body)
            _ -> article
        end
    end

    def fetch_content(nil), do: nil

    @spec get_twitter_share_url(nil | Blog.Model.Article.t()) :: binary
    def get_twitter_share_url(nil) do
        "http://twitter.com/share?url=https://mihaiblebea.com&hashtags=mihaiblebea"
    end

    def get_twitter_share_url(%__MODULE__{} = article) do
        "http://twitter.com/share?text=#{ article.description }&url=https://mihaiblebea.com/article/#{ article.slug }&hashtags=mihaiblebea"
    end

    @spec get_linkedin_share_url(nil | Blog.Model.Article.t()) :: binary
    def get_linkedin_share_url(nil) do
        "https://www.linkedin.com/shareArticle?mini=true&url=https://mihaiblebea.com"
    end

    def get_linkedin_share_url(%__MODULE__{} = article) do
        "https://www.linkedin.com/shareArticle?mini=true&url=https://mihaiblebea.com/article/#{ article.slug }&title=#{ article.title }&summary=#{ article.description }&source="
    end

    @spec get_facebook_share_url(nil | Blog.Model.Article.t()) :: binary
    def get_facebook_share_url(nil) do
        "https://www.facebook.com/sharer/sharer.php?u=https://mihaiblebea.com"
    end

    def get_facebook_share_url(%__MODULE__{} = article) do
        "https://www.facebook.com/sharer/sharer.php?u=https://mihaiblebea.com/article/#{ article.slug }"
    end
end
