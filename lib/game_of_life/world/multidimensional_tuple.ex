defmodule GameOfLife.World.MultidimensionalTuple do
  defstruct [:size, :cells]

  @type t :: %__MODULE__{
          size: pos_integer(),
          cells: tuple()
        }

  def new(size) do
    %__MODULE__{
      size: size,
      cells: init_cells(size)
    }
  end

  defp init_cells(size) do
    List.duplicate(false, size)
    |> List.to_tuple()
    |> List.duplicate(size)
    |> List.to_tuple()
  end
end

defimpl GameOfLife.PetriDish, for: GameOfLife.World.MultidimensionalTuple do
  def clean(grid) do
    GameOfLife.World.MultidimensionalTuple.new(grid.size)
  end

  def activate(grid, x, y) do
    change_cell_state(grid, x, y, true)
  end

  def deactivate(grid, x, y) do
    change_cell_state(grid, x, y, false)
  end

  def active?(grid, x, y) do
    grid.cells
    |> elem(x - 1)
    |> elem(y - 1)
  end

  def cells_to_analyze(grid) do
    for x <- 1..grid.size, y <- 1..grid.size do
      {x, y}
    end
  end

  defp change_cell_state(grid, x, y, value) do
    new_row =
      grid.cells
      |> elem(x - 1)
      |> put_elem(y - 1, value)

    cells = put_elem(grid.cells, x - 1, new_row)
    %__MODULE__{grid | cells: cells}
  end

  def active_neighbours(grid, x, y) do
    grid
    # [{pos_integer, pos_integer}]
    |> neighbours(x, y)
    # [true, false]
    |> Enum.map(fn {x2, y2} -> active?(grid, x2, y2) end)
    |> Enum.count(&(&1 == true))
  end

  defp neighbours(grid, x, y) do
    limit = grid.size

    for x2 <- (x - 1)..(x + 1),
        y2 <- (y - 1)..(y + 1),
        x2 in 1..limit,
        y2 in 1..limit,
        x2 != x or y2 != y do
      {x2, y2}
    end
  end
end
