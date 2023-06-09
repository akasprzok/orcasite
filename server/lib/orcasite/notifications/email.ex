defmodule Orcasite.Notifications.Email do
  import Swoosh.Email
  import Phoenix.Component, only: [sigil_H: 2]

  def new_detection_email(%{to: email, name: name, node: node}) do
    node_name = String.split(node, "-") |> Enum.map(&String.capitalize/1) |> Enum.join(" ")

    new()
    |> to({name, email})
    |> from({"Orcasound", "info@orcasound.net"})
    |> subject("New detection on #{node_name}")
    |> html_body(new_detection_body(node, node_name))
  end


  def new_detection_body(node, node_name) do
    assigns = %{
      node_name: node_name,
      node: node
    }

    ~H"""
    <div>
      <p>
        A new detection has been submitted at <%= @node_name %> (<%= @node %>)!
      </p>

      <p>
        Listen here: <a href={"https://live.orcasound.net/#{@node}"}>https://live.orcasound.net/<%= @node %></a>
      </p>
    </div>
    """
    |> Phoenix.HTML.Safe.to_iodata()
    |> List.to_string()
  end


  def confirmed_candidate_email(%{to: email, name: name, node: node}) do
    node_name = String.split(node, "-") |> Enum.map(&String.capitalize/1) |> Enum.join(" ")

    new()
    |> to({name, email})
    |> from({"Orcasound", "info@orcasound.net"})
    |> subject("Listen to orcas near #{node_name}!")
    |> html_body(new_detection_body(node, node_name))
  end


  def confirmed_candidate_body(node, node_name) do
    assigns = %{
      node_name: node_name,
      node: node
    }

    ~H"""
    <div>
      <p>
        Don't miss the concert!
      </p>

      <p>
        Listen to orcas here: <a href={"https://live.orcasound.net/#{@node}"}>https://live.orcasound.net/<%= @node %></a>
      </p>
    </div>
    """
    |> Phoenix.HTML.Safe.to_iodata()
    |> List.to_string()
  end

end