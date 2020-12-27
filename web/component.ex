defmodule Blog.Web.Component do

    require EEx

    EEx.function_from_file :def, :component_navigation, "templates/components/navigation.html.eex"
    EEx.function_from_file :def, :component_main, "templates/components/main.html.eex"
    EEx.function_from_file :def, :component_main_article, "templates/components/main_article.html.eex", [:title, :subtitle, :image]
    EEx.function_from_file :def, :component_head, "templates/components/head.html.eex"
    EEx.function_from_file :def, :component_footer, "templates/components/footer.html.eex"
    EEx.function_from_file :def, :component_articles, "templates/components/articles.html.eex", [:articles]
    EEx.function_from_file :def, :component_divider, "templates/components/divider.html.eex", [:title]
    EEx.function_from_file :def, :component_article_small, "templates/components/article_small.html.eex", [:article]
    EEx.function_from_file :def, :component_lead_box, "templates/components/lead_box.html.eex"

end
