defmodule Blog.Web.Page do

    require EEx

    EEx.function_from_file :def, :template_home_page, "templates/home.html.eex", [:articles, :meta]
    EEx.function_from_file :def, :template_article_page, "templates/article.html.eex", [:article, :articles]
    EEx.function_from_file :def, :template_lead_page, "templates/lead.html.eex"
    EEx.function_from_file :def, :template_404_page, "templates/404.html.eex"

end
