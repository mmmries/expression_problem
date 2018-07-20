defmodule MathProtocolTest do
  use ExUnit.Case
  doctest MathProtocol

  test "greets the world" do
    assert MathProtocol.hello() == :world
  end
end
