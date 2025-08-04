defmodule TodosHolo.Components.AddTodo do
  use Hologram.Component

  prop :title, :string, default: ""

  def template do
    ~HOLO"""
    <form $submit="add_todo">
      <input type="text" placeholder="Add a new todo" name="title" value={@title} />
      <button type="submit" class="button">Add</button>
    </form>
    """
  end

  def action(:add_todo, %{event: %{"title" => title}}, component) do
    component
    # Reset the title after adding a todo (value is not updated in the dom)
    |> put_state(:title, "")
    |> put_command(:add_todo, title: title)
  end

  def command(:add_todo, params, server) do
    todo = Todos.List.create_todo!(params.title)
    
    server
    |> put_action(name: :add_todo, target: "page", params: %{todo: todo})
  end
end
