defmodule Blog.MixProject do
    use Mix.Project

    def project do
        [
            app: :blog,
            version: "0.1.0",
            elixir: "~> 1.10",
            elixirc_paths: elixirc_paths(Mix.env),
            start_permanent: Mix.env() == :prod,
            deps: deps()
        ]
    end

    defp elixirc_paths(:test), do: ["lib", "web", "test"]
    defp elixirc_paths(_), do: ["lib", "web"]

    # Run "mix help compile.app" to learn about applications.
    def application do
        [
            extra_applications: [:logger],
            mod: {Blog, []}
        ]
    end

    # Run "mix help deps" to learn about dependencies.
    defp deps do
        [
            {:plug_cowboy, "~> 2.0"},
            {:cors_plug, "~> 1.2"},
            {:httpoison, "~> 1.6", override: true},
            {:json, "~> 1.2"},
            {:ex_doc, "~> 0.22", only: :dev, runtime: false},
            {:myxql, "~> 0.4.0"},
            {:timex, "~> 3.0"},
            {:earmark, "~> 1.4.0"},
            {:mailchimp, "~> 0.1.0"}
        ]
    end
end
