defmodule Blog.Web.Util do

    @moduledoc "This module provides useful functions to the web component"

    alias Blog.Web.Page

    @spec render_404(Plug.Conn.t()) :: Plug.Conn.t()
    def render_404(conn), do: Page.template_404_page() |> render_page(conn)

    @spec to_html(nil | binary) :: nil | binary
    def to_html(nil), do: nil

    def to_html(content) do
        case Earmark.as_html(content, code_class_prefix: "code_") do
            {:ok, html_doc, []} -> html_doc
            {:error, _html_doc, _error_messages} -> nil
        end
    end

    @spec to_format_date(%{day: any, month: any, year: any}) :: binary
    def to_format_date(date) do
        Enum.join [date.year, date.month, date.day], "/"
    end

    @spec render_page(binary, Plug.Conn.t()) :: Plug.Conn.t()
    def render_page(page_contents, conn) do
        conn
        |> Plug.Conn.put_resp_content_type("text/html")
        |> Plug.Conn.send_resp(200, page_contents)
    end
end
