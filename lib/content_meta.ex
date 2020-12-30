defmodule Blog.ContentMeta do

    @model_name Blog.Model.Article

    @spec fetch_meta_json(binary) :: [Blog.Model.Article.t()] | :error
    def fetch_meta_json(url) when is_binary(url) do
        %{body: body} = HTTPoison.get!(url, get_default_headers())
        %{ "content" => content } = body |> JSON.decode!

        content |> Base.decode64!(ignore: :whitespace) |> parse_meta
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
            meta |> has_created_key(Map.has_key?(meta, "created"))
        end)
    end

    defp has_created_key(meta, false), do: meta

    defp has_created_key(meta, true) do
        datetime = Map.get(meta, "created") |> Timex.parse!("{RFC3339z}")
        Map.put(meta, "created", datetime)
    end

    defp build_article(meta) do
        meta
        |> Enum.map(fn ({ key, value })-> {String.to_existing_atom(key), value} end)
        |> to_struct(@model_name)
    end

    defp to_struct(content, module), do: struct(module, content)

    defp get_default_headers() do
        ["Authorization": "token #{ fetch_env_github_token() }", "Content-Type": "application/json"]
    end

    defp fetch_env_github_token, do: System.fetch_env!("GITHUB_TOKEN")
end
