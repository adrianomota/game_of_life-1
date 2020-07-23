defmodule GameOfLife.GridTest do
  use ExUnit.Case, async: true

  alias GameOfLife.Grid

  test "new/1 creates a grid with specified size" do
    size = 300
    grid = Grid.new(300)

    assert size == grid.size
  end

  test "new/1 initiates a multidimensional array of size" do
    size = 3
    grid = Grid.new(size)

    expected_grid = {
      {false, false, false},
      {false, false, false},
      {false, false, false}
    }

    assert expected_grid == grid.cells
  end

  test "activate/3 will activate specified cell" do
    size = 3
    grid =
      Grid.new(size)
      |> Grid.activate(1, 1)
      |> Grid.activate(2, 2)
      |> Grid.activate(3, 2)

    expected_grid = {
      {true, false, false},
      {false, true, false},
      {false, true, false}
    }
    assert expected_grid == grid.cells
  end

  test "deactivate/3 will deactivate specified cell" do
    size = 3
    grid =
      Grid.new(size)
      |> Grid.activate(1, 1)
      |> Grid.activate(2, 2)
      |> Grid.activate(3, 2)
      |> Grid.deactivate(2, 2)
      |> Grid.deactivate(3, 2)

    expected_grid = {
      {true, false, false},
      {false, false, false},
      {false, false, false}
    }
    assert expected_grid == grid.cells
  end

  test "glider will work as expected" do
    size = 5
    grid =
      Grid.new(size)
      |> Grid.activate(3, 1)
      |> Grid.activate(4, 2)
      |> Grid.activate(2, 3)
      |> Grid.activate(3, 3)
      |> Grid.activate(4, 3)

    expected =
      Grid.new(size)
      |> Grid.activate(2, 2)
      |> Grid.activate(4, 2)
      |> Grid.activate(3, 3)
      |> Grid.activate(4, 3)
      |> Grid.activate(3, 4)

    result = for x <- 1..size do
      for y <- 1..size do
        Grid.will_thrive?(grid, x, y)
      end
    end

    result =
      result
      |> Enum.map(&List.to_tuple/1)
      |> List.to_tuple()

    assert expected.cells == result
  end
end