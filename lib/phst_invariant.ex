defmodule PhStInvariant do

  @moduledoc """
  The long term goal of this library is allow developers to create property style
  tests based on existing ExUnit assert statements. For example:

    assert URI.encode_query([{"foo z", :bar}]) == "foo+z=bar"

  This should be converted to the following code

      success_funct = PhStPhenetic.congruent("foo+z=bar")

      generate_input = fn ->
        PhStPhenetic.mutate([{"foo z", :bar}])
      end

      Stream.repeatedly(generate_input)
      |> Enum.take(@test_number)
      |> Enum.partition( fn input -> success_funct.(URI.encode_query(input)) end )

  That should produce an List of inputs for which the output is not congruent
  to test data in the false partition. This example is only works for a function with a single argument.
  It needs to be extended to use Kernel.apply for functions that take many arguments.

  An alternative approach would be to put a timer around it and run as many as possible
  in a given interval.
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

    generate_input = fn ->
      Enum.map(args, fn arg -> PhStMutate.mutate(arg) end)
    end

    Stream.repeatedly(generate_input)
    |> Stream.take(test_count)
    |> Enum.partition(fn input -> success_funct.(Kernel.apply(module, function, input)) end )

  end

  def similar(module, function, args, result, test_count \\ 1000 ) do

    success_funct = PhStPhenetic.similar(result)

    #umm love me some copypasta... refactor this into it's own function.
    generate_input = fn ->
      Enum.map(args, fn arg -> PhStMutate.mutate(arg) end)
    end

    Stream.repeatedly(generate_input)
    |> Stream.take(test_count)
    |> Enum.partition(fn input -> success_funct.(Kernel.apply(module, function, input)) end )

  end

end
