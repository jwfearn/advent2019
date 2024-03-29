# https://adventofcode.com/2019/day/2

defmodule P1 do
  def input() do
    {
      1,
      0,
      0,
      3,
      1,
      1,
      2,
      3,
      1,
      3,
      4,
      3,
      1,
      5,
      0,
      3,
      2,
      1,
      13,
      19,
      1,
      9,
      19,
      23,
      1,
      6,
      23,
      27,
      2,
      27,
      9,
      31,
      2,
      6,
      31,
      35,
      1,
      5,
      35,
      39,
      1,
      10,
      39,
      43,
      1,
      43,
      13,
      47,
      1,
      47,
      9,
      51,
      1,
      51,
      9,
      55,
      1,
      55,
      9,
      59,
      2,
      9,
      59,
      63,
      2,
      9,
      63,
      67,
      1,
      5,
      67,
      71,
      2,
      13,
      71,
      75,
      1,
      6,
      75,
      79,
      1,
      10,
      79,
      83,
      2,
      6,
      83,
      87,
      1,
      87,
      5,
      91,
      1,
      91,
      9,
      95,
      1,
      95,
      10,
      99,
      2,
      9,
      99,
      103,
      1,
      5,
      103,
      107,
      1,
      5,
      107,
      111,
      2,
      111,
      10,
      115,
      1,
      6,
      115,
      119,
      2,
      10,
      119,
      123,
      1,
      6,
      123,
      127,
      1,
      127,
      5,
      131,
      2,
      9,
      131,
      135,
      1,
      5,
      135,
      139,
      1,
      139,
      10,
      143,
      1,
      143,
      2,
      147,
      1,
      147,
      5,
      0,
      99,
      2,
      0,
      14,
      0
    }
  end

  def run(codes, i \\ 0) when is_tuple(codes) do
    case elem(codes, i) do
      99 -> codes
      1 -> run(put(codes, i + 3, get(codes, i + 2) + get(codes, i + 1)), i + 4)
      2 -> run(put(codes, i + 3, get(codes, i + 2) * get(codes, i + 1)), i + 4)
    end
  end

  defp put(tuple, i, value), do: put_elem(tuple, elem(tuple, i), value)

  defp get(tuple, i), do: elem(tuple, elem(tuple, i))
end

defmodule P2 do
  def result_for(noun, verb, codes) do
    codes
    |> put_elem(1, noun)
    |> put_elem(2, verb)
    |> P1.run()
    |> elem(0)
  end

  def find(target, codes) do
    Stream.flat_map(
      0..99,
      fn noun ->
        Stream.flat_map(
          0..99,
          fn verb ->
            if result_for(noun, verb, codes) == target do
              [(100 * noun) + verb]
            else
              []
            end
          end
        )
      end
    )
    |> Enum.at(0)
  end
end

ExUnit.start()

defmodule P1Test do
  use ExUnit.Case

  test "a" do
    actual = P1.run({1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50})
    expected = {3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50}
    assert actual == expected
  end

  test "b" do
    actual = P1.run({1, 0, 0, 0, 99})
    expected = {2, 0, 0, 0, 99}
    assert actual == expected
  end

  test "c" do
    actual = P1.run({2, 3, 0, 3, 99})
    expected = {2, 3, 0, 6, 99}
    assert actual == expected
  end

  test "d" do
    actual = P1.run({2, 4, 4, 5, 99, 0})
    expected = {2, 4, 4, 5, 99, 9801}
    assert actual == expected
  end

  test "e" do
    actual = P1.run({1, 1, 1, 4, 99, 5, 6, 0, 99})
    expected = {30, 1, 1, 4, 2, 5, 6, 0, 99}
    assert actual == expected
  end
end

defmodule P2Test do
  use ExUnit.Case

  test "a" do
    assert 5305097 == P2.result_for(12, 2, P1.input)
  end

  test "b" do
    assert 4925 == P2.find(19690720, P1.input)
  end
end


P2.result_for(12, 2, P1.input)
|> IO.inspect(label: "Part 1 Answer")

P2.find(19690720, P1.input)
|> IO.inspect(label: "Part 2 Answer")
