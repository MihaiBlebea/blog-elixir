defmodule Blog.EmailSender do
    use Bamboo.Mailer, otp_app: :blog
end

# email = TestBambooSes.welcome_email()
# email = Bamboo.SesAdapter.set_configuration_set(email, "configuration_set_name")
# TestBambooSes.Mailer.deliver_now(email)
