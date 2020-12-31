defmodule ContentMetaTest do

    use ExUnit.Case, async: true

    setup do
        bypass = Bypass.open
        {:ok, bypass: bypass}
    end

    defp endpoint_url(port, url), do: "http://localhost:#{ port }/#{ url }"

    defp get_meta_mock() do
        %{
            title: "This is a title demo for this blog post",
            slug: "article-demo-test",
            image_url: "https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png",
            description: "Recommend Products Your Customers Will Love with Our E-Commerce Integrations. Mailchimp Works with Your Favorite Apps & Web Services to Help Improve Your Marketing. Advanced Testing Tools. Real-Time Data Reports. Remarketing Ads. No Coding Required.",
            content_url: "https://raw.githubusercontent.com/MihaiBlebea/mihaiblebea-content/master/github_beginners.md",
            published: true,
            tags: ["golang", "devops", "test"],
            created: "2020-12-26T18:09:52Z"
        }
    end

    defp request_data(bypass) do
        bypass.port |> endpoint_url("content_meta.json") |> Blog.ContentMeta.fetch_meta_json
    end

    test "can fetch content meta data from github", %{bypass: bypass} do
        resp = get_meta_mock()

        Bypass.expect_once(bypass, "GET", "/content_meta.json", fn (conn) ->
            Plug.Conn.resp(conn, 200, JSON.encode!([resp]))
        end)

        data = request_data(bypass)

        assert List.first(data).title == resp.title
    end

    test "returns :error atom when server returns internal error", %{bypass: bypass} do
        resp = get_meta_mock()

        Bypass.expect_once(bypass, "GET", "/content_meta.json", fn (conn) ->
            Plug.Conn.resp(conn, 500, "")
        end)

        atom = request_data(bypass)

        assert atom == :error
    end

    test "any key is nil if key is missing from json data", %{bypass: bypass} do
        resp = get_meta_mock() |> Map.delete(:image_url)

        Bypass.expect_once(bypass, "GET", "/content_meta.json", fn (conn) ->
            Plug.Conn.resp(conn, 200, JSON.encode!([resp]))
        end)

        data = request_data(bypass)

        assert List.first(data).image_url == nil
    end

    test "created key is nil if key is missing from json data", %{bypass: bypass} do
        resp = get_meta_mock() |> Map.delete(:created)

        Bypass.expect_once(bypass, "GET", "/content_meta.json", fn (conn) ->
            Plug.Conn.resp(conn, 200, JSON.encode!([resp]))
        end)

        data = request_data(bypass)

        assert List.first(data).created == nil
    end
end
