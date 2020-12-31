defmodule Blog.Repo.Article do

    @moduledoc """
        This module implements the Blog.Repo.Base module and extends it with custom functions related to the article model
    """

    use Blog.Repo.Base, model_name: Blog.Model.Article

    @table_name "articles"

    @db_app :blog_db

    @spec create_table :: :ok | :fail
    def create_table() do
        MyXQL.query(
            @db_app,
            "CREATE TABLE IF NOT EXISTS #{ @table_name } (
                id INT NOT NULL AUTO_INCREMENT,
                slug VARCHAR(255) NOT NULL,
                title VARCHAR(255) NOT NULL,
                description VARCHAR(255),
                image_url VARCHAR(255) DEFAULT NULL,
                content_url VARCHAR(255) NOT NULL,
                published INT(1) DEFAULT 0,
                created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                PRIMARY KEY (id)
            )"
        ) |> handle_result
    end

    @spec destory_table :: :ok | :fail
    def destory_table() do
        MyXQL.query(
            @db_app,
            "DROP TABLE #{ @table_name }"
        ) |> handle_result
    end

    @spec find_one(integer) :: any
    def find_one(id) do
        MyXQL.query(
            @db_app,
            "SELECT * FROM #{ @table_name } WHERE id = ?",
            [id]
        ) |> cast_nil
    end

    @spec find_by_slug(binary) :: any
    def find_by_slug(slug) do
        MyXQL.query(
            @db_app,
            "SELECT * FROM #{ @table_name } WHERE slug = ?",
            [slug]
        ) |> cast_nil
    end

    @spec find_published() :: any
    def find_published() do
        MyXQL.query(
            @db_app,
            "SELECT * FROM #{ @table_name } WHERE published = 1"
        ) |> cast
    end
end
