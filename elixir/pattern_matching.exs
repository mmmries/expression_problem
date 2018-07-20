# To test this just run `elixir pattern_matching.exs` from the command line

defmodule Literal do
  defstruct [:number]
end

defmodule Add do
  defstruct [:left, :right]
end

defmodule Negation do
  defstruct [:expression]
end

defmodule Printer do
  def show(%Literal{number: num}), do: "#{num}"
  def show(%Add{left: left, right: right}), do: "#{show(left)} + #{show(right)}"
  def show(%Negation{expression: expression}), do: "-(#{show(expression)})"
end

defmodule Evaluator do
  def eval(%Literal{number: num}), do: num
  def eval(%Add{left: left, right: right}), do: eval(left) + eval(right)
  def eval(%Negation{expression: expression}), do: eval(expression) * -1
end

ExUnit.start()

defmodule PatternMatchingTest do
  use ExUnit.Case

  test "printing a literal" do
    two = %Literal{number: 2}
    assert Printer.show(two) == "2"
  end

  test "printing negated literal" do
    two = %Negation{expression: %Literal{number: 2}}
    assert Printer.show(two) == "-(2)"
  end

  test "printing an addition" do
    three = %Literal{number: 3}
    four = %Literal{number: 4}
    five = %Literal{number: 5}
    three_and_four = %Add{left: three, right: four}
    assert Printer.show(three_and_four) == "3 + 4"
    four_and_five = %Add{left: four, right: five}
    assert Printer.show(four_and_five) == "4 + 5"
  end

  test "printing nested addition" do
    addition = %Add{
      left: %Literal{number: 3},
      right: %Negation{expression:
        %Add{
          left: %Literal{number: 4},
          right: %Literal{number: 5},
        }
      }
    }
    assert Printer.show(addition) == "3 + -(4 + 5)"
  end

  test "eval a literal" do
    assert Evaluator.eval(%Literal{number: 3}) == 3
  end

  test "eval an addition" do
    assert Evaluator.eval(
      %Add{
        left: %Literal{number: 3},
        right: %Literal{number: 2},
      }
    ) == 5
  end

  test "eval nested addition" do
    assert Evaluator.eval(
      %Add{
        left: %Add{
          left: %Literal{number: 3},
          right: %Negation{expression: %Literal{number: 7}},
        },
        right: %Literal{number: 2},
      }
    ) == -2
  end
end
