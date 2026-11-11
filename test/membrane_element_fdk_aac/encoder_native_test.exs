defmodule Membrane.AAC.FDK.Encoder.NativeTest do
  use ExUnit.Case, async: true
  alias Membrane.AAC.FDK.Encoder.Native

  describe "Native AAC Encoder create should" do
    test "succeed for a supported configuration" do
      assert {:ok, _encoder_ref} = Native.create(2, 44_100, 2, 0, 0)
    end

    test "return an error, and release the partially initialised state, for a rejected configuration" do
      # The state is released on every error path, so its destructor runs on
      # a state whose buffer was never allocated.
      assert {:error, _reason} = Native.create(2, 12_345, 2, 0, 0)
      assert {:error, _reason} = Native.create(9, 44_100, 2, 0, 0)
      assert {:error, :invalid_vbr} = Native.create(2, 44_100, 2, 6, 0)
      :erlang.garbage_collect()
      assert {:ok, _encoder_ref} = Native.create(2, 44_100, 2, 0, 0)
    end
  end
end
