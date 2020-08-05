defmodule GameOfLife.Game do
  @moduledoc """
  """

  alias GameOfLife.PetriDish

  @type t :: %__MODULE__{}

  defstruct [:world, :generation, :previous_generations]

  @spec new(PetriDish.t()) :: t
  def new(initial_world) do
    %__MODULE__{
      world: initial_world,
      generation: 1,
      previous_generations: []
    }
  end

  @doc """
  Activates a given cell on the current world grid
  """
  def activate_cell(game, x, y) do
    %{game | world: PetriDish.activate(game.world, x, y)}
  end

  @doc """
  Advances a generation on `game`.

  Does so by first identifying all cells that are meant to be analyzed within
  the world, then checking those cells individually to see if they should
  persist through the next generation (see `will_thrive?/3`) and then, finally,
  building a new world grid with all cells that should be active on the new
  generation.
  """
  def advance_generation(game) do
    current_state = game.world

    next_state =
      current_state
      |> PetriDish.cells_to_analyze()
      # [{x, y}]
      |> Enum.filter(fn {x, y} -> will_thrive?(current_state, x, y) end)
      # [{x, y}]
      |> Enum.reduce(PetriDish.clean(current_state), fn {x, y}, acc ->
        PetriDish.activate(acc, x, y)
      end)

    %__MODULE__{
      world: next_state,
      generation: game.generation + 1,
      previous_generations: [{game.generation, current_state} | game.previous_generations]
    }
  end

  @doc """
  Returns whether or not the cell in (`x`,`y`) should be active on the next
  generation given the current state of the `world`.

  A cell will be active on the next generation if:
    a) They are currently deactivated and have exactly 3 active neighbours
    b) They are currently activated and have between 2 and 3 neighbours
  In all other cases a cell would not thrive.
  """
  def will_thrive?(world, x, y) do
    neighbours = PetriDish.active_neighbours(world, x, y)
    active? = PetriDish.active?(world, x, y)

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
