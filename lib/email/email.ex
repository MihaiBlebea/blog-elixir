defmodule Blog.Email do

    @moduledoc """
    This module contains functions to build the different email types before sending.
    """

    import Bamboo.Email

    @spec contact_email(binary, binary, binary, binary) :: Bamboo.Email.t()
    def contact_email(name, phone, email, message) do
        html_body = Blog.Web.Email.template_contact_email(name, phone, email, message)
        new_email(
            to: "mihaiserban.blebea@gmail.com",
            from: "support@mihaiblebea.com",
            subject: "New contact form submission",
            html_body: default_template(html_body),
            text_body: "Thanks for joining!"
        )
    end

    defp default_template(body), do: Blog.Web.Email.template_default_email body
end
