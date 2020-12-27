defmodule Blog.Repo.Base do

    @spec __using__(any) :: any
    defmacro __using__([model_name: model_name]) do

        quote do

            @model_name unquote(model_name)

            defp handle_result({:ok, result}) do
                case Map.fetch!(result, :last_insert_id) do
                    0 -> :ok
                    id -> id
                end
            end

            defp handle_result({:error, _result}) do
                :fail
            end

            defp cast({:ok, %MyXQL.Result{} = result}) do
                %MyXQL.Result{columns: columns, rows: rows} = result
                rows
                |> Enum.map(fn (row)->
                    map_keys_values(columns, row)
                end)
                |> Enum.map(fn (result)-> struct(@model_name, result) end)
                |> cast_one?
            end

            defp cast({:error, _result}) do
                :fail
            end

            defp cast_one?(list) when is_list(list) do
                case length(list) == 1 do
                    true -> Enum.at(list, 0)
                    _ -> list
                end
            end

            defp map_keys_values(columns, values), do: map_keys_values([], 0, columns, values)

            defp map_keys_values(result, index, columns, values) do
                case length(columns) == index do
                    true -> result
                    false ->
                        col = Enum.at(columns, index)
                        value = Enum.at(values, index)
                        result ++ [{String.to_existing_atom(col), value}]
                        |> map_keys_values(index + 1, columns, values)
                end
            end

            defp cast_nil(result) do
                list = cast(result)
                case list do
                    [] -> nil
                    _ -> list
                end
            end
        end
    end
end
