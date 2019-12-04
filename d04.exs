defmodule P1 do
  def count(str) do
    [lo, hi] = String.split(str, "-")
    String.to_integer(lo)..String.to_integer(hi)
    |> Enum.filter(&ok?/1)
    |> Enum.count
  end

  defp ok?(n) do
    digits = Integer.digits(n)
    increasing?(digits) and repeats?(digits)
  end

  defp increasing?(digits) do
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

P1.count("146810-612564")
|> IO.inspect(label: "Part 1 Answer")
