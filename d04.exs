defmodule P1 do
  def count(str, func \\ &ok?/1) do
    [lo, hi] = String.split(str, "-")
    String.to_integer(lo)..String.to_integer(hi)
    |> Enum.filter(func)
    |> Enum.count
  end

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

P1.count("146810-612564")
|> IO.inspect(label: "Part 1 Answer") # 1748

P1.count("146810-612564", &P2.ok?/1)
|> IO.inspect(label: "Part 2 Answer") # 1180
