defmodule AdventOfCode2024.Day04 do
  @moduledoc """
  Day 4: Ceres Search
  """

  @doc """
  Count the number of times XMAS appears in the word search grid.
  XMAS can appear horizontally, vertically, diagonally, and backwards.
  """
  def part1(input) do
    grid =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)

    rows = length(grid)
    cols = length(Enum.at(grid, 0))

    # Search in all 8 directions
    directions = [
      # right
      {0, 1},
      # left
      {0, -1},
      # down
      {1, 0},
      # up
      {-1, 0},
      # down-right
      {1, 1},
      # down-left
      {1, -1},
      # up-right
      {-1, 1},
      # up-left
      {-1, -1}
    ]

    # For each position in the grid, try all directions
    for i <- 0..(rows - 1),
        j <- 0..(cols - 1),
        direction <- directions,
        reduce: 0 do
      count -> count + if check_xmas(grid, i, j, direction), do: 1, else: 0
    end
  end

  defp check_xmas(grid, row, col, {dr, dc}) do
    rows = length(grid)
    cols = length(Enum.at(grid, 0))
    target = ["X", "M", "A", "S"]

    # Check if we can fit XMAS in this direction from this position
    if row + 3 * dr >= 0 and row + 3 * dr < rows and
         col + 3 * dc >= 0 and col + 3 * dc < cols do
      # Get the four characters in this direction
      chars =
        for i <- 0..3 do
          grid
          |> Enum.at(row + i * dr)
          |> Enum.at(col + i * dc)
        end

      chars == target
    else
      false
    end
  end

  @doc """
  Count the number of X-MAS patterns in the grid.
  An X-MAS is formed by two MAS sequences in an X shape.
  Each MAS can be forwards or backwards.
  """
  def part2(input) do
    grid =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)

    rows = length(grid)
    cols = length(Enum.at(grid, 0))

    # For each position that could be the center of an X
    # We need to check positions that could be the center of a 3x3 pattern
    for i <- 1..(rows - 2),
        j <- 1..(cols - 2),
        reduce: 0 do
      count ->
        # Only proceed if this position is an 'A'
        if get_char(grid, i, j) == "A" do
          # Only check one diagonal direction (down-right)
          # This avoids double counting since each X-MAS pattern will be found twice otherwise
          d1 = {1, 1}
          d2 = {-1, 1}

          # Check if we can form an X-MAS pattern with these directions
          if check_pattern_at_center(grid, i, j, d1, d2) do
            count + 1
          else
            count
          end
        else
          count
        end
    end
  end

  defp check_pattern_at_center(grid, row, col, {dr1, dc1}, {dr2, dc2}) do
    rows = length(grid)
    cols = length(Enum.at(grid, 0))

    # Check if we can fit the patterns in both directions from the center A
    if row + dr1 >= 0 and row + dr1 < rows and row - dr1 >= 0 and row - dr1 < rows and
         col + dc1 >= 0 and col + dc1 < cols and col - dc1 >= 0 and col - dc1 < cols and
         row + dr2 >= 0 and row + dr2 < rows and row - dr2 >= 0 and row - dr2 < rows and
         col + dc2 >= 0 and col + dc2 < cols and col - dc2 >= 0 and col - dc2 < cols do
      # Get the characters in both directions
      chars1 = [
        get_char(grid, row - dr1, col - dc1),
        get_char(grid, row + dr1, col + dc1)
      ]

      chars2 = [
        get_char(grid, row - dr2, col - dc2),
        get_char(grid, row + dr2, col + dc2)
      ]

      # Check if we can form MAS patterns in either direction
      # We only need to check one direction (M-S) since S-M is just M-S backwards
      (chars1 == ["M", "S"] or chars1 == ["S", "M"]) and
        (chars2 == ["M", "S"] or chars2 == ["S", "M"])
    else
      false
    end
  end

  defp get_char(grid, row, col) do
    grid |> Enum.at(row) |> Enum.at(col)
  end
end
