defmodule Blog.Model.Article do
    defstruct [:id, :slug, :title, :description, :content_url, :content, :image_url, :published, :created, :updated]

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
end
