defmodule Blog.ContentMetaUpdater do

    @secret "iasmb007"

    @fetch_url Application.get_env(:blog, :content_meta_url)

    @repo_name "mihaiblebea-content"

    @ref "refs/heads/master"

    @spec trigger_update(map) :: :error | :ok
    def trigger_update(%{"hook" => %{"config" => %{"secret" => secret}}}) do
        case secret == @secret do
            false -> :error
            true -> :ok
        end
    end

    def trigger_update(%{"repository" => %{"name" => name}, "ref" => ref}) do
        case is_valid_hook?(name, ref) do
            false -> :error
            true -> fetch_content_meta()
        end
    end

    defp fetch_content_meta() do
        case Blog.ContentMeta.fetch_meta_json(@fetch_url) do
            :error -> :error
            articles ->
                IO.inspect articles
                IO.inspect @fetch_url
                Blog.ContentMetaRepo.update_state(articles)
                |> IO.inspect
        end
    end

    defp is_valid_hook?(name, ref), do: ref == @ref && name == @repo_name
end
