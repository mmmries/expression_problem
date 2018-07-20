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
