defmodule Blog.Web.Email do

    require EEx

    EEx.function_from_file :def, :template_contact_email, "templates/emails/contact.html.eex"

end
