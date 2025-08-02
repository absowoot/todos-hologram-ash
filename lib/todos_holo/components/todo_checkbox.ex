defmodule TodosHolo.Components.TodoCheckbox do
  use Hologram.Component

  prop :todo, :map

  
  def init(props, component) do
    component
    |> put_state(:todo, props.todo)
  end
  def init(params, component, _server) do
    component
    |> put_state(:todo, params.todo)
  end

  def template do
    ~HOLO"""
      {%if @todo.done}
        <input type="checkbox" id={@todo.id} $change="toggle_done" checked />
      {%else}
        <input type="checkbox" id={@todo.id} $change="toggle_done" />
      {/if}
      <label for={@todo.id} class={if @todo.done do "done" else "not-done" end}>{@todo.title}</label>
    """
  end

  def action(:toggle_done, %{event: %{value: value}}, component) do
    new_state = %{component.state.todo | done: value}

    component
    |> put_state(:todo, new_state)
    |> put_command(:toggle_done, todo: component.state.todo)
  end

  def command(:toggle_done, params, server) do
    if params.todo.done do
      Todos.List.set_done!(params.todo.id)
    else
      Todos.List.set_undone!(params.todo.id)
    end
    
    todos = Todos.List.list_todos!()
    

    server
    |> put_action(name: :refresh_todos, target: "page", params: %{todos: todos})
  end
end
