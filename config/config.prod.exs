use Mix.Config

config :blog,
    port: 8080

config :blog, Blog.EmailSender,
    adapter: Bamboo.SesAdapter,
    ex_aws: [
        region: "eu-west-2",
        access_key_id: "AWS_ACCESS_KEY_ID",
        secret_access_key: "AWS_SECRET_ACCESS_KEY"
    ]
