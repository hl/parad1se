defmodule Paradise.Random do
  defmodule String do
    use Puid, chars: :alpha, bits: 16
  end
end
