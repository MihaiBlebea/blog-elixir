defmodule ContentMetaTest do

    use ExUnit.Case, async: true

    setup do
        bypass = Bypass.open
        {:ok, bypass: bypass}
    end

    defp endpoint_url(port, url), do: "http://localhost:#{ port }/#{ url }"

    test "can fetch content meta data from github", %{bypass: bypass} do
        resp = %{
            title: "This is a title demo for this blog post",
            slug: "article-demo-test",
            image_url: "https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png",
            description: "Recommend Products Your Customers Will Love with Our E-Commerce Integrations. Mailchimp Works with Your Favorite Apps & Web Services to Help Improve Your Marketing. Advanced Testing Tools. Real-Time Data Reports. Remarketing Ads. No Coding Required.",
            content_url: "https://raw.githubusercontent.com/MihaiBlebea/mihaiblebea-content/master/github_beginners.md",
            published: true,
            tags: ["golang", "devops", "test"],
            created: "2020-12-26T18:09:52Z"
        }

        Bypass.expect_once(bypass, "GET", "/content_meta.json", fn (conn)->
            Plug.Conn.resp(conn, 200, JSON.encode!([ resp ]))
        end)

        data = bypass.port |> endpoint_url("content_meta.json") |> Blog.ContentMeta.fetch_meta_json

        assert List.first(data).title == resp.title
    end

    test "returns atom when server is down", %{bypass: bypass} do
        resp = %{
            title: "This is a title demo for this blog post",
            slug: "article-demo-test",
            image_url: "https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png",
            description: "Recommend Products Your Customers Will Love with Our E-Commerce Integrations. Mailchimp Works with Your Favorite Apps & Web Services to Help Improve Your Marketing. Advanced Testing Tools. Real-Time Data Reports. Remarketing Ads. No Coding Required.",
            content_url: "https://raw.githubusercontent.com/MihaiBlebea/mihaiblebea-content/master/github_beginners.md",
            published: true,
            tags: ["golang", "devops", "test"],
            created: "2020-12-26T18:09:52Z"
        }

        Bypass.expect_once(bypass, "GET", "/content_meta.json", fn (conn)->
            Plug.Conn.resp(conn, 500, "")
        end)

        atom = bypass.port |> endpoint_url("content_meta.json") |> Blog.ContentMeta.fetch_meta_json

        assert atom == :error
    end
end
