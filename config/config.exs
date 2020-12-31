use Mix.Config

config :blog,
    port: 8099,
    mysql_user: "admin",
    mysql_password: "pass",
    mysql_host: "localhost",
    mysql_port: 3306,
    mysql_database: "blog",
    github_url: "https://github.com/MihaiBlebea",
    youtube_url: "https://www.youtube.com/channel/UCR_g0G3YYE_zQVqZL0y7-dg",
    facebook_url: "https://www.facebook.com/blebea.serban",
    twitter_url: "https://twitter.com/MBlebea",
    linkedin_url: "https://www.linkedin.com/in/mihai-blebea-87353310b",
    content_meta_url: "https://api.github.com/repos/MihaiBlebea/mihaiblebea-content/contents/content_meta.json"


config :mailchimp,
    api_key: "",
    list_id: "3e1b069dee"

import_config "config.#{ Mix.env() }.exs"
