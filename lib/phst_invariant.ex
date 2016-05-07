defmodule PhStInvariant do
  import PhStPhenetic

  @moduledoc """
  The long term goal of this library is allow developers to create property style
  tests based on existing ExUnit assert statements. For example:

    assert URI.encode_query([{"foo z", :bar}]) == "foo+z=bar"

  This should be converted to the following code

      success_funct = PhStPhenetic.congruent("foo+z=bar")

      test_func = fn ->
        PhStPhenetic.mutate([{"foo z", :bar}])
      end

      Stream.repeatedly(test_func)
      |> Enum.take(@test_number)
      |> Stream.map(fn x -> URI.encode_query(x) end )
      |> Enum.filter(fn x -> success_funct.(x) == false end)

  That should produce an List of inputs for which the output is not congruent
  to test data. This example is only works for a function with a single argument.
  It needs to be extended to use Kernel.apply for functions that take many arguments.
  """

  @doc """
  Return a List of inputs for which function returns a value that
  is not congruent to the supplied result. The module, function, args
  are copied from the inputs for Kernel.apply.

  From the example in the module docs.
    congruent(URI, :encode_query, [[{"foo z", :bar}]], "foo+z=bar")
  """
  def congruent(module, function, args, result, test_count \\ 1000 ) do

    success_funct = PhStPhenetic.congruent(result)

    test_func = fn ->
      Enum.map(args, fn arg -> PhStPhenetic.mutate(arg) end)
    end

    Stream.repeatedly(test_func)
    |> Enum.take(test_count)
    |> Stream.map(fn input -> Kernel.apply(module, function, input) end )
    |> Enum.filter(fn output -> success_funct.(output) == false end )

  end
end
