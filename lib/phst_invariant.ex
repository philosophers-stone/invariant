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
  to test data in the false partition. This example only works for a function with a single argument.
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

    # This should really be an input.
    generate_input = fn ->
      Enum.map(args, fn arg -> PhStMutate.mutate(arg) end)
    end

    property(module, function, generate_input , success_funct, test_count)

  end

  def similar(module, function, args, result, test_count \\ 1000 ) do

    success_funct = PhStPhenetic.similar(result)

    generate_input = fn ->
      Enum.map(args, fn arg -> PhStMutate.mutate(arg) end)
    end

    property(module, function, generate_input , success_funct, test_count)
  end

  @doc """
  Returns a tuple of lists of input data, one list passes the success_test and one does not.

  The input is a function to generate input, a function that returns t/f based on whether
  the input passes the test or not and a test_count.
  """
  def property(module, function, input_generator, success_test, test_count) do

    Stream.repeatedly(input_generator)
    |> Stream.take(test_count)
    |> Enum.partition(fn input -> success_test.(Kernel.apply(module, function, input)) end )

  end

end
