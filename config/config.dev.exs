use Mix.Config

config :blog,
    port: 8099

config :blog, Blog.EmailSender,
    adapter: Bamboo.SMTPAdapter,
    server: "smtp.mailtrap.io",
    port: 465,
    username: {:system, "SMTP_USERNAME"},
    password: {:system, "SMTP_PASSWORD"}
