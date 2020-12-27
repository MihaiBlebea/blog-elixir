defmodule Blog.EmailList do

    @spec add_subscriber(binary) :: {:error, any} | {:ok, Mailchimp.Member.t()}
    def add_subscriber(email) do
        list_id = Application.get_env(:mailchimp, :list_id)

        Mailchimp.Account.get!()
        |> Mailchimp.Account.get_list!(list_id)
        |> Mailchimp.List.create_member(email, "subscribed", %{}, %{})
    end
end
