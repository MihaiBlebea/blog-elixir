defmodule ContentMetaRepoTest do

    use ExUnit.Case, async: true

    setup do
        bypass = Bypass.open
        {:ok, bypass: bypass}
    end

    defp endpoint_url(port, url), do: "http://localhost:#{ port }/#{ url }"

    defp mocked_post() do
        %{
            title: "This is a published post",
            slug: "published-post",
            image_url: "https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png",
            description: "Recommend Products Your Customers Will Love with Our E-Commerce Integrations. Mailchimp Works with Your Favorite Apps & Web Services to Help Improve Your Marketing. Advanced Testing Tools. Real-Time Data Reports. Remarketing Ads. No Coding Required.",
            content_url: "https://raw.githubusercontent.com/MihaiBlebea/mihaiblebea-content/master/github_beginners.md",
            published: true,
            tags: ["golang", "devops", "test"],
            created: "2020-12-26T18:09:52Z"
        }
    end

    test "can get all published articles", %{bypass: bypass} do
        resp = mocked_post()

        Bypass.expect_once(bypass, "GET", "/content_meta.json", fn (conn)->
            Plug.Conn.resp(conn, 200, JSON.encode!([ resp, resp, resp ]))
        end)

        # url = bypass.port |> endpoint_url("content_meta.json")
        # Blog.ContentMetaRepo.start_link([%{ content_meta_url: url }]) |> IO.inspect

        # data = Blog.ContentMetaRepo.findPublished

        # assert length(data) == 3
    end


end
