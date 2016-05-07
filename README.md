# PhStInvariant

**A Library for Creating Invariant functions based on ExUnit Assertions**

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

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add PhSt_invariant to your list of dependencies in `mix.exs`:

        def deps do
          [{:phst_invariant, "~> 0.0.1"}]
        end

  2. Ensure phst_invariant is started before your application:

        def application do
          [applications: [:phst_invariant]]
        end

