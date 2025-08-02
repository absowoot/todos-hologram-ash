defmodule TodosHolo.Components.CleanupTodos do
  use Hologram.Component

  prop :done_count, :integer, default: 0

  def template() do
    ~HOLO"""
    {%if @done_count > 0}
      <div>
        <button $click={command: :cleanup_todos} class="button-destroy">Cleanup {@done_count} Todos</button>
      </div>
    {/if}
    """
  end
end
