defmodule Blog.EmailSender do

    @moduledoc """
    This module handles the sending of emails using the adaptor.
    """

    use Bamboo.Mailer, otp_app: :blog
end

# email = TestBambooSes.welcome_email()
# email = Bamboo.SesAdapter.set_configuration_set(email, "configuration_set_name")
# TestBambooSes.Mailer.deliver_now(email)
