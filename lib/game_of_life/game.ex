defmodule GameOfLife.Game do

  alias GameOfLife.Grid

  defstruct [:world, :generation, :previous_generations]
  
  def new(options) do
    size = Keyword.get(options, :size, 32)

    grid = Grid.new(size)

    %__MODULE__{
      world: grid,
      generation: 1,
      previous_generations: []
    }
  end

  def activate_cell(game, x, y) do
    %{game | world: Grid.activate(game.world, x, y)}
  end

  def advance_generation(game) do
    current_state = game.world

    next_state = 
      current_state
      |> Grid.cells_to_analyze()
      # [{x, y}]
      |> Enum.filter(fn {x, y} -> will_thrive?(current_state, x, y) end)
      # [{x, y}]
      |> Enum.reduce(Grid.new(current_state.size), fn {x, y}, acc ->
        Grid.activate(acc, x, y)
      end)

    %__MODULE__{
      world: next_state,
      generation: game.generation + 1,
      previous_generations: [{game.generation, current_state} | game.previous_generations]
    }
  end

  def will_thrive?(world, x, y) do
    neighbours = Grid.active_neighbours(world, x, y)
    active? = Grid.active?(world, x, y)

    cond do
      # Qualquer célula viva com menos de dois vizinhos vivos morre de solidão.
      active? and neighbours < 2 ->
        false
      # Qualquer célula viva com mais de três vizinhos vivos morre de superpopulação.
      active? and neighbours > 3 ->
        false
      # Qualquer célula morta com exatamente três vizinhos vivos se torna uma célula viva.
      not active? and neighbours == 3 ->
        true
      # Qualquer célula viva com dois ou três vizinhos vivos continua no mesmo estado para a próxima geração.
      active? and neighbours in 2..3 ->
        true
      not active? ->
        false
    end
  end
end