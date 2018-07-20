defmodule Literal do
  defstruct [:number]
end

defmodule Add do
  defstruct [:left, :right]
end

defprotocol Printer do
  def show(expression)
end

defimpl Printer, for: Literal do
  def show(%Literal{number: number}), do: "#{number}"
end

defimpl Printer, for: Add do
  def show(%Add{left: left, right: right}) do
    "#{Printer.show(left)} + #{Printer.show(right)}"
  end
end

defmodule Negation do
  defstruct [:expression]

  defimpl Printer do
    def show(%Negation{expression: expression}) do
      "-(#{Printer.show(expression)})"
    end
  end
end

defprotocol Evaluator do
  def eval(expression)
end

defimpl Evaluator, for: Literal do
  def eval(%Literal{number: number}), do: number
end

defimpl Evaluator, for: Add do
  def eval(%Add{left: left, right: right}) do
    Evaluator.eval(left) + Evaluator.eval(right)
  end
end

defimpl Evaluator, for: Negation do
  def eval(%Negation{expression: expression}) do
    Evaluator.eval(expression) * -1
  end
end

ExUnit.start()

defmodule MathProtocolTest do
  use ExUnit.Case

  test "printing a literal" do
    two = %Literal{number: 2}
    assert Printer.show(two) == "2"
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
      right: %Add{
        left: %Literal{number: 4},
        right: %Literal{number: 5},
      }
    }
    assert Printer.show(addition) == "3 + 4 + 5"
  end

  test "printing negated literal" do
    neg = %Negation{expression: %Literal{number: 6}}
    assert Printer.show(neg) == "-(6)"
  end

  test "printing nested addition with negation" do
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

  test "eval'ing an expression" do
    expression = %Negation{
      expression: %Add{
        left: %Negation{expression: %Literal{number: 4}},
        right: %Add{
          left: %Literal{number: 4},
          right: %Literal{number: 3},
        }
      }
    }
    assert Evaluator.eval(expression) == -3
  end
end
