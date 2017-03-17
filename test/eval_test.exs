defmodule EvalTest do
  import HackBoat.Elixir.Eval
  use ExUnit.Case

  test "elixir_evaluation_basic" do
    assert evaluate_elixir(nil, "1 + 1") == 2
    assert evaluate_elixir(nil, "String.capitalize(\"foo\")") == "Foo"
  end

  test "elixir_evaluation_variable_definitions" do
    assert evaluate_elixir(nil, "foo = 3\nfoo") == 3
    assert evaluate_elixir(nil, "name = \"HackBoat\"\nString.at(name, 1)") == "a"
  end

  test "elixir_evaluation_functions" do
    assert evaluate_elixir(nil, "sum = fn (a, b) -> a + b end\nsum.(3, 5)") == 8
    assert evaluate_elixir(nil, "subtract = &(&1 - &2)\nsubtract.(4, 1)") == 3
    assert evaluate_elixir(nil, "sayhello = &(\"Hello from \" <> &1)\nsayhello.(\"ExUnit!\")") == "Hello from ExUnit!"
  end
end