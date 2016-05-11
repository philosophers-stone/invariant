
defmodule Sample do

  # do something with two lists
  # that will fail congruent but pass similar.
  def test(arg1, arg2) do
    if Enum.any?(arg1, fn(x) -> rem(x, 2) == 1 end) do
      Enum.zip(arg1, arg2)
    else
      Enum.with_index(arg1)
    end
  end

end


defmodule PhStInvariantTest do
  use ExUnit.Case
  doctest PhStInvariant

  test "Sample test" do
    assert Sample.test([2,4,6,8],[3,5]) == [{2, 0}, {4, 1}, {6, 2}, {8, 3}]
    assert Sample.test([2,5,6,8],[3,5]) == [{2, 3}, {5, 5}]
  end

  test "congruent" do
    {pass, fail} = PhStInvariant.congruent(Sample, :test, [[2,4,5,8],[3,5]], [{2, 3}, {4, 5}], 10)
    refute fail == []
  end

  test "similar" do
    {pass, fail} = PhStInvariant.similar(Sample, :test, [[2,4,6,8],[3,5]], [{3, 0}, {5, 1}], 10)

    assert fail == []

  end

end
