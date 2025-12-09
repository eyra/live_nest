defmodule LiveNest.ModalTest do
  @moduledoc """
    Integration test for presenting/hiding modal views based on event bubbling.
  """

  use LiveNest.Support.ConnCase, async: false

  import Phoenix.LiveViewTest

  test "shows modal with live component", %{conn: conn} do
    {:ok, page, _html} = live(conn, "/dashboard")

    header = find_live_child(page, "header")
    header |> render_click("show_profile")
    assert page |> render() =~ "Edit Profile"
  end

  test "closes modal with live component", %{conn: conn} do
    {:ok, page, _html} = live(conn, "/dashboard")

    header = find_live_child(page, "header")
    header |> render_click("show_profile")
    assert page |> render() =~ "Edit Profile"
    assert header |> render() =~ "Profile form modal closed 0 times"
    page |> element("#profile-form button", "Close") |> render_click()
    assert header |> render() =~ "Profile form modal closed 1 times"
    refute page |> render() =~ "Edit Profile"
  end

  test "shows modal with live view", %{conn: conn} do
    {:ok, page, _html} = live(conn, "/dashboard")

    dashboard = find_live_child(page, "dashboard")
    chart_widget = find_live_child(dashboard, "chart-widget")
    chart_widget |> render_click("maximize")
    # wait for the modal to be displayed
    Process.sleep(1)
    assert page |> render() =~ "Fullscreen chart view"
  end

  test "closes modal with live view", %{conn: conn} do
    {:ok, page, _html} = live(conn, "/dashboard")

    dashboard = find_live_child(page, "dashboard")
    chart_widget = find_live_child(dashboard, "chart-widget")
    chart_widget |> render_click("maximize")
    # wait for the modal to be displayed
    Process.sleep(1)
    assert page |> render() =~ "Fullscreen chart view"
    chart_fullscreen = find_live_child(page, "chart-fullscreen")
    chart_fullscreen |> render_click("close_modal")
    # wait for the modal to be closed
    Process.sleep(1)
    refute page |> render() =~ "Fullscreen chart view"
  end

  test "modal_closed event reaches the Modal Controller", %{conn: conn} do
    {:ok, page, _html} = live(conn, "/dashboard")

    dashboard = find_live_child(page, "dashboard")
    chart_widget = find_live_child(dashboard, "chart-widget")

    # Verify initial state
    assert chart_widget |> render() =~ "Modal closed 0 times"

    # Open the modal
    chart_widget |> render_click("maximize")
    Process.sleep(1)
    assert page |> render() =~ "Fullscreen chart view"

    # Close the modal
    chart_fullscreen = find_live_child(page, "chart-fullscreen")
    chart_fullscreen |> render_click("close_modal")
    Process.sleep(1)

    # Verify the Modal Controller received the modal_closed event
    assert chart_widget |> render() =~ "Modal closed 1 times"

    # Open and close again to verify the count increments
    chart_widget |> render_click("maximize")
    Process.sleep(1)
    chart_fullscreen = find_live_child(page, "chart-fullscreen")
    chart_fullscreen |> render_click("close_modal")
    Process.sleep(1)

    assert chart_widget |> render() =~ "Modal closed 2 times"
  end

  test "Modal View can send events to Modal Controller via live_nest.modal", %{conn: conn} do
    {:ok, page, _html} = live(conn, "/dashboard")

    dashboard = find_live_child(page, "dashboard")
    chart_widget = find_live_child(dashboard, "chart-widget")

    # Verify initial state
    assert chart_widget |> render() =~ "Ping count: 0"

    # Open the modal
    chart_widget |> render_click("maximize")
    Process.sleep(1)
    assert page |> render() =~ "Fullscreen chart view"

    # Click ping button in the modal - this uses publish_event which routes via live_nest.modal.controller_pid
    chart_fullscreen = find_live_child(page, "chart-fullscreen")
    chart_fullscreen |> render_click("ping_controller")
    Process.sleep(1)

    # Verify the Modal Controller received the ping event
    assert chart_widget |> render() =~ "Ping count: 1"

    # Ping again
    chart_fullscreen |> render_click("ping_controller")
    Process.sleep(1)

    assert chart_widget |> render() =~ "Ping count: 2"
  end
end
