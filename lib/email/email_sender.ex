defmodule Blog.EmailSender do

    @moduledoc """
    This module handles the sending of emails using the adaptor.
    """

    use Bamboo.Mailer, otp_app: :blog
end

# email = Blog.Email.contact_email("Serban", "0741121323", "serban@gmail.com", "hey man how are you")
# email = Bamboo.SesAdapter.set_configuration_set(email, "configuration_set_name")
# Blog.EmailSender.deliver_now(email)
