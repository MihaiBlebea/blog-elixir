defmodule Blog.EmailList do

    @email_regex ~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i

    @spec add_subscriber(binary) :: {:error, any} | {:ok, Mailchimp.Member.t()}
    def add_subscriber(email) do
        Application.put_env(:mailchimp, :api_key, get_env_api_key())

        if is_valid_email?(email) == false do
            {:error, "Invalid email"}
        end

        list_id = get_env_list_id()

        Mailchimp.Account.get!()
        |> Mailchimp.Account.get_list!(list_id)
        |> Mailchimp.List.create_member(email, "subscribed", %{}, %{})
    end

    @spec is_valid_email?(binary) :: boolean
    defp is_valid_email?(email) when is_binary(email) do
        Regex.match?(@email_regex, email)
    end

    defp get_env_list_id, do: System.fetch_env!("MAILCHIMP_LIST_ID")

    defp get_env_api_key, do: System.fetch_env!("MAILCHIMP_API_KEY")
end
