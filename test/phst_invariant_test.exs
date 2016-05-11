
defmodule Sample do

  # do something with two lists
  # that will fail congruent but pass similar.
  def test(arg1, arg2) do
    if Enum.any?(arg1, fn(x) -> rem(x, 2) == 1 end) do
      Enum.zip(arg1, arg2)
    else
      Enum.with_index(arg2)
    end
  end

end


defmodule PhStInvariantTest do
  use ExUnit.Case
  doctest PhStInvariant

  test "Sample test" do
    assert Sample.test([2,4,6,8],[3,5]) == [{3, 0}, {5, 1}]
  end


end
