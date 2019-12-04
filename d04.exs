defmodule P1 do
  def count(str, func \\ &ok?/1) do
    str
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
    |> to_range
    |> Enum.filter(func)
    |> Enum.count
  end

  defp to_range([lo, hi]), do: lo..hi

  def ok?(n) do
    digits = Integer.digits(n)
    increasing?(digits) and repeats?(digits)
  end

  def increasing?(digits) do
    digits
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> a <= b end)
  end

  defp repeats?(digits) do
    digits
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.any?(fn [a, b] -> a == b end)
  end
end

defmodule P2 do
  def count(str, func \\ &ok?/1), do: P1.count(str, func)

  def ok?(n) do
    digits = Integer.digits(n)
    P1.increasing?(digits) and Enum.member?(run_lengths(digits), 2)
  end

  defp run_lengths(digits) do
    digits
    |> Enum.reduce(%{}, fn digit, map -> Map.put(map, digit, Map.get(map, digit, 0) + 1) end)
    |> Map.values
  end
end

ExUnit.start()

defmodule P1Test do
  use ExUnit.Case
  test "answer", do: assert P1.count("146810-612564") == 1748
end

defmodule P2Test do
  use ExUnit.Case
  test "answer", do: assert P2.count("146810-612564") == 1180
end

P1.count("146810-612564")
|> IO.inspect(label: "Part 1 Answer")

P1.count("146810-612564", &P2.ok?/1)
|> IO.inspect(label: "Part 2 Answer")
