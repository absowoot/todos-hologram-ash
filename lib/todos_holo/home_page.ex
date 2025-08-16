defmodule TodosHolo.HomePage do
  use Hologram.Page

  alias TodosHolo.Components.TodoCheckbox
  alias TodosHolo.Components.AddTodo
  alias TodosHolo.Components.CleanupTodos

  route("/")

  layout(TodosHolo.MainLayout)

  def init(_params, component, _server) do
    todos = Todos.List.list_todos!()

    component
    |> put_state(:todos, todos)
  end

  def template do
    ~HOLO"""
    <h1>Todos</h1>

    <ul>
      {%for todo <- @todos}
        <li><TodoCheckbox cid={todo.id} todo={todo} /></li>
      {/for}
      </ul>
    <AddTodo cid="new_todo" todos={@todos} />

    <CleanupTodos done_count={Enum.count(@todos, & &1.done)} />

    <div class="show-it hidden">
    <h1>Howdy</h1>
    </div>
    """
  end

  def action(:add_todo, %{todo: todo}, component) do
    todos = component.state.todos ++ [todo]

    component
    |> put_state(:todos, todos)
  end

  def action(:refresh_todos, %{todos: todos}, component) do
    component
    |> put_state(:todos, todos)
  end

  def command(:cleanup_todos, _params, server) do
    status = Todos.List.done_todos!() |> Todos.List.cleanup_done(%{}) |> Map.get(:status, :error)

    todos =
      case status do
        :success -> Todos.List.list_todos!()
        :error -> []
      end

    server
    |> put_action(:refresh_todos, todos: todos)
  end
end
