defmodule GameOfLife.World.Binary do
  defstruct [:size, :cells]

  @type t :: %__MODULE__{
          size: pos_integer(),
          cells: binary
        }

  def new(size) do
    %__MODULE__{
      size: size,
      cells: init_cells(size)
    }
  end

  defp init_cells(size) do
    area = size * size
    <<0::size(area)>>
  end
end
