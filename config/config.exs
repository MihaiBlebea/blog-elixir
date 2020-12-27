use Mix.Config

config :blog,
    port: 8099,
    mysql_user: "admin",
    mysql_password: "pass",
    mysql_host: "localhost",
    mysql_port: 3306,
    mysql_database: "blog"

config :mailchimp,
    api_key: "0ab32a1b44df3631201f5498d162bfe8-us7",
    list_id: "3e1b069dee"

import_config "config.#{ Mix.env() }.exs"
