defmodule Blog.ContentMeta do

    @content_meta_url "https://raw.githubusercontent.com/MihaiBlebea/mihaiblebea-content/master/content_meta.json"

    @model_name Blog.Model.Article

    @spec fetch_meta_json :: list | :error
    def fetch_meta_json() do
        case HTTPoison.get(@content_meta_url) do
            {:ok, %{body: body}} -> parse_meta(body)
            {:error, _error} -> :error
        end
    end

    defp parse_meta(body) do
        body
        |> JSON.decode!
        |> handle_date
        |> Enum.map(fn (meta)-> build_article(meta) end)
    end

    defp handle_date(body) do
        body
        |> Enum.map(fn (meta)->
            datetime = Map.get(meta, "created") |> Timex.parse!("{RFC3339z}")
            Map.put(meta, "created", datetime)
        end)
    end

    defp build_article(meta) do
        meta
        |> Enum.map(fn ({ key, value })-> {String.to_existing_atom(key), value} end)
        |> to_struct(@model_name)
    end

    defp to_struct(content, module), do: struct(module, content)
end
