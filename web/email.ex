defmodule Blog.Web.Email do

    @moduledoc """
    Module registers the functions that render the emails in html.
    """

    require EEx

    EEx.function_from_file :def, :template_default_email, "templates/emails/default.html.eex", [:body]
    EEx.function_from_file :def, :template_contact_email, "templates/emails/contact.html.eex", [:name, :phone, :email, :message]

end
