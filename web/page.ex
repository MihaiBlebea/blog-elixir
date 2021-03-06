defmodule Blog.Web.Page do

    @moduledoc """
    Module handles the registration of functions that return page templates.
    """

    require EEx

    EEx.function_from_file :def, :template_home_page, "templates/home.html.eex", [:articles, :meta]
    EEx.function_from_file :def, :template_article_page, "templates/article.html.eex", [:article, :articles]
    EEx.function_from_file :def, :template_lead_page, "templates/lead.html.eex", [:title, :subtitle, :cta, :cta_url]
    EEx.function_from_file :def, :template_404_page, "templates/404.html.eex"

end
