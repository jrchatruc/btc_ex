defmodule BtcExTest do
  use ExUnit.Case
  doctest BtcEx

  test "greets the world" do
    assert BtcEx.hello() == :world
  end
end
