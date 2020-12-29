defmodule Blog.ContentMeta do

    @model_name Blog.Model.Article

    @spec fetch_meta_json(binary) :: list | :error
    def fetch_meta_json(url) when is_binary(url) do
        %{body: body, status_code: code} = HTTPoison.get!(url)
        case code do
            200 -> parse_meta(body)
            _ -> :error
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
