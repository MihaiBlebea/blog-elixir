defmodule Blog.ContentMetaUpdater do

    @moduledoc """
    This module handles the updating of the meta content from github.
    When an event triggers the update action, this will make sure that the data is fetched from github and updated in the agent.
    """

    @secret "iasmb007"

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
        case get_fetch_url() |> Blog.ContentMeta.fetch_meta_json do
            :error -> :error
            articles -> Blog.ContentMetaRepo.update_state(articles)
        end
    end

    defp is_valid_hook?(name, ref), do: ref == @ref && name == @repo_name

    defp get_fetch_url, do: Application.get_env(:blog, :content_meta_url)
end
